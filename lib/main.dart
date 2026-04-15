import 'package:flutter/material.dart';

import 'core/di/service_locator.dart';
import 'presentation/generation/screen/generation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const NeuroGenApp());
}

class NeuroGenApp extends StatelessWidget {
  const NeuroGenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroGen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GenerationScreen(),
    );
  }
}
