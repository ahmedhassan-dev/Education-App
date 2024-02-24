import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:education_app/features/teacher/logic/teacher_cubit.dart';
import 'package:education_app/features/teacher/ui/widgets/school_subjects_list.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  Widget buildBlocWidget() {
    return BlocBuilder<TeacherCubit, TeacherState>(
      builder: (context, state) {
        if (state is Loading) {
          return showLoadingIndicator();
        } else {
          return buildStackWidget();
        }
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

  Widget _submitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          try {
            await BlocProvider.of<TeacherCubit>(context).saveSubjects();
            if (!mounted) return;
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.selectEducationalStagesRoute);
          } catch (e) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.scale,
              title: 'Error',
              desc: e.toString(),
              dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
            ).show();
          }
        },
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

  buildStackWidget() {
    return SizedBox(
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
              child: SingleChildScrollView(
            child: buildSchoolSubjectsList(),
          )),
          Positioned(
            right: 0,
            left: 0,
            bottom: 10.h,
            child: _submitButton(),
          )
        ],
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
      body: buildStackWidget(),
    );
  }
}
