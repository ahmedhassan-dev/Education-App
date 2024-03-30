import 'package:education_app/core/constants/stages.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/widgets/awesome_dialog.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/logic/select_stage_and_subject_cubit.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/ui/widgets/educational_stages_list.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectEducationalStagesPage extends StatefulWidget {
  const SelectEducationalStagesPage({super.key});

  @override
  State<SelectEducationalStagesPage> createState() =>
      _SelectSubjectsPageState();
}

class _SelectSubjectsPageState extends State<SelectEducationalStagesPage> {
  Widget buildBlocWidget() {
    return BlocBuilder<SelectStageAndSubjectCubit, SelectStageAndSubjectState>(
      builder: (context, state) {
        if (state is Loading) {
          return const ShowLoadingIndicator();
        } else {
          return buildStageWidget();
        }
      },
    );
  }

  buildEducationalStagesList() {
    return ListView.builder(
      itemCount: EducationalStages.educationalStages.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        final stage = EducationalStages.educationalStages[i];
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
            await BlocProvider.of<SelectStageAndSubjectCubit>(context)
                .saveEducationalStages();
            if (!mounted) return;
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.landingPageRoute);
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

  buildStageWidget() {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: AppColors.secondaryColor),
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              child: Center(
                child: Text(
                  "What educational stages have you been involved in?",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      overflow: TextOverflow.visible),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                        child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget();
  }
}
