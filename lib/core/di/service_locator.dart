import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/api/kling_remote_data_source.dart';
import '../../data/generation_repository.dart';
import '../../domain/generation_repository.dart';
import '../../domain/usecases/generate_image_usecase.dart';
import '../../presentation/generation/cubit/generation_cubit.dart';
import '../config/kling_api_config.dart';
import '../network/dio_client.dart';
import '../network/kling_auth_interceptor.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator({KlingApiConfig? klingApiConfig}) {
  final config = klingApiConfig ?? KlingApiConfig.fromLoadedEnv();

  getIt.registerSingleton<KlingApiConfig>(config);

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: config.baseUrl,
      interceptors: <Interceptor>[KlingAuthInterceptor(config.secrets)],
    ),
  );

  getIt.registerLazySingleton<KlingRemoteDataSource>(
    () =>
        KlingRemoteDataSourceImpl(getIt<DioClient>(), getIt<KlingApiConfig>()),
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
