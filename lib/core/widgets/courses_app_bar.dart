import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar coursesAppBar(BuildContext context, final VoidCallback onPressed) {
  return AppBar(
    title: Text(
      'Courses',
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
    ),
    automaticallyImplyLeading: false,
    actions: [
      ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        child: const Text(
          'Log Out',
          style: TextStyle(color: Colors.white),
        ),
      ),
      const SizedBox(
        width: 10,
      )
    ],
    toolbarHeight: 60.h,
  );
}
