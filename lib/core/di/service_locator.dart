import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../data/ai_generation_provider_registry.dart';
import '../../data/api/kling_remote_data_source.dart';
import '../../data/job_repository_impl.dart';
import '../../data/local/job_result_image_storage.dart';
import '../../data/providers/kling_ai_generation_provider.dart';
import '../../data/providers/unsupported_image_ai_provider.dart';
import '../../domain/ai/ai_generation_provider.dart';
import '../../domain/ai/ai_provider_id.dart';
import '../../domain/job_repository.dart';
import '../../presentation/jobs/cubit/jobs_cubit.dart';
import '../config/kling_api_config.dart';
import '../locale/app_locale_controller.dart';
import '../network/dio_client.dart';
import '../network/kling_auth_interceptor.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator({
  KlingApiConfig? klingApiConfig,
  required Box<String> jobHistoryBox,
}) {
  getIt.registerSingleton<Box<String>>(jobHistoryBox);

  final KlingApiConfig config =
      klingApiConfig ?? KlingApiConfig.fromLoadedEnv();
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

  getIt.registerLazySingleton<AiGenerationProviderRegistry>(
    () => AiGenerationProviderRegistry(<AiGenerationProvider>[
      KlingAiGenerationProvider(getIt<KlingRemoteDataSource>()),
      UnsupportedImageAiProvider(
        id: AiProviderId.openAi,
        displayName: 'OpenAI',
      ),
      UnsupportedImageAiProvider(
        id: AiProviderId.deepSeek,
        displayName: 'DeepSeek',
      ),
    ]),
  );

  getIt.registerLazySingleton<JobRepository>(
    () => JobRepositoryImpl(getIt<Box<String>>()),
  );

  getIt.registerLazySingleton<JobResultImageStorage>(JobResultImageStorage.new);

  getIt.registerLazySingleton<AppLocaleController>(
    () => AppLocaleController(getIt<Box<String>>()),
  );

  getIt.registerLazySingleton<JobsCubit>(
    () => JobsCubit(
      jobRepository: getIt<JobRepository>(),
      providerRegistry: getIt<AiGenerationProviderRegistry>(),
      klingApiConfig: getIt<KlingApiConfig>(),
      imageStorage: getIt<JobResultImageStorage>(),
    ),
  );
}
