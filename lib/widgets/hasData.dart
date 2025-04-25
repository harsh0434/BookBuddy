import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:term_project/pages/LoginPage.dart';
import 'package:term_project/pages/BaseWidget.dart';

class HasData extends StatelessWidget {
  const HasData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return const BottomBar();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
