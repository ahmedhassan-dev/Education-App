import 'package:education_app/core/widgets/subjects_app_bar.dart';
import 'package:education_app/features/teacher_subjects/logic/teacher_subjects_cubit.dart';
import 'package:education_app/features/teacher_subjects/ui/widgets/subjects_list.dart';
import 'package:education_app/features/teacher_subjects/ui/widgets/teacher_subjects_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherSubjectsPage extends StatelessWidget {
  final List<String> subjects;
  const TeacherSubjectsPage({super.key, required this.subjects});

  Widget buildBlocWidget(context) {
    return BlocBuilder<TeacherSubjectsCubit, TeacherSubjectsState>(
        builder: (context, state) {
      return teacherSubjectsPage(context);
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

  Widget teacherSubjectsPage(context) {
    return Scaffold(
      appBar: subjectsAppBar(context),
      drawer: const TeacherSubjectDrawer(),
      body: buildSubjectsListWidgets(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget(context);
  }
}
