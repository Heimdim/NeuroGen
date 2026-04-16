import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> pushSettingsScreen(BuildContext context) {
  return context.push<void>('/settings');
}
