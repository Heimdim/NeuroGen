import 'package:get_it/get_it.dart';

import '../../data/api/kling_remote_data_source.dart';
import '../../data/generation_repository.dart';
import '../../domain/generation_repository.dart';
import '../../domain/usecases/generate_image_usecase.dart';
import '../../presentation/generation/cubit/generation_cubit.dart';
import '../network/dio_client.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(baseUrl: 'https://api.kling.ai'),
  );

  getIt.registerLazySingleton<KlingRemoteDataSource>(
    () => KlingRemoteDataSourceImpl(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<GenerationRepository>(
    () => GenerationRepositoryImpl(getIt<KlingRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GenerateImageUseCase>(
    () => GenerateImageUseCase(getIt<GenerationRepository>()),
  );

  getIt.registerFactory<GenerationCubit>(
    () => GenerationCubit(getIt<GenerateImageUseCase>()),
  );
}
