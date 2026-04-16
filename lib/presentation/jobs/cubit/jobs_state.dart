import '../../../domain/entities/generation_job.dart';

class GeneratePrefill {
  const GeneratePrefill({
    required this.sourceJobId,
    required this.prompt,
    required this.token,
    this.imagePath,
  });

  final String sourceJobId;
  final String prompt;
  final String? imagePath;
  final int token;
}

class JobsState {
  const JobsState({
    this.jobs = const <GenerationJob>[],
    this.generatePrefill,
    this.requestGenerateTabFocus = false,
  });

  final List<GenerationJob> jobs;
  final GeneratePrefill? generatePrefill;
  final bool requestGenerateTabFocus;

  static const Object _unset = Object();

  JobsState copyWith({
    List<GenerationJob>? jobs,
    Object? generatePrefill = _unset,
    Object? requestGenerateTabFocus = _unset,
    bool clearGeneratePrefill = false,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      generatePrefill: clearGeneratePrefill
          ? null
          : (identical(generatePrefill, _unset)
                ? this.generatePrefill
                : generatePrefill as GeneratePrefill?),
      requestGenerateTabFocus: identical(requestGenerateTabFocus, _unset)
          ? this.requestGenerateTabFocus
          : requestGenerateTabFocus as bool,
    );
  }
}
