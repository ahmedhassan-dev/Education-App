import 'package:education_app/utilities/routes.dart';
import 'package:education_app/views/pages/auth_page.dart';
import 'package:education_app/views/pages/courses_page.dart';
import 'package:education_app/views/pages/landing_page.dart';
import 'package:education_app/views/pages/problems_page.dart';
import 'package:flutter/cupertino.dart';

Route<dynamic> onGenerate(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.loginPageRoute:
      return CupertinoPageRoute(
        builder: (_) => const AuthPage(),
        settings: settings,
      );
    case AppRoutes.coursesPage:
      return CupertinoPageRoute(
        builder: (_) => const CoursesPage(),
        settings: settings,
      );
    case AppRoutes.problemPage:
      return CupertinoPageRoute(
        builder: (_) => const ProblemPage(),
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
