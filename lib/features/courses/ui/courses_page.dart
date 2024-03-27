import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:education_app/core/widgets/subjects_app_bar.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/courses/logic/courses_cubit.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/features/courses/ui/widgets/home_view_body.dart';
import 'package:education_app/features/courses/ui/widgets/no_available_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: subjectsAppBar(context, () {
        BlocProvider.of<CoursesCubit>(context).logOut();
      }),
      body: HomeViewBody(allCourses: allCourses),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget();
  }
}
