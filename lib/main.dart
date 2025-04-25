// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:term_project/Provider/RecommendationProvider.dart';
import 'package:term_project/pages/BaseWidget.dart';
import 'package:term_project/pages/BookListPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:term_project/pages/MyListPage.dart';
import 'package:term_project/pages/onBoarding.dart';
import 'package:term_project/pages/SettingsPage.dart';
import 'package:term_project/pages/splashPage.dart';
import 'package:term_project/pages/LoginPage.dart';
import 'package:term_project/services/notification_service.dart';
import 'package:term_project/widgets/hasData.dart';
import 'Provider/FavoriteProvider.dart';
import 'Provider/ThemeProvider.dart';
import 'Provider/TodoProvider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB7KAEji13O9KDfCeXTLbNLgY_5qy9vcyo",
        authDomain: "bookrec-abbbb.firebaseapp.com",
        databaseURL:
            "https://bookrec-abbbb-default-rtdb.europe-west1.firebasedatabase.app",
        projectId: "bookrec-abbbb",
        storageBucket: "bookrec-abbbb.appspot.com",
        messagingSenderId: "471141870423",
        appId: "1:471141870423:web:eb5db6a7e55df2e0826c12",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  NotificationService().initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => TodoProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecommendationProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BookBuddy',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              primaryColor: const Color(0xFF3F51B5),
              colorScheme: ColorScheme.light(
                primary: const Color(0xFF3F51B5),
                secondary: const Color(0xFF303F9F),
                surface: Colors.white,
                background: Colors.grey[50]!,
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: Colors.black87,
                onBackground: Colors.black87,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF3F51B5),
                elevation: 0,
              ),
              cardTheme: CardTheme(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: const Color(0xFF3F51B5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: const Color(0xFF3F51B5),
              colorScheme: ColorScheme.dark(
                primary: const Color(0xFF3F51B5),
                secondary: const Color(0xFF303F9F),
                surface: const Color(0xFF424242),
                background: const Color(0xFF303030),
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: Colors.white,
                onBackground: Colors.white,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF3F51B5),
                elevation: 0,
              ),
              cardTheme: CardTheme(
                color: const Color(0xFF424242),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: const Color(0xFF3F51B5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routes: {
              '/': (context) => const SplashScreen(),
              '/books': (context) => BookPage(),
              '/settings': (context) => const SettingsPage(),
              '/login': (context) => const LoginPage(),
              '/onboarding': (context) => const OnBoarding(),
              '/home': (context) => const BottomBar(),
              '/mylist': (context) => MyListPage(),
            },
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (context) => const HasData(),
            ),
          );
        },
      ),
    );
  }
}
