import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoursesList extends StatelessWidget {
  final Courses courseList;
  const CoursesList({
    super.key,
    required this.courseList,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(AppRoutes.problemPage, arguments: courseList);
          },
          child: SizedBox(
            height: 160.h,
            child: Image.network(
              courseList.imgUrl,
            ),
          ),
        ),
      ),
    );
  }
}
