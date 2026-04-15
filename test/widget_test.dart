import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:neurogen/core/di/service_locator.dart';
import 'package:neurogen/main.dart';

void main() {
  final sl = GetIt.instance;

  setUp(() async {
    await sl.reset();
    setupServiceLocator();
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
