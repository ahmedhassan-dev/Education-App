import 'package:education_app/business_logic/teacher_cubit/teacher_cubit.dart';
import 'package:education_app/presentation/widgets/school_subjects_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectSubjectsPage extends StatefulWidget {
  const SelectSubjectsPage({super.key});
  static const List<String> schoolSubjects = [
    'Math',
    'English',
    'Physics',
    'Chemistry',
    'Science',
    'History',
    'Geography',
    'ICT',
    'Art',
    'Biology',
    'Others'
  ];

  @override
  State<SelectSubjectsPage> createState() => _SelectSubjectsPageState();
}

class _SelectSubjectsPageState extends State<SelectSubjectsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TeacherCubit>(context).retrieveTeacherData();
  }

  buildSchoolSubjectsList() {
    return ListView.builder(
      itemCount: SelectSubjectsPage.schoolSubjects.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        final schoolSubject = SelectSubjectsPage.schoolSubjects[i];
        return SchoolSubjectsList(
          subject: schoolSubject,
        );
      },
    );
  }

  Widget button() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        child: const Text(
          "Submit",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose subjects you can teach?",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
              child: SingleChildScrollView(
            child: buildSchoolSubjectsList(),
          )),
          Positioned(
            right: 0,
            left: 0,
            bottom: 10,
            child: button(),
          )
        ],
      ),
    );
  }
}
