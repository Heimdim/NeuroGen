import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../generation/screen/generation_screen.dart';
import '../history/screen/generation_history_screen.dart';
import '../jobs/cubit/jobs_cubit.dart';
import '../jobs/cubit/jobs_state.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return BlocListener<JobsCubit, JobsState>(
      listenWhen: (JobsState previous, JobsState current) =>
          current.requestGenerateTabFocus,
      listener: (BuildContext context, JobsState state) {
        setState(() => _index = 0);
        context.read<JobsCubit>().acknowledgeGenerateTabFocus();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: const <Widget>[
            GenerationScreen(),
            GenerationHistoryScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (int i) => setState(() => _index = i),
          destinations: <Widget>[
            NavigationDestination(
              icon: const Icon(Icons.auto_awesome),
              label: l10n.navGenerate,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history),
              label: l10n.navHistory,
            ),
          ],
        ),
      ),
    );
  }
}
