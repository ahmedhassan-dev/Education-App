import 'package:education_app/business_logic/teacher_cubit/teacher_cubit.dart';
import 'package:education_app/presentation/widgets/educational_stages_list.dart';
import 'package:education_app/presentation/widgets/main_dialog.dart';
import 'package:education_app/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectEducationalStagesPage extends StatefulWidget {
  const SelectEducationalStagesPage({super.key});
  static const List<String> educationalStages = [
    'Primary Education',
    'Middle School',
    'Secondary Education',
    'Higher Education',
  ];

  @override
  State<SelectEducationalStagesPage> createState() =>
      _SelectSubjectsPageState();
}

class _SelectSubjectsPageState extends State<SelectEducationalStagesPage> {
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

  buildEducationalStagesList() {
    return ListView.builder(
      itemCount: SelectEducationalStagesPage.educationalStages.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        final stage = SelectEducationalStagesPage.educationalStages[i];
        return EducationalStagesList(
          stage: stage,
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
            await BlocProvider.of<TeacherCubit>(context)
                .saveEducationalStages();
            if (!mounted) return;
            Navigator.of(context).pushReplacementNamed(AppRoutes.teacherRoute);
          } catch (e) {
            MainDialog(context: context, title: 'Error', content: e.toString())
                .showAlertDialog();
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
            child: buildEducationalStagesList(),
          )),
          Positioned(
            right: 0,
            left: 0,
            bottom: 10,
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
        title: Flexible(
          child: Text(
            "What educational stages have \nyou been involved in?",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                overflow: TextOverflow.visible),
          ),
        ),
      ),
      body: buildStackWidget(),
    );
  }
}
