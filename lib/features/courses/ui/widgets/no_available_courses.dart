import 'package:flutter/material.dart';

class NoCoursesAvailable extends StatelessWidget {
  const NoCoursesAvailable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No courses available."),
    );
  }
}
