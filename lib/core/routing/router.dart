import 'package:education_app/features/authentication/logic/auth_cubit.dart';
import 'package:education_app/features/courses/logic/courses_cubit.dart';
import 'package:education_app/features/onboarding/data/repos/onboarding_repo.dart';
import 'package:education_app/features/onboarding/logic/onboarding_cubit.dart';
import 'package:education_app/features/problems/logic/problems_cubit.dart';
import 'package:education_app/features/teacher/add_new_problem/logic/add_new_problem_cubit.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/authentication/data/repos/auth_repo.dart';
import 'package:education_app/features/courses/data/repos/courses_repo.dart';
import 'package:education_app/features/problems/data/repos/problems_repo.dart';
import 'package:education_app/features/teacher/add_new_problem/data/repos/add_new_problem_repo.dart';
import 'package:education_app/core/services/firestore_services.dart';
import 'package:education_app/features/problems/ui/problems_page.dart';
import 'package:education_app/features/teacher/courses_student_feedback/data/repos/courses_student_feedback_repo.dart';
import 'package:education_app/features/teacher/courses_student_feedback/logic/courses_student_feedback_cubit.dart';
import 'package:education_app/features/teacher/courses_student_feedback/ui/courses_student_feedback_page.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/data/repos/select_stage_and_subject_repo.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/logic/select_stage_and_subject_cubit.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/ui/select_stage_page.dart';
import 'package:education_app/features/onboarding/ui/select_user_page.dart';
import 'package:education_app/features/teacher/add_new_problem/ui/add_new_problem_page.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/features/authentication/ui/auth_page.dart';
import 'package:education_app/features/courses/ui/courses_page.dart';
import 'package:education_app/features/onboarding/ui/landing_page.dart';
import 'package:education_app/features/teacher_add_new_course/data/repos/add_new_course_repo.dart';
import 'package:education_app/features/teacher_add_new_course/logic/add_new_course_cubit.dart';
import 'package:education_app/features/teacher_add_new_course/ui/add_new_course_page.dart';
import 'package:education_app/features/teacher_subjects_details/data/repos/subject_courses_repo.dart';
import 'package:education_app/features/teacher_subjects_details/logic/teacher_subject_details_cubit.dart';
import 'package:education_app/features/teacher_subjects_details/ui/teacher_subject_details_page.dart';
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
        builder: (_) => BlocProvider<SelectStageAndSubjectCubit>.value(
          value: SelectStageAndSubjectCubit(
              SelectStageAndSubjectRepository(FirestoreServices())),
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
    case AppRoutes.addNewProblemRoute:
      final Courses course = settings.arguments as Courses;
      return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<AddNewProblemCubit>(
              create: (context) => AddNewProblemCubit(
                  AddNewProblemRepository(FirestoreServices())),
            ),
            BlocProvider(
              create: (context) =>
                  ProblemsCubit(ProblemsRepository(FirestoreServices())),
            ),
          ],
          child: AddNewProblemPage(course: course),
        ),
        settings: settings,
      );
    case AppRoutes.teacherSubjectsDetailsRoute:
      final subject = settings.arguments as String;
      return CupertinoPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => TeacherSubjectDetailsCubit(
              SubjectCoursesRepository(FirestoreServices()))
            ..getSubjectCourses(subject: subject),
          child: TeacherSubjectDetailsPage(
            subject: subject,
          ),
        ),
        settings: settings,
      );
    case AppRoutes.addNewCoursePage:
      final subject = settings.arguments as String;
      return CupertinoPageRoute(
        builder: (_) => BlocProvider(
          create: (context) =>
              AddNewCourseCubit(AddNewCourseRepository(FirestoreServices())),
          child: AddNewCoursePage(
            subject: subject,
          ),
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
              create: (context) => CoursesCubit(
                  CoursesRepository(FirestoreServices()),
                  AuthRepository(FirestoreServices())),
            ),
          ],
          child: const CoursesPage(),
        ),
        settings: settings,
      );
    case AppRoutes.problemPage:
      final course = settings.arguments as Courses;
      return CupertinoPageRoute(
        builder: (_) => BlocProvider(
          create: (context) =>
              ProblemsCubit(ProblemsRepository(FirestoreServices())),
          child: ProblemPage(course: course),
        ),
        settings: settings,
      );
    case AppRoutes.studentsFeedbackRoute:
      return CupertinoPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => CoursesStudentFeedbackCubit(
              CoursesStudentFeedbackRepository(FirestoreServices())),
          child: const CoursesStudentFeedbackPage(),
        ),
        settings: settings,
      );
    case AppRoutes.landingPageRoute:
    default:
      return CupertinoPageRoute(
        builder: (_) => BlocProvider(
          create: (context) =>
              OnboardingCubit(OnBoardingRepository(FirestoreServices()))
                ..getInitDataFromSharedPreferences(),
          child: LandingPage(),
        ),
        settings: settings,
      );
  }
}
