import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:neurogen/core/config/kling_api_config.dart';
import 'package:neurogen/core/config/kling_api_secrets.dart';
import 'package:neurogen/core/di/service_locator.dart';
import 'package:neurogen/main.dart';
import 'package:neurogen/presentation/jobs/cubit/jobs_cubit.dart';

void main() {
  late Directory tempDir;
  late Box<String> jobBox;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('neurogen_widget_test');
    Hive.init(tempDir.path);
    jobBox = await Hive.openBox<String>('neurogen_job_history_test');
    await GetIt.instance.reset();
    setupServiceLocator(
      jobHistoryBox: jobBox,
      klingApiConfig: KlingApiConfig(
        baseUrl: 'https://example.com',
        secrets: KlingApiSecrets.bearerForTests('test-token'),
      ),
    );
  });

  tearDown(() async {
    final GetIt getIt = GetIt.instance;
    if (getIt.isRegistered<JobsCubit>()) {
      final JobsCubit cubit = getIt<JobsCubit>();
      if (!cubit.isClosed) {
        await cubit.close();
      }
    }
    await getIt.reset();
    await jobBox.close();
    await tempDir.delete(recursive: true);
  });

  testWidgets('App shell shows History and Generate navigation', (
    WidgetTester tester,
  ) async {
    final JobsCubit jobsCubit = getIt<JobsCubit>();
    await tester.pumpWidget(
      BlocProvider<JobsCubit>.value(
        value: jobsCubit,
        child: const NeuroGenApp(),
      ),
    );

    expect(find.text('NeuroGen'), findsWidgets);
    expect(find.text('Generate'), findsWidgets);

    await jobsCubit.close();
  });
}
