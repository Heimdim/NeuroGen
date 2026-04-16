import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/service_locator.dart';
import 'core/locale/app_locale_controller.dart';
import 'l10n/app_localizations.dart';
import 'presentation/jobs/cubit/jobs_cubit.dart';
import 'presentation/shell/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  await Hive.initFlutter();
  final Box<String> jobHistoryBox = await Hive.openBox<String>(
    'neurogen_job_history',
  );
  setupServiceLocator(jobHistoryBox: jobHistoryBox);
  runApp(
    BlocProvider<JobsCubit>.value(
      value: getIt<JobsCubit>(),
      child: const NeuroGenApp(),
    ),
  );
}

class NeuroGenApp extends StatelessWidget {
  const NeuroGenApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocaleController localeController = getIt<AppLocaleController>();
    return ListenableBuilder(
      listenable: localeController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: localeController.localeOverride,
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const AppShell(),
        );
      },
    );
  }
}
