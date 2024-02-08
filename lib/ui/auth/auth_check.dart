import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:projectTeraform/ui/auth/login/page.dart';
import 'package:projectTeraform/ui/root/root_page.dart';

class AuthenticationFlowScreen extends StatelessWidget {
  const AuthenticationFlowScreen({super.key});
  static String id = 'main screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const RootPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}