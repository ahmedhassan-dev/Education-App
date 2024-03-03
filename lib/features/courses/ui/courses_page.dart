import 'package:education_app/features/authentication/logic/auth_cubit.dart';
import 'package:education_app/features/courses/logic/courses_cubit.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/courses/ui/widgets/courses_list.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  // AuthCubit authCubit = AuthCubit();
  List<Courses> allCourses = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CoursesCubit>(context).getAllCourses();
  }

  // Future<void> _logout(context) async {
  //   try {
  //     await authCubit.logOut();
  //   } catch (e) {
  //     debugPrint('logout error: $e');
  //   }
  // }

  Widget buildBlocWidget() {
    return BlocConsumer<CoursesCubit, CoursesState>(
        listener: (BuildContext context, CoursesState state) {
      if (state is LogedOut) {
        Navigator.of(context)
            .pushReplacementNamed(AppRoutes.selectUserTypeRoute);
      } else if (state is LogedOutError) {
        debugPrint('logout error: ${state.errorMsg}');
      }
    }, builder: (context, state) {
      if (state is CoursesLoaded) {
        allCourses = (state).courses;
        return buildLoadedListWidgets();
      } else {
        return showLoadingIndicator();
      }
    });
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
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
        final courseList = allCourses[i];
        return CoursesList(
          courseList: courseList,
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
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  // BlocProvider.of<AuthCubit>(context).logOut();
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
              );
            },
          ),
          const SizedBox(
            width: 10,
          )
        ],
        toolbarHeight: 60.h,
      ),
      body: buildBlocWidget(),
    );
  }
}
