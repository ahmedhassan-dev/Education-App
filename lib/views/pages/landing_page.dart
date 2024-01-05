import 'package:education_app/controllers/auth_controller.dart';
import 'package:education_app/controllers/database_controller.dart';
import 'package:education_app/services/auth.dart';
import 'package:education_app/views/pages/auth_page.dart';
import 'package:education_app/views/pages/courses_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return ChangeNotifierProvider<AuthController>(
              create: (_) => AuthController(auth: auth),
              child: const AuthPage(),
            );
          }
          return ChangeNotifierProvider<AuthController>(
            create: (_) => AuthController(auth: auth),
            child: Provider<Database>(
                create: (_) => FirestoreDatabase(user.uid),
                child: const CoursesPage()),
          );
        }
        // TODO: Need to make one component for loading
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
