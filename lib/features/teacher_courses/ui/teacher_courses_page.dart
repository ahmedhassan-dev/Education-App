import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher_courses/ui/widgets/subjects_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherCoursesPage extends StatefulWidget {
  final List<String> subjects;
  const TeacherCoursesPage({super.key, required this.subjects});

  @override
  State<TeacherCoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<TeacherCoursesPage> {
  List<Courses> allCourses = [];

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Column(
          children: [buildSubjectsList(), const SizedBox(height: 24.0)],
        ),
      ),
    );
  }

  Widget buildSubjectsList() {
    return ListView.builder(
      itemCount: widget.subjects.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        final subject = widget.subjects[i];
        return SubjectsList(
          subject: subject,
        );
      },
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        automaticallyImplyLeading: false,
        // actions: [
        //   BlocBuilder<AuthCubit, AuthState>(
        //     builder: (context, state) {
        //       return ElevatedButton(
        //         onPressed: () {
        //           // BlocProvider.of<AuthCubit>(context).logOut();
        //         },
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Theme.of(context).primaryColor,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(24.0),
        //           ),
        //         ),
        //         child: const Text(
        //           'Log Out',
        //           style: TextStyle(color: Colors.white),
        //         ),
        //       );
        //     },
        //   ),
        //   const SizedBox(
        //     width: 10,
        //   )
        // ],
        toolbarHeight: 60.h,
      ),
      body: buildLoadedListWidgets(),
    );
  }
}
