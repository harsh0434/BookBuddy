import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:term_project/pages/BookListPage.dart';
import 'package:provider/provider.dart';
import 'package:term_project/Provider/FavoriteProvider.dart';

void main() {
  testWidgets('BookListPage should render correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => FavoriteProvider())],
        child: MaterialApp(home: BookPage()),
      ),
    );

    // Verify that the app bar is present
    expect(find.byType(AppBar), findsOneWidget);

    // Verify that the search bar is present
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the book list is present
    expect(find.byType(ListView), findsOneWidget);
  });
}
