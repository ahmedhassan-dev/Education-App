import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/widgets/awesome_dialog.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher_subjects_details/logic/teacher_subject_details_cubit.dart';
import 'package:education_app/features/teacher_subjects_details/ui/widgets/courses_list.dart';
import 'package:education_app/features/teacher_subjects_details/ui/widgets/no_available_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherSubjectDetailsPage extends StatelessWidget {
  final String subject;
  const TeacherSubjectDetailsPage({super.key, required this.subject});

  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: Text(
        '$subject Courses',
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(AppRoutes.addNewCoursePage, arguments: subject);
            },
            child: Icon(
              Icons.add,
              color: AppColors.whiteColor,
              size: 40,
            )),
        const SizedBox(
          width: 10,
        )
      ],
      toolbarHeight: 60.h,
    );
  }

  Widget buildBlocWidget() {
    return BlocConsumer<TeacherSubjectDetailsCubit, TeacherSubjectDetailsState>(
        listener: (BuildContext context, TeacherSubjectDetailsState state) {
      if (state is ErrorOccurred) {
        errorAwesomeDialog(context, state.errorMsg).show();
      }
    }, builder: (context, state) {
      if (state is CoursesLoaded) {
        final List<Courses> subjectCourses = (state).courses;
        if (subjectCourses.isEmpty) {
          return NoAvailableCourses(onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.addNewCoursePage, arguments: subject);
          });
        }
        return buildLoadedListWidgets(subjectCourses);
      } else {
        return const ShowLoadingIndicator();
      }
    });
  }

  Widget buildLoadedListWidgets(subjectCourses) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildCoursesList(subjectCourses),
          const SizedBox(height: 24.0)
        ],
      ),
    );
  }

  Widget buildCoursesList(subjectCourses) {
    return ListView.builder(
      itemCount: subjectCourses.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        final course = subjectCourses[i];
        return CoursesList(
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
