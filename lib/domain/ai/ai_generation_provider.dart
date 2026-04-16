import '../entities/job_status.dart';
import 'ai_provider_id.dart';

abstract class AiGenerationProvider {
  AiProviderId get id;

  String get displayName;

  bool get isImageGenerationSupported;

  Future<SubmitGenerationOutcome> submitGeneration({
    required String prompt,
    String? imagePath,
  });

  Future<PollGenerationOutcome> pollTask({required String taskId});
}

class SubmitGenerationOutcome {
  const SubmitGenerationOutcome({
    this.taskId,
    this.imageUrls = const <String>[],
  });

  final String? taskId;
  final List<String> imageUrls;
}

class PollGenerationOutcome {
  const PollGenerationOutcome({
    required this.status,
    this.imageUrls = const <String>[],
    this.message,
  });

  final JobStatus status;
  final List<String> imageUrls;
  final String? message;
}
