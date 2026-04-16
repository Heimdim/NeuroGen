import '../../core/error/exceptions.dart';
import '../../domain/ai/ai_generation_provider.dart';
import '../../domain/ai/ai_provider_id.dart';

class UnsupportedImageAiProvider implements AiGenerationProvider {
  UnsupportedImageAiProvider({required this.id, required this.displayName});

  @override
  final AiProviderId id;

  @override
  final String displayName;

  @override
  bool get isImageGenerationSupported => false;

  @override
  Future<SubmitGenerationOutcome> submitGeneration({
    required String prompt,
    String? imagePath,
  }) async {
    throw ServerException(
      '$displayName image generation is not available in this build.',
    );
  }

  @override
  Future<PollGenerationOutcome> pollTask({required String taskId}) async {
    throw ServerException('$displayName does not support image task polling.');
  }
}
