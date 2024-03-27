import 'package:education_app/core/routing/routes.dart';
import 'package:flutter/material.dart';

class TeacherSubjectDrawer extends StatelessWidget {
  const TeacherSubjectDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(42, 42, 42, 1),
            ),
            child: InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed(AppRoutes.studentsFeedbackRoute),
                child: const Text('Students Feedback')),
          ),
        ],
      ),
    );
  }
}
