import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookwave/main.dart';

void main() {
  testWidgets('BookWave app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BookWaveApp());

    // Verify that BookWave app starts
    expect(find.text('BookWave'), findsOneWidget);
  });
}
