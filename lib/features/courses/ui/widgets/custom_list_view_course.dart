import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/courses/ui/widgets/courses_list.dart';
import 'package:flutter/material.dart';

class CustomListViewCourse extends StatelessWidget {
  const CustomListViewCourse({
    super.key,
    required this.allCourses,
  });

  final List<Courses> allCourses;

  @override
  Widget build(BuildContext context) {
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
}
