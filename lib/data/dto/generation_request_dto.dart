class GenerationRequestDto {
  const GenerationRequestDto({required this.prompt, this.imagePath});

  final String prompt;
  final String? imagePath;
}
