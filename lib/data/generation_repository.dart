import '../core/error/exceptions.dart';
import '../core/error/failures.dart';
import '../core/utils/result.dart';
import '../domain/entities/generated_image.dart';
import '../domain/generation_repository.dart';
import 'api/kling_remote_data_source.dart';
import 'dto/generation_request_dto.dart';

class GenerationRepositoryImpl implements GenerationRepository {
  GenerationRepositoryImpl(this._remoteDataSource);

  final KlingRemoteDataSource _remoteDataSource;

  @override
  Future<Result<GeneratedImage>> generateImage({
    required String prompt,
    String? imagePath,
  }) async {
    try {
      final request = GenerationRequestDto(
        prompt: prompt,
        imagePath: imagePath,
      );
      final response = await _remoteDataSource.generateImage(request);
      return Success<GeneratedImage>(response.toEntity());
    } on NetworkException catch (error) {
      return Error<GeneratedImage>(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return Error<GeneratedImage>(ServerFailure(error.message));
    } catch (_) {
      return const Error<GeneratedImage>(
        ServerFailure('Unexpected error during image generation.'),
      );
    }
  }
}
