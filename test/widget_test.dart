import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qnote/app.dart';

void main() {
  testWidgets('App should display Qnote title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: QnoteApp()),
    );

    expect(find.text('Qnote'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
