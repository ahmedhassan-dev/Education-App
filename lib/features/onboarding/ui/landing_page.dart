import 'package:education_app/core/functions/service_locator.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/authentication/logic/auth_cubit.dart';
import 'package:education_app/features/courses/logic/courses_cubit.dart';
import 'package:education_app/features/onboarding/logic/onboarding_cubit.dart';
import 'package:education_app/features/onboarding/ui/welcome_page.dart';
import 'package:education_app/features/onboarding/ui/widgets/need_update.dart';
import 'package:education_app/features/authentication/data/repos/auth_repo.dart';
import 'package:education_app/features/courses/data/repos/courses_repo.dart';
import 'package:education_app/core/services/firestore_services.dart';
import 'package:education_app/features/courses/ui/courses_page.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/data/repos/select_stage_and_subject_repo.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/logic/select_stage_and_subject_cubit.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/ui/select_subject_page.dart';
import 'package:education_app/features/teacher_subjects/logic/teacher_subjects_cubit.dart';
import 'package:education_app/features/teacher_subjects/ui/teacher_subjects_page.dart';
import 'package:education_app/features/teacher_subjects_details/data/repos/subject_courses_repo.dart';
import 'package:education_app/features/teacher_subjects_details/logic/teacher_subject_details_cubit.dart';
import 'package:education_app/features/teacher_subjects_details/ui/teacher_subject_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  Widget buildBlocWidget() {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, OnboardingState state) {
      if (state is NeedUpdate) {
        return NeedToUpdate(
          onTap: () =>
              BlocProvider.of<OnboardingCubit>(context).downLoadNewVersion(),
        );
      } else if (state is LoadSelectUserPage ||
          state is AccountDeleted ||
          state is LogedOut) {
        return const WelcomePage();
      } else if (state is InitDataLoaded) {
        final String? userType = state.userType;
        final List<String>? subjects = state.subjects;
        return selectInitPage(userType, subjects);
      } else {
        return const ShowLoadingIndicator();
      }
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget selectInitPage(String? userType, List<String>? subjects) {
    AuthCubit authCubit = AuthCubit(getIt<AuthRepository>());
    CoursesRepository coursesRepository = getIt<CoursesRepository>();
    CoursesCubit coursesCubit = CoursesCubit(coursesRepository);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const WelcomePage();
          }
          if (userType == "Teacher") {
            if (subjects == null) {
              return BlocProvider(
                create: (context) => SelectStageAndSubjectCubit(
                    SelectStageAndSubjectRepository(
                        getIt<FirestoreServices>())),
                child: const SelectSubjectsPage(),
              );
            } else if (subjects.length == 1) {
              return BlocProvider(
                create: (context) => TeacherSubjectDetailsCubit(
                    SubjectCoursesRepository(getIt<FirestoreServices>()))
                  ..getSubjectCourses(subject: subjects[0]),
                child: TeacherSubjectDetailsPage(subject: subjects[0]),
              );
            }
            return BlocProvider(
              create: (context) => TeacherSubjectsCubit(
                  AuthRepository(getIt<FirestoreServices>())),
              child: TeacherSubjectsPage(subjects: subjects),
            );
          } else if (userType == "Student") {
            return MultiBlocProvider(
              providers: [
                BlocProvider<AuthCubit>.value(
                  value: authCubit,
                ),
                BlocProvider(
                  create: (context) => coursesCubit,
                ),
              ],
              child: const CoursesPage(),
            );
          }
        }
        return const WelcomePage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget();
  }
}
