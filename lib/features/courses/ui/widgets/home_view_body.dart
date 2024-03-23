import 'package:education_app/features/courses/ui/widgets/custom_list_view_course.dart';
import 'package:flutter/material.dart';
import 'package:education_app/features/courses/data/models/courses.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({
    super.key,
    required this.allCourses,
  });

  final List<Courses> allCourses;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          CustomListViewCourse(allCourses: allCourses),
          const SizedBox(height: 24.0)
        ],
      ),
    );
  }
}
