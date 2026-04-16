import '../../domain/ai/ai_generation_provider.dart';
import '../../domain/ai/ai_provider_id.dart';
import '../../domain/entities/job_status.dart';
import '../api/kling_remote_data_source.dart';
import '../dto/generation_request_dto.dart';

class KlingAiGenerationProvider implements AiGenerationProvider {
  KlingAiGenerationProvider(this._remoteDataSource);

  final KlingRemoteDataSource _remoteDataSource;

  @override
  AiProviderId get id => AiProviderId.kling;

  @override
  String get displayName => 'Kling';

  @override
  bool get isImageGenerationSupported => true;

  @override
  Future<SubmitGenerationOutcome> submitGeneration({
    required String prompt,
    String? imagePath,
  }) async {
    final result = await _remoteDataSource.submitImageGeneration(
      GenerationRequestDto(prompt: prompt, imagePath: imagePath),
    );
    return SubmitGenerationOutcome(
      taskId: result.taskId,
      imageUrls: result.imageUrls,
    );
  }

  @override
  Future<PollGenerationOutcome> pollTask({required String taskId}) async {
    final result = await _remoteDataSource.pollImageGeneration(taskId);
    if (result.status == JobStatus.completed && result.imageUrls.isEmpty) {
      return PollGenerationOutcome(
        status: JobStatus.failed,
        message: result.message ?? 'Completed without image URLs.',
      );
    }
    return PollGenerationOutcome(
      status: result.status,
      imageUrls: result.imageUrls,
      message: result.message,
    );
  }
}
