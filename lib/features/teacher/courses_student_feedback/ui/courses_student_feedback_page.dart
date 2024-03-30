import 'package:education_app/core/theming/styles.dart';
import 'package:education_app/core/widgets/awesome_dialog.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher/courses_student_feedback/logic/courses_student_feedback_cubit.dart';
import 'package:education_app/features/teacher/courses_student_feedback/ui/widgets/courses_feedback_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoursesStudentFeedbackPage extends StatelessWidget {
  const CoursesStudentFeedbackPage({super.key});

  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Students Feedback', style: Styles.headlineMedium28),
      automaticallyImplyLeading: false,
      toolbarHeight: 60.h,
    );
  }

  Widget buildBlocWidget() {
    return BlocConsumer<CoursesStudentFeedbackCubit,
            CoursesStudentFeedbackState>(
        listener: (BuildContext context, CoursesStudentFeedbackState state) {
      if (state is ErrorOccurred) {
        errorAwesomeDialog(context, state.errorMsg).show();
      }
    }, builder: (context, state) {
      if (state is CoursesLoaded) {
        final List<Courses> courses = state.courses;
        return buildLoadedListWidgets(courses);
      } else {
        return const ShowLoadingIndicator();
      }
    });
  }

  Widget buildLoadedListWidgets(courses) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [buildCoursesList(courses), const SizedBox(height: 24.0)],
      ),
    );
  }

  Widget buildCoursesList(courses) {
    return ListView.builder(
      itemCount: courses.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        final course = courses[i];
        return CoursesFeedbackList(
          course: course,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(context), body: buildBlocWidget());
  }
}
