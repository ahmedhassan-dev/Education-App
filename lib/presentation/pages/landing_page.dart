import 'package:education_app/business_logic/auth_cubit/auth_cubit.dart';
import 'package:education_app/business_logic/courses_cubit/courses_cubit.dart';
import 'package:education_app/business_logic/teacher_cubit/teacher_cubit.dart';
import 'package:education_app/data/repository/courses_repo.dart';
import 'package:education_app/data/repository/teacher_repo.dart';
import 'package:education_app/data/services/firestore_services.dart';
import 'package:education_app/presentation/pages/courses_page.dart';
import 'package:education_app/presentation/pages/select_subject_page.dart';
import 'package:education_app/presentation/pages/select_user_page.dart';
import 'package:education_app/presentation/pages/teacher_page.dart';
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
    AuthCubit authCubit = AuthCubit();
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
            }
            return const TeacherPage();
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
