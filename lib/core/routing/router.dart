import 'package:education_app/core/functions/service_locator.dart';
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
import 'package:education_app/features/teacher/check_answers/data/repos/check_answers_repo_impl.dart';
import 'package:education_app/features/teacher/check_answers/domain/use_cases/fetch_problems_use_case.dart';
import 'package:education_app/features/teacher/check_answers/domain/use_cases/fetch_solved_problems_use_case.dart';
import 'package:education_app/features/teacher/check_answers/domain/use_cases/fetch_student_data_use_case.dart';
import 'package:education_app/features/teacher/check_answers/presentation/manger/fetch_problems_cubit/fetch_problems_cubit.dart';
import 'package:education_app/features/teacher/check_answers/presentation/manger/fetch_solved_problems_cubit/fetch_solved_problems_cubit.dart';
import 'package:education_app/features/teacher/check_answers/presentation/manger/fetch_student_data_cubit/fetch_student_data_cubit.dart';
import 'package:education_app/features/teacher/check_answers/presentation/ui/check_answers_page.dart';
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

import '../../features/teacher/check_answers/presentation/manger/check_answers_cubit/check_answer_cubit.dart';
import '../../features/teacher/check_answers/presentation/manger/notifications_cubit/notifications_cubit.dart';
import '../pages/privacy_policy_page.dart';

Route<dynamic> onGenerate(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.selectUserTypeRoute:
      return CupertinoPageRoute(
        builder: (_) => BlocProvider<AuthCubit>.value(
          value: AuthCubit(AuthRepository(getIt<FirestoreServices>())),
          child: const SelectUserPage(),
        ),
        settings: settings,
      );
    case AppRoutes.selectEducationalStagesRoute:
      return CupertinoPageRoute(
        builder: (_) => BlocProvider<SelectStageAndSubjectCubit>.value(
          value: SelectStageAndSubjectCubit(
              SelectStageAndSubjectRepository(getIt<FirestoreServices>())),
          child: const SelectEducationalStagesPage(),
        ),
        settings: settings,
      );
    case AppRoutes.loginPageRoute:
      final userType = settings.arguments as String;
      return CupertinoPageRoute(
        builder: (_) => BlocProvider<AuthCubit>.value(
          value: AuthCubit(AuthRepository(getIt<FirestoreServices>())),
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
                  AddNewProblemRepository(getIt<FirestoreServices>())),
            ),
            BlocProvider(
              create: (context) =>
                  ProblemsCubit(ProblemsRepository(getIt<FirestoreServices>())),
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
              SubjectCoursesRepository(getIt<FirestoreServices>()))
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
          create: (context) => AddNewCourseCubit(
              AddNewCourseRepository(getIt<FirestoreServices>())),
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
              value: AuthCubit(AuthRepository(getIt<FirestoreServices>())),
            ),
            BlocProvider(
              create: (context) => CoursesCubit(
                  CoursesRepository(getIt<FirestoreServices>()),
                  getIt<AuthRepository>()),
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
              ProblemsCubit(ProblemsRepository(getIt<FirestoreServices>())),
          child: ProblemPage(course: course),
        ),
        settings: settings,
      );
    case AppRoutes.studentsFeedbackRoute:
      return CupertinoPageRoute(
        builder: (_) {
          return BlocProvider<CoursesStudentFeedbackCubit>.value(
            value: getIt<CoursesStudentFeedbackCubit>()
              ..getTeacherSortedCourses(),
            child: const CoursesStudentFeedbackPage(),
          );
        },
        settings: settings,
      );
    case AppRoutes.checkAnswersRoute:
      final Courses course = settings.arguments as Courses;
      return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => FetchSolvedProblemsCubit(
                  FetchSolvedProblemsUseCase(getIt<CheckAnswersRepoImpl>())),
            ),
            BlocProvider(
              create: (context) => FetchProblemsCubit(
                  FetchProblemsUseCase(getIt<CheckAnswersRepoImpl>())),
            ),
            BlocProvider(
              create: (context) => FetchStudentDataCubit(
                  FetchStudentDataUseCase(
                      ProblemsRepository(getIt<FirestoreServices>()))),
            ),
            BlocProvider(
              create: (context) =>
                  CheckAnswerCubit(getIt<CheckAnswersRepoImpl>()),
            ),
            BlocProvider<CoursesStudentFeedbackCubit>.value(
              value: getIt<CoursesStudentFeedbackCubit>(),
            ),
            BlocProvider(
              create: (context) =>
                  NotificationsCubit(getIt<CheckAnswersRepoImpl>()),
            ),
          ],
          child: CheckAnswersPage(course: course),
        ),
        settings: settings,
      );
    case AppRoutes.privacyPolicy:
      return CupertinoPageRoute(
          builder: (_) => const PrivacyPolicyPage(), settings: settings);
    case AppRoutes.landingPageRoute:
    default:
      return CupertinoPageRoute(
        builder: (_) => BlocProvider(
          create: (context) =>
              OnboardingCubit(OnBoardingRepository(getIt<FirestoreServices>()))
                ..getInitDataFromSharedPreferences(),
          child: LandingPage(),
        ),
        settings: settings,
      );
  }
}
