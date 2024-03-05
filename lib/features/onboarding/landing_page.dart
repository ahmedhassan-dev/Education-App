import 'package:education_app/features/authentication/logic/auth_cubit.dart';
import 'package:education_app/features/courses/logic/courses_cubit.dart';
import 'package:education_app/features/teacher/logic/teacher_cubit.dart';
import 'package:education_app/features/authentication/data/repos/auth_repo.dart';
import 'package:education_app/features/courses/data/repos/courses_repo.dart';
import 'package:education_app/features/teacher/data/repos/teacher_repo.dart';
import 'package:education_app/core/services/firestore_services.dart';
import 'package:education_app/features/courses/ui/courses_page.dart';
import 'package:education_app/features/teacher/ui/select_subject_page.dart';
import 'package:education_app/features/teacher/ui/select_user_page.dart';
import 'package:education_app/features/teacher_courses/ui/teacher_courses_page.dart';
import 'package:education_app/features/teacher_courses_details/ui/teacher_subject_courses_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String? userType;
  List<String>? subjects;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _connectToSharedPreferences();
  }

  _connectToSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType');
    subjects = prefs.getStringList('subjects');
    isLoading = false;
    setState(() {});
  }

  Widget selectInitPage(auth) {
    AuthCubit authCubit = AuthCubit(AuthRepository(FirestoreServices()));
    CoursesRepository coursesRepository =
        CoursesRepository(FirestoreServices());
    CoursesCubit coursesCubit = CoursesCubit(coursesRepository);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const SelectUserPage();
          }
          if (userType == "Teacher") {
            if (subjects == null) {
              return BlocProvider(
                create: (context) =>
                    TeacherCubit(TeacherRepository(FirestoreServices())),
                child: const SelectSubjectsPage(),
              );
            } else if (subjects!.length == 1) {
              return TeacherSubjectCoursesPage(subject: subjects![0]);
            }
            return TeacherCoursesPage(subjects: subjects!);
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
        return const SelectUserPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : selectInitPage(auth);
  }
}
