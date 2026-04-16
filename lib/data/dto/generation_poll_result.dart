import '../../domain/entities/job_status.dart';

class GenerationPollResult {
  const GenerationPollResult({
    required this.status,
    this.imageUrls = const <String>[],
    this.message,
  });

  final JobStatus status;
  final List<String> imageUrls;
  final String? message;
}
