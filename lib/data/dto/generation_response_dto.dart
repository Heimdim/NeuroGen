import '../../domain/entities/generated_image.dart';

class GenerationResponseDto {
  const GenerationResponseDto({required this.imageUrl, required this.prompt});

  final String imageUrl;
  final String prompt;

  factory GenerationResponseDto.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['image_url'] as String? ?? '';
    final prompt = json['prompt'] as String? ?? '';
    return GenerationResponseDto(imageUrl: imageUrl, prompt: prompt);
  }

  GeneratedImage toEntity() {
    return GeneratedImage(imageUrl: imageUrl, prompt: prompt);
  }
}
