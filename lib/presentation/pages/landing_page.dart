import 'package:education_app/business_logic/auth_cubit/auth_cubit.dart';
import 'package:education_app/business_logic/courses_cubit/courses_cubit.dart';
import 'package:education_app/business_logic/teacher_cubit/teacher_cubit.dart';
import 'package:education_app/data/repository/courses_repo.dart';
import 'package:education_app/data/repository/teacher_repo.dart';
import 'package:education_app/data/services/firestore_services.dart';
import 'package:education_app/presentation/pages/courses_page.dart';
import 'package:education_app/presentation/pages/select_subject_page.dart';
import 'package:education_app/presentation/pages/select_user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = AuthCubit();
    CoursesRepository coursesRepository =
        CoursesRepository(FirestoreServices());
    CoursesCubit coursesCubit = CoursesCubit(coursesRepository);
    TeacherCubit teacherCubit =
        TeacherCubit(TeacherRepository(FirestoreServices()));
    final auth = FirebaseAuth.instance;
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const SelectUserPage();
          }

          return BlocProvider(
            create: (context) => teacherCubit,
            child: const SelectSubjectsPage(),
          );
          // return MultiBlocProvider(
          //   providers: [
          //     BlocProvider<AuthCubit>.value(
          //       value: authCubit,
          //     ),
          //     BlocProvider(
          //       create: (context) => coursesCubit,
          //     ),
          //   ],
          //   child: const CoursesPage(),
          // );
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
