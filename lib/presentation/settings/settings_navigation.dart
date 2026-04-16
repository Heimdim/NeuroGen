import 'package:flutter/material.dart';

import 'screen/settings_screen.dart';

Future<void> pushSettingsScreen(BuildContext context) {
  return Navigator.of(
    context,
  ).push<void>(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
}
