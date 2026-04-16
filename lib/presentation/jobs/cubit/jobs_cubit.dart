import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/config/kling_api_config.dart';
import '../../../core/error/exceptions.dart';
import '../../../data/ai_generation_provider_registry.dart';
import '../../../data/local/job_result_image_storage.dart';
import '../../../domain/ai/ai_generation_provider.dart';
import '../../../domain/ai/ai_provider_id.dart';
import '../../../domain/entities/generation_job.dart';
import '../../../domain/entities/job_media_result.dart';
import '../../../domain/entities/job_metadata.dart';
import '../../../domain/entities/job_status.dart';
import '../../../domain/job_repository.dart';
import '../../../l10n/locale_bridge.dart';
import 'jobs_state.dart';

class JobsCubit extends Cubit<JobsState> {
  JobsCubit({
    required JobRepository jobRepository,
    required AiGenerationProviderRegistry providerRegistry,
    required KlingApiConfig klingApiConfig,
    required JobResultImageStorage imageStorage,
  }) : _jobRepository = jobRepository,
       _registry = providerRegistry,
       _config = klingApiConfig,
       _imageStorage = imageStorage,
       super(const JobsState()) {
    unawaited(_loadInitial());
    _pollTimer = Timer.periodic(
      const Duration(milliseconds: 2500),
      (_) => unawaited(_onPollTick()),
    );
  }

  final JobRepository _jobRepository;
  final AiGenerationProviderRegistry _registry;
  final KlingApiConfig _config;
  final JobResultImageStorage _imageStorage;
  final Uuid _uuid = const Uuid();

  Timer? _pollTimer;

  int _generatePrefillNonce = 0;

  Future<void> _loadInitial() async {
    final List<GenerationJob> loaded = await _jobRepository.loadJobs();
    loaded.sort(
      (GenerationJob a, GenerationJob b) => b.createdAt.compareTo(a.createdAt),
    );
    if (!isClosed) {
      emit(state.copyWith(jobs: loaded));
    }
  }

  void beginGenerateEditFromHistory(GenerationJob job) {
    _generatePrefillNonce++;
    emit(
      state.copyWith(
        generatePrefill: GeneratePrefill(
          sourceJobId: job.id,
          prompt: job.prompt,
          imagePath: job.metadata.imagePath,
          token: _generatePrefillNonce,
        ),
        requestGenerateTabFocus: true,
      ),
    );
  }

  void acknowledgeGenerateTabFocus() {
    if (!state.requestGenerateTabFocus) {
      return;
    }
    emit(state.copyWith(requestGenerateTabFocus: false));
  }

  void clearGeneratePrefillPayload() {
    emit(state.copyWith(clearGeneratePrefill: true));
  }

  void submitFromGenerateEditor({
    required String prompt,
    String? imagePath,
    String? linkedHistoryJobId,
    String? baselinePrompt,
    String? baselineImagePath,
    AiProviderId providerId = AiProviderId.kling,
  }) {
    final String trimmed = prompt.trim();
    if (trimmed.isEmpty) {
      return;
    }
    if (linkedHistoryJobId != null && baselinePrompt != null) {
      if (trimmed == baselinePrompt.trim() &&
          _nullablePathsEqual(imagePath, baselineImagePath)) {
        final GenerationJob? job = _jobById(linkedHistoryJobId);
        if (job != null) {
          rerunHistoryJob(job);
          return;
        }
      }
    }
    enqueueGeneration(
      prompt: trimmed,
      imagePath: imagePath,
      providerId: providerId,
    );
  }

