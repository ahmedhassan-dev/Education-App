import 'package:flutter/material.dart';

class NoAvailableCourses extends StatelessWidget {
  const NoAvailableCourses({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
          onTap: () {}, child: const Text("Don't have courses? ADD ONE")),
    );
  }
}
