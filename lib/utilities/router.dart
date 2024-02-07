import 'package:education_app/business_logic/auth_cubit/auth_cubit.dart';
import 'package:education_app/business_logic/courses_cubit/courses_cubit.dart';
import 'package:education_app/data/repository/courses_repo.dart';
import 'package:education_app/data/services/firestore_services.dart';
import 'package:education_app/utilities/routes.dart';
import 'package:education_app/presentation/pages/auth_page.dart';
import 'package:education_app/presentation/pages/courses_page.dart';
import 'package:education_app/presentation/pages/landing_page.dart';
// import 'package:education_app/presentation/pages/problems_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route<dynamic> onGenerate(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.loginPageRoute:
      return CupertinoPageRoute(
        builder: (_) => BlocProvider<AuthCubit>.value(
          value: AuthCubit(),
          child: const AuthPage(),
        ),
        settings: settings,
      );
    case AppRoutes.coursesPage:
      return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(
              value: AuthCubit(),
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
    // case AppRoutes.problemPage:
    //   final args = settings.arguments as Map<String, dynamic>;
    //   final courseList = args['courseList'];
    //   final database = args['database'];

    //   return CupertinoPageRoute(
    //     builder: (_) => Provider<Database>.value(
    //       value: database,
    //       child: ProblemPage(courseList: courseList),
    //     ),
    //     settings: settings,
    //   );
    case AppRoutes.landingPageRoute:
    default:
      return CupertinoPageRoute(
        builder: (_) => const LandingPage(),
        settings: settings,
      );
  }
}
