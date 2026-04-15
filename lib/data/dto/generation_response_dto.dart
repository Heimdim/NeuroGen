import '../../domain/entities/generated_image.dart';

class GenerationResponseDto {
  const GenerationResponseDto({required this.imageUrl, required this.prompt});

  final String imageUrl;
  final String prompt;

  GeneratedImage toEntity() {
    return GeneratedImage(imageUrl: imageUrl, prompt: prompt);
  }
}
