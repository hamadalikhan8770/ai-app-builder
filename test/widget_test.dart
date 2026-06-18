import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Phase 13 analytics project has test harness', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('AI App Builder Analytics'))),
    );

    expect(find.text('AI App Builder Analytics'), findsOneWidget);
  });
}