  bool _nullablePathsEqual(String? a, String? b) {
    if (a == null && b == null) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }
    return a == b;
  }

  void enqueueGeneration({
    required String prompt,
    String? imagePath,
    AiProviderId providerId = AiProviderId.kling,
  }) {
    final String trimmed = prompt.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final String jobId = _uuid.v4();
    final GenerationJob job = GenerationJob(
      id: jobId,
      prompt: trimmed,
      status: JobStatus.pending,
      createdAt: DateTime.now().toUtc(),
      results: const <JobMediaResult>[],
      metadata: JobMetadata(
        modelName: _config.imageModelName,
        providerId: providerId.name,
        imagePath: imagePath,
      ),
    );
    _replaceOrInsert(job);
    unawaited(_runSubmitPipeline(jobId, providerId));
  }

  void rerunHistoryJob(GenerationJob job) {
    if (job.status == JobStatus.pending || job.status == JobStatus.processing) {
      return;
    }
    if (job.status == JobStatus.failed) {
      if (job.canRetry) {
        retryJob(job.id);
      }
      return;
    }
    final String jobId = job.id;
    final AiProviderId providerId = AiProviderId.values.firstWhere(
      (AiProviderId e) => e.name == job.metadata.providerId,
      orElse: () => AiProviderId.kling,
    );
    _replaceJobAtFront(
      jobId,
      (GenerationJob j) => j.copyWith(
        status: JobStatus.pending,
        createdAt: DateTime.now().toUtc(),
        metadata: j.metadata.copyWith(clearExternalTaskId: true),
        clearLastError: true,
      ),
    );
    unawaited(_runSubmitPipeline(jobId, providerId));
  }

  void retryJob(String jobId) {
    final GenerationJob? job = _jobById(jobId);
    if (job == null || !job.canRetry) {
      return;
    }
    final AiProviderId providerId = AiProviderId.values.firstWhere(
      (AiProviderId e) => e.name == job.metadata.providerId,
      orElse: () => AiProviderId.kling,
    );
    _replaceJobAtFront(
      jobId,
      (GenerationJob j) => j.copyWith(
        status: JobStatus.pending,
        createdAt: DateTime.now().toUtc(),
        metadata: j.metadata.copyWith(clearExternalTaskId: true),
        retryCount: j.retryCount + 1,
        clearLastError: true,
      ),
    );
    unawaited(_runSubmitPipeline(jobId, providerId));
  }

  void deleteAllJobsWithPrompt(String prompt) {
    final List<GenerationJob> next = state.jobs
        .where((GenerationJob j) => j.prompt != prompt)
        .toList();
    if (next.length == state.jobs.length) {
      return;
    }
    emit(state.copyWith(jobs: next));
    unawaited(_persist());
  }

  void deleteResult({required String jobId, required String resultId}) {
    _updateJob(jobId, (GenerationJob j) {
      final List<JobMediaResult> filtered = j.results
          .where((JobMediaResult r) => r.id != resultId)
          .toList();
      return j.copyWith(results: filtered);
    });
  }

  Future<String?> toggleResultLocalSave({
    required String jobId,
    required String resultId,
  }) async {
    final GenerationJob? job = _jobById(jobId);
    if (job == null) {
      return resolveAppLocalizationsFromPlatform().errorGenerationNotFound;
    }
    JobMediaResult? target;
    for (final JobMediaResult r in job.results) {
      if (r.id == resultId) {
        target = r;
        break;
      }
    }
    if (target == null) {
      return resolveAppLocalizationsFromPlatform().errorImageNotFound;
    }
    if (target.savedToGallery) {
      _updateJob(
        jobId,
        (GenerationJob j) => j.copyWith(
          results: j.results
              .map(
                (JobMediaResult r) =>
                    r.id == resultId ? r.copyWith(savedToGallery: false) : r,
              )
              .toList(),
        ),
      );
      return null;
    }
    try {
      await _imageStorage.saveToGalleryFromUrl(target.imageUrl);
      _updateJob(
        jobId,
        (GenerationJob j) => j.copyWith(
          results: j.results
              .map(
                (JobMediaResult r) =>
                    r.id == resultId ? r.copyWith(savedToGallery: true) : r,
              )
              .toList(),
        ),
      );
      return null;
    } on Object catch (e) {
      return e.toString();
    }
  }

  Future<void> _runSubmitPipeline(String jobId, AiProviderId providerId) async {
    final GenerationJob? initial = _jobById(jobId);
    if (initial == null) {
      return;
    }
    final l10n = resolveAppLocalizationsFromPlatform();
    final AiGenerationProvider provider = _registry.resolve(providerId);
    if (!provider.isImageGenerationSupported) {
      _updateJob(
        jobId,
        (GenerationJob j) => j.copyWith(
          status: JobStatus.failed,
          lastError: l10n.errorProviderNotAvailable(provider.displayName),
        ),
      );
      return;
    }
    _updateJob(
      jobId,
      (GenerationJob j) => j.copyWith(status: JobStatus.processing),
    );
    try {
      final SubmitGenerationOutcome outcome = await provider.submitGeneration(
        prompt: initial.prompt,
        imagePath: initial.metadata.imagePath,
      );
      if (outcome.imageUrls.isNotEmpty) {
        _completeWithUrls(jobId, outcome.imageUrls);
        return;
      }
      final String? taskId = outcome.taskId;
      if (taskId == null || taskId.isEmpty) {
        _updateJob(
          jobId,
          (GenerationJob j) => j.copyWith(
            status: JobStatus.failed,
            lastError: l10n.errorNoTaskIdFromProvider,
          ),
        );
        return;
      }
      _updateJob(
        jobId,
        (GenerationJob j) => j.copyWith(
          metadata: j.metadata.copyWith(externalTaskId: taskId),
          status: JobStatus.processing,
        ),
      );
    } on ServerException catch (e) {
      _updateJob(
        jobId,
        (GenerationJob j) =>
            j.copyWith(status: JobStatus.failed, lastError: e.message),
      );
    } on Object catch (e) {
      _updateJob(
        jobId,
        (GenerationJob j) =>
            j.copyWith(status: JobStatus.failed, lastError: e.toString()),
      );
    }
  }

  void _completeWithUrls(String jobId, List<String> urls) {
    if (urls.isEmpty) {
      return;
    }
    final JobMediaResult result = JobMediaResult(
      id: _uuid.v4(),
      imageUrl: urls.first,
    );
    _updateJob(
      jobId,
      (GenerationJob j) => j.copyWith(
        status: JobStatus.completed,
        results: <JobMediaResult>[...j.results, result],
        clearLastError: true,
      ),
    );
  }

  Future<void> _onPollTick() async {
    if (isClosed) {
      return;
    }
    final List<GenerationJob> processing = state.jobs
        .where(
          (GenerationJob j) =>
              j.status == JobStatus.processing &&
              (j.metadata.externalTaskId != null &&
                  j.metadata.externalTaskId!.isNotEmpty),
        )
        .toList();
    final l10n = resolveAppLocalizationsFromPlatform();
    for (final GenerationJob job in processing) {
      if (isClosed) {
        return;
      }
      final String taskId = job.metadata.externalTaskId!;
      try {
        final AiGenerationProvider provider = _registry.resolveForMetadata(
          job.metadata,
        );
        final PollGenerationOutcome poll = await provider.pollTask(
          taskId: taskId,
        );
        if (poll.status == JobStatus.completed) {
          if (poll.imageUrls.isEmpty) {
            _updateJob(
              job.id,
              (GenerationJob j) => j.copyWith(
                status: JobStatus.failed,
                lastError: poll.message ?? l10n.errorNoImagesReturned,
              ),
            );
          } else {
            _completeWithUrls(job.id, poll.imageUrls);
          }
        } else if (poll.status == JobStatus.failed) {
          _updateJob(
            job.id,
            (GenerationJob j) => j.copyWith(
              status: JobStatus.failed,
              lastError: poll.message ?? l10n.errorGenerationFailed,
            ),
          );
        }
      } on Object {
        // Keep processing; next poll may succeed after transient errors.
      }
    }
  }

  GenerationJob? _jobById(String id) {
    for (final GenerationJob j in state.jobs) {
      if (j.id == id) {
        return j;
      }
    }
    return null;
  }

  void _replaceOrInsert(GenerationJob job) {
    final List<GenerationJob> next = List<GenerationJob>.from(state.jobs)
      ..removeWhere((GenerationJob j) => j.id == job.id)
      ..insert(0, job);
    emit(state.copyWith(jobs: next));
    unawaited(_persist());
  }

  void _replaceJobAtFront(
    String jobId,
    GenerationJob Function(GenerationJob) transform,
  ) {
    final GenerationJob? current = _jobById(jobId);
    if (current == null) {
      return;
    }
    final GenerationJob updated = transform(current);
    final List<GenerationJob> next = state.jobs
        .where((GenerationJob j) => j.id != jobId)
        .toList();
    next.insert(0, updated);
    emit(state.copyWith(jobs: next));
    unawaited(_persist());
  }

  void _updateJob(String id, GenerationJob Function(GenerationJob) transform) {
    final int idx = state.jobs.indexWhere((GenerationJob j) => j.id == id);
    if (idx < 0) {
      return;
    }
    final List<GenerationJob> next = List<GenerationJob>.from(state.jobs);
    next[idx] = transform(next[idx]);
    emit(state.copyWith(jobs: next));
    unawaited(_persist());
  }

  Future<void> _persist() async {
    await _jobRepository.saveJobs(state.jobs);
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }
}
