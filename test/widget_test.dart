import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp());

    // Verify that our app starts with the auth screen
    expect(find.text('Weather App'), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
  });
}
