import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher_courses/logic/teacher_courses_cubit.dart';
import 'package:education_app/features/teacher_courses/ui/widgets/subjects_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherCoursesPage extends StatefulWidget {
  final List<String> subjects;
  const TeacherCoursesPage({super.key, required this.subjects});

  @override
  State<TeacherCoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<TeacherCoursesPage> {
  List<Courses> allCourses = [];

  Widget buildBlocWidget() {
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
      return teacherCoursesPage();
    });
  }

  Widget buildSubjectsListWidgets() {
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

  Widget teacherCoursesPage() {
    return Scaffold(
      appBar: appBar(context),
      body: buildSubjectsListWidgets(),
    );
  }

  AppBar appBar(BuildContext context) {
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
          onPressed: () {
            BlocProvider.of<TeacherCoursesCubit>(context).logOut();
          },
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

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget();
  }
}
