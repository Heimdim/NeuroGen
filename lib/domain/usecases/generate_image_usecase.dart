import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../entities/generated_image.dart';
import '../generation_repository.dart';

class GenerateImageUseCase {
  GenerateImageUseCase(this._repository);

  final GenerationRepository _repository;

  Future<Result<GeneratedImage>> call({
    required String prompt,
    String? imagePath,
  }) async {
    final trimmedPrompt = prompt.trim();
    if (trimmedPrompt.isEmpty) {
      return const Error<GeneratedImage>(
        ValidationFailure('Prompt cannot be empty.'),
      );
    }

    return _repository.generateImage(
      prompt: trimmedPrompt,
      imagePath: imagePath,
    );
  }
}
