import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Authentication flow', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // Verify auth screen is shown
      expect(find.text('Weather App'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);

      // TODO: Add more integration tests as needed
      // Note: Actual Google Sign-In can't be tested in integration tests
      // You would need to mock the authentication service
    });
  });
}

class IntegrationTestWidgetsFlutterBinding {
  static void ensureInitialized() {}
}
