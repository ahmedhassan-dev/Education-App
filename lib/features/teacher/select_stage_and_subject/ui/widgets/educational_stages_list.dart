import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/logic/select_stage_and_subject_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EducationalStagesList extends StatelessWidget {
  final String stage;

  const EducationalStagesList({
    super.key,
    required this.stage,
  });

  Widget stageElement(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<SelectStageAndSubjectCubit>(context)
              .getSelectedEducationalStages(stage: stage);
        },
        child: Container(
          decoration: BoxDecoration(
              color: BlocProvider.of<SelectStageAndSubjectCubit>(context)
                      .isEducationalStageAvailable(stage: stage)
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stage,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              // Image.asset(AppAssets.selectUserListImages(userType)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return stageElement(context);
  }
}
