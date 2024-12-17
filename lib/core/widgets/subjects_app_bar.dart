import 'package:education_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar subjectsAppBar(BuildContext context) {
  return AppBar(
    title: const Align(
        alignment: Alignment(-1.3, 0),
        child: Text('Subjects', style: Styles.headlineMedium28)),
    automaticallyImplyLeading: true,
    // actions: [
    //   ElevatedButton(
    //     onPressed: onPressed,
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: Theme.of(context).primaryColor,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(24.0),
    //       ),
    //     ),
    //     child: const Text(
    //       'Log Out',
    //       style: TextStyle(color: Colors.white),
    //     ),
    //   ),
    //   const SizedBox(
    //     width: 10,
    //   )
    // ],
    toolbarHeight: 60.h,
  );
}
