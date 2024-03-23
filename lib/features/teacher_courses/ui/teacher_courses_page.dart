import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/core/widgets/courses_app_bar.dart';
import 'package:education_app/features/teacher_courses/logic/teacher_courses_cubit.dart';
import 'package:education_app/features/teacher_courses/ui/widgets/subjects_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherCoursesPage extends StatelessWidget {
  final List<String> subjects;
  const TeacherCoursesPage({super.key, required this.subjects});

  Widget buildBlocWidget(context) {
    return BlocConsumer<TeacherCoursesCubit, TeacherCoursesState>(
        listener: (BuildContext context, TeacherCoursesState state) {
      if (state is LogedOut) {
        Navigator.of(context)
            .pushReplacementNamed(AppRoutes.selectUserTypeRoute);
      } else if (state is LogedOutError) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.scale,
          title: 'Logout Error',
          desc: state.errorMsg.toString(),
          dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
        ).show();
      }
    }, builder: (context, state) {
      return teacherCoursesPage(context);
    });
  }

  Widget buildSubjectsListWidgets() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
      itemCount: subjects.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        final subject = subjects[i];
        return SubjectsList(
          subject: subject,
        );
      },
    );
  }

  Widget teacherCoursesPage(context) {
    return Scaffold(
      appBar: coursesAppBar(context, () {
        BlocProvider.of<TeacherCoursesCubit>(context).logOut();
      }),
      body: buildSubjectsListWidgets(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget(context);
  }
}
