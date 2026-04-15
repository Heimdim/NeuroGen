import '../core/utils/result.dart';
import 'entities/generated_image.dart';

abstract class GenerationRepository {
  Future<Result<GeneratedImage>> generateImage({
    required String prompt,
    String? imagePath,
  });
}
