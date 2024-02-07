import 'package:education_app/business_logic/auth_cubit/auth_cubit.dart';
import 'package:education_app/business_logic/courses_cubit/courses_cubit.dart';
import 'package:education_app/data/models/courses_model.dart';
import 'package:education_app/presentation/widgets/courses_list.dart';
import 'package:education_app/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  AuthCubit authCubit = AuthCubit();
  List<CoursesModel> allCourses = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CoursesCubit>(context).getAllCourses();
  }

  Future<void> _logout(context) async {
    try {
      await authCubit.logOut();
      Navigator.of(context).pushReplacementNamed(AppRoutes.loginPageRoute);
    } catch (e) {
      debugPrint('logout error: $e');
    }
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CoursesCubit, CoursesState>(
      builder: (context, state) {
        if (state is CoursesLoaded) {
          allCourses = (state).courses;
          return buildLoadedListWidgets();
        } else {
          return showLoadingIndicator();
        }
      },
    );
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: [buildCharactersList(), const SizedBox(height: 24.0)],
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    return ListView.builder(
      itemCount: allCourses.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        final courseType = allCourses[i];
        return CoursesList(
          courseList: courseType,
        );
      },
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            onPressed: () {
              _logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
        toolbarHeight: 60,
      ),
      body: buildBlocWidget(),
    );
  }
}
