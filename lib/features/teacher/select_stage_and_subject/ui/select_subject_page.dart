import 'package:education_app/core/widgets/awesome_dialog.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/core/widgets/snackbar.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/logic/select_stage_and_subject_cubit.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/ui/widgets/school_subjects_list.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../onboarding/logic/onboarding_cubit.dart';

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
    BlocProvider.of<SelectStageAndSubjectCubit>(context).retrieveTeacherData();
  }

  Widget buildBlocWidget() {
    return BlocConsumer<SelectStageAndSubjectCubit, SelectStageAndSubjectState>(
      builder: (context, state) {
        if (state is Loading) {
          return const ShowLoadingIndicator();
        }
        return buildStackWidget();
      },
      listener: (BuildContext context, SelectStageAndSubjectState state) {
        if (state is UserIsNotTeacher) {
          context.read<OnboardingCubit>().logOut();
          showSnackBar(context, "Unvalid teacher email");
        }
      },
    );
  }

  buildSchoolSubjectsList() {
    return Column(
      children: [
        ListView.builder(
          itemCount: SelectSubjectsPage.schoolSubjects.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            final schoolSubject = SelectSubjectsPage.schoolSubjects[i];
            return SchoolSubjectsList(
              subject: schoolSubject,
            );
          },
        ),
        80.verticalSpace
      ],
    );
  }

  Widget _submitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (context.read<SelectStageAndSubjectCubit>().subjects.isEmpty) {
            showSnackBar(context, "Please select at least one subject.");
            return;
          }
          try {
            await BlocProvider.of<SelectStageAndSubjectCubit>(context)
                .saveSubjects();
            if (!mounted) return;
            Navigator.of(context)
                .pushNamed(AppRoutes.selectEducationalStagesRoute);
          } catch (e) {
            errorAwesomeDialog(context, e).show();
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
            physics: const BouncingScrollPhysics(),
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
      body: buildBlocWidget(),
    );
  }
}
