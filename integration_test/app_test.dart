import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:term_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('App should start and show splash screen', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify splash screen is shown
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('Should navigate to sign in page', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to finish
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify sign in page is shown
      expect(find.byType(SignInPage), findsOneWidget);
    });
  });
}
