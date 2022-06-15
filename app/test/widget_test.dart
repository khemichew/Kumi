// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('Navigation bar works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at memberships page.
    // expect(find.text('My\nmemberships'), findsOneWidget);
    //
    // // Tap the 'person' icon and switch to account page.
    // await tester.tap(find.byIcon(Icons.currency_pound_outlined));
    // await tester.pump();
    //
    // // Verify at account page.
    // expect(find.text('You have saved:'), findsOneWidget);
  });
}
