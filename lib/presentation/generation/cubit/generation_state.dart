import '../../../domain/entities/generated_image.dart';

sealed class GenerationState {
  const GenerationState();
}

class GenerationIdle extends GenerationState {
  const GenerationIdle();
}

class GenerationLoading extends GenerationState {
  const GenerationLoading();
}

class GenerationSuccess extends GenerationState {
  const GenerationSuccess(this.image);

  final GeneratedImage image;
}

class GenerationError extends GenerationState {
  const GenerationError(this.message);

  final String message;
}
