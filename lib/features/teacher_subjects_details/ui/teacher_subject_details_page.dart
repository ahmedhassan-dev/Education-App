import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher_subjects_details/logic/teacher_subject_details_cubit.dart';
import 'package:education_app/features/teacher_subjects_details/ui/widgets/courses_list.dart';
import 'package:education_app/features/teacher_subjects_details/ui/widgets/no_available_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherSubjectDetailsPage extends StatefulWidget {
  final String subject;
  const TeacherSubjectDetailsPage({super.key, required this.subject});

  @override
  State<TeacherSubjectDetailsPage> createState() =>
      _TeacherSubjectDetailsPageState();
}

class _TeacherSubjectDetailsPageState extends State<TeacherSubjectDetailsPage> {
  List<Courses> subjectCourses = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TeacherSubjectDetailsCubit>(context)
        .getSubjectCourses(subject: widget.subject);
  }

  PreferredSizeWidget? appBar() {
    return AppBar(
      title: Text(
        '${widget.subject} Courses',
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.addNewCoursePage,
                  arguments: widget.subject);
            },
            child: Icon(
              Icons.add,
              color: AppColors.whiteColor,
              size: 40.w,
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
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.scale,
          title: 'Error',
          desc: state.errorMsg.toString(),
          dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
        ).show();
      }
    }, builder: (context, state) {
      if (state is CoursesLoaded) {
        subjectCourses = (state).courses;
        if (subjectCourses.isEmpty) {
          return NoAvailableCourses(onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.addNewCoursePage,
                arguments: widget.subject);
          });
        }
        return buildLoadedListWidgets();
      } else {
        return const ShowLoadingIndicator();
      }
    });
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [buildCoursesList(), const SizedBox(height: 24.0)],
      ),
    );
  }

  Widget buildCoursesList() {
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
    return Scaffold(appBar: appBar(), body: buildBlocWidget());
  }
}