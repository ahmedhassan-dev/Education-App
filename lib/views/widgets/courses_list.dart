import 'package:education_app/controllers/database_controller.dart';
import 'package:education_app/models/courses_model.dart';
import 'package:education_app/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesList extends StatelessWidget {
  final CoursesModel courseList;
  const CoursesList({
    Key? key,
    required this.courseList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: GestureDetector(
          onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.problemPage,
              arguments: {'courseList': courseList, 'database': database}),
          child: SizedBox(
            height: 160,
            child: Image.network(
              courseList.imgUrl,
            ),
          ),
        ),
      ),
    );
  }
}
