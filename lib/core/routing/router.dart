import 'package:education_app/features/authentication/logic/auth_cubit.dart';
import 'package:education_app/features/courses/logic/courses_cubit.dart';
import 'package:education_app/features/problems/logic/problems_cubit.dart';
import 'package:education_app/features/teacher/logic/teacher_cubit.dart';
import 'package:education_app/features/courses/data/models/courses_model.dart';
import 'package:education_app/features/authentication/data/repos/auth_repo.dart';
import 'package:education_app/features/courses/data/repos/courses_repo.dart';
import 'package:education_app/features/problems/data/repos/problems_repo.dart';
import 'package:education_app/features/teacher/data/repos/teacher_repo.dart';
import 'package:education_app/core/services/firestore_services.dart';
import 'package:education_app/features/problems/ui/problems_page.dart';
import 'package:education_app/features/teacher/ui/select_stage_page.dart';
import 'package:education_app/features/teacher/ui/select_user_page.dart';
import 'package:education_app/features/teacher/ui/teacher_page.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/features/authentication/ui/auth_page.dart';
import 'package:education_app/features/courses/ui/courses_page.dart';
import 'package:education_app/features/onboarding/landing_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route<dynamic> onGenerate(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.selectUserTypeRoute:
      return CupertinoPageRoute(
        builder: (_) => BlocProvider<AuthCubit>.value(
          value: AuthCubit(AuthRepository(FirestoreServices())),
          child: const SelectUserPage(),
        ),
        settings: settings,
      );
    case AppRoutes.selectEducationalStagesRoute:
      return CupertinoPageRoute(
        builder: (_) => BlocProvider<TeacherCubit>.value(
          value: TeacherCubit(TeacherRepository(FirestoreServices())),
          child: const SelectEducationalStagesPage(),
        ),
        settings: settings,
      );
    case AppRoutes.loginPageRoute:
      final userType = settings.arguments as String;
      return CupertinoPageRoute(
        builder: (_) => BlocProvider<AuthCubit>.value(
          value: AuthCubit(AuthRepository(FirestoreServices())),
          child: AuthPage(userType: userType),
        ),
        settings: settings,
      );
    case AppRoutes.teacherRoute:
      return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<TeacherCubit>(
              create: (context) =>
                  TeacherCubit(TeacherRepository(FirestoreServices())),
            ),
            BlocProvider(
              create: (context) =>
                  ProblemsCubit(ProblemsRepository(FirestoreServices())),
            ),
          ],
          child: const TeacherPage(),
        ),
        settings: settings,
      );
    case AppRoutes.coursesPage:
      return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(
              value: AuthCubit(AuthRepository(FirestoreServices())),
            ),
            BlocProvider(
              create: (context) =>
                  CoursesCubit(CoursesRepository(FirestoreServices())),
            ),
          ],
          child: const CoursesPage(),
        ),
        settings: settings,
      );
    case AppRoutes.problemPage:
      final courseList = settings.arguments as CoursesModel;
      return CupertinoPageRoute(
        builder: (_) => BlocProvider(
          create: (context) =>
              ProblemsCubit(ProblemsRepository(FirestoreServices())),
          child: ProblemPage(courseList: courseList),
        ),
        settings: settings,
      );
    case AppRoutes.landingPageRoute:
    default:
      return CupertinoPageRoute(
        builder: (_) => const LandingPage(),
        settings: settings,
      );
  }
}