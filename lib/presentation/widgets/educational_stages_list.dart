import 'package:education_app/business_logic/teacher_cubit/teacher_cubit.dart';
import 'package:education_app/utilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EducationalStagesList extends StatelessWidget {
  final String stage;

  const EducationalStagesList({
    super.key,
    required this.stage,
  });

  Widget buildBlocWidget() {
    return BlocBuilder<TeacherCubit, TeacherState>(
      builder: (context, state) {
        if (state is Loading) {
          return showLoadingIndicator();
        } else {
          return stageElement(context);
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

  Widget stageElement(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<TeacherCubit>(context)
              .getSelectedEducationalStages(stage: stage);
        },
        child: Container(
          decoration: BoxDecoration(
              color: BlocProvider.of<TeacherCubit>(context)
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
    return buildBlocWidget();
  }
}
