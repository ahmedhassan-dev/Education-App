import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/authentication/logic/auth_cubit.dart';
import 'package:education_app/features/courses/logic/courses_cubit.dart';
import 'package:education_app/features/onboarding/logic/onboarding_cubit.dart';
import 'package:education_app/features/onboarding/ui/welcome_page.dart';
import 'package:education_app/features/onboarding/ui/widgets/need_update.dart';
import 'package:education_app/features/teacher/logic/teacher_cubit.dart';
import 'package:education_app/features/authentication/data/repos/auth_repo.dart';
import 'package:education_app/features/courses/data/repos/courses_repo.dart';
import 'package:education_app/features/teacher/data/repos/teacher_repo.dart';
import 'package:education_app/core/services/firestore_services.dart';
import 'package:education_app/features/courses/ui/courses_page.dart';
import 'package:education_app/features/teacher/ui/select_subject_page.dart';
import 'package:education_app/features/teacher_courses/logic/teacher_courses_cubit.dart';
import 'package:education_app/features/teacher_courses/ui/teacher_courses_page.dart';
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
      } else if (state is LoadSelectUserPage) {
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
    FirestoreServices fireStoreServices = FirestoreServices();
    AuthCubit authCubit = AuthCubit(AuthRepository(fireStoreServices));
    CoursesRepository coursesRepository = CoursesRepository(fireStoreServices);
    CoursesCubit coursesCubit =
        CoursesCubit(coursesRepository, AuthRepository(fireStoreServices));
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
                create: (context) =>
                    TeacherCubit(TeacherRepository(fireStoreServices)),
                child: const SelectSubjectsPage(),
              );
            } else if (subjects.length == 1) {
              return BlocProvider(
                create: (context) => TeacherSubjectDetailsCubit(
                    SubjectCoursesRepository(fireStoreServices))
                  ..getSubjectCourses(subject: subjects[0]),
                child: TeacherSubjectDetailsPage(subject: subjects[0]),
              );
            }
            return BlocProvider(
              create: (context) =>
                  TeacherCoursesCubit(AuthRepository(fireStoreServices)),
              child: TeacherCoursesPage(subjects: subjects),
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
