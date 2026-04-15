import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/result.dart';
import '../../../domain/usecases/generate_image_usecase.dart';
import 'generation_state.dart';

class GenerationCubit extends Cubit<GenerationState> {
  GenerationCubit(this._generateImageUseCase) : super(const GenerationIdle());

  final GenerateImageUseCase _generateImageUseCase;

  Future<void> generate({required String prompt, String? imagePath}) async {
    emit(const GenerationLoading());
    final result = await _generateImageUseCase(
      prompt: prompt,
      imagePath: imagePath,
    );

    switch (result) {
      case Success():
        emit(GenerationSuccess(result.data));
      case Error():
        emit(GenerationError(result.failure.message));
    }
  }

  void reset() => emit(const GenerationIdle());
}
