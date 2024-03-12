import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/courses/logic/courses_cubit.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/courses/ui/widgets/courses_list.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/features/courses/ui/widgets/no_available_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Courses> allCourses = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CoursesCubit>(context).getAllCourses();
  }

  Widget buildBlocWidget() {
    return BlocConsumer<CoursesCubit, CoursesState>(
        listener: (BuildContext context, CoursesState state) {
      if (state is LogedOut) {
        Navigator.of(context)
            .pushReplacementNamed(AppRoutes.selectUserTypeRoute);
      } else if (state is LogedOutError) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.scale,
          title: 'Logout Error',
          desc: state.errorMsg.toString(),
          dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
        ).show();
      }
    }, builder: (context, state) {
      if (state is CoursesLoaded) {
        allCourses = (state).courses;
        if (allCourses.isEmpty) {
          return const NoCoursesAvailable();
        }
        return buildCoursesPage();
      } else {
        return const ShowLoadingIndicator();
      }
    });
  }

  Widget buildCoursesPage() {
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [buildCoursesList(), const SizedBox(height: 24.0)],
        ),
      ),
    );
  }

  Widget buildCoursesList() {
    return ListView.builder(
      itemCount: allCourses.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        final course = allCourses[i];
        return CoursesList(
          course: course,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget();
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
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
            BlocProvider.of<CoursesCubit>(context).logOut();
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
      toolbarHeight: 60.h,
    );
  }
}
