import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:neurogen/core/config/kling_api_config.dart';
import 'package:neurogen/core/config/kling_api_secrets.dart';
import 'package:neurogen/core/di/service_locator.dart';
import 'package:neurogen/main.dart';

void main() {
  final sl = GetIt.instance;

  setUp(() async {
    await sl.reset();
    setupServiceLocator(
      klingApiConfig: KlingApiConfig(
        baseUrl: 'https://example.com',
        secrets: KlingApiSecrets.bearerForTests('test-token'),
      ),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('Generation screen renders basic UI', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NeuroGenApp());

    expect(find.text('AI Image Generation'), findsOneWidget);
    expect(find.text('Generate Image'), findsOneWidget);
    expect(find.text('Select Image from Gallery'), findsOneWidget);
  });
}
