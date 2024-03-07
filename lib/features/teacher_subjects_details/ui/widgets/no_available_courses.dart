import 'package:flutter/material.dart';

class NoAvailableCourses extends StatelessWidget {
  final VoidCallback onTap;
  const NoAvailableCourses({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
          onTap: onTap, child: const Text("Don't have courses? ADD ONE")),
    );
  }
}
