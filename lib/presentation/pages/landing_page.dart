// import 'package:education_app/controllers/auth_controller.dart';
// import 'package:education_app/controllers/database_controller.dart';
// import 'package:education_app/data/repository/auth_repo.dart';
import 'package:education_app/business_logic/auth_cubit/auth_cubit.dart';
import 'package:education_app/presentation/pages/auth_page.dart';
import 'package:education_app/presentation/pages/courses_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = AuthCubit();
    final auth = FirebaseAuth.instance;
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return BlocProvider<AuthCubit>.value(
              value: authCubit,
              child: const AuthPage(),
            );
          }
          return BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: const CoursesPage(),
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
