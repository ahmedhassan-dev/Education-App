import 'package:education_app/core/widgets/no_data_widget.dart';
import 'package:education_app/core/widgets/subjects_app_bar.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/courses/logic/courses_cubit.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/courses/ui/widgets/home_view_body.dart';
import 'package:education_app/features/problems/ui/widgets/problems_page_drawer.dart';
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
    return BlocBuilder<CoursesCubit, CoursesState>(builder: (context, state) {
      if (state is CoursesLoaded) {
        allCourses = (state).courses;
        if (allCourses.isEmpty) {
          return const NoDataWidget(
            message: "No Courses Available.",
          );
        }
        return buildCoursesPage();
      } else {
        return const ShowLoadingIndicator();
      }
    });
  }

  Widget buildCoursesPage() {
    return Scaffold(
      appBar: subjectsAppBar(context),
      drawer: const ProblemsPageDrawer(),
      body: HomeViewBody(allCourses: allCourses),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget();
  }
}
