import 'package:education_app/core/helpers/context_extension.dart';
import 'package:education_app/core/helpers/spacing.dart';
import 'package:education_app/core/theming/styles.dart';
import 'package:education_app/features/problems/logic/problems_cubit.dart';
import 'package:education_app/features/problems/ui/widgets/problem_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProblemDetailsSection extends StatelessWidget {
  final BuildContext context;
  final String subject;
  const ProblemDetailsSection({
    super.key,
    required this.context,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: context.width * 0.5,
                child: Text(
                  "${context.read<ProblemsCubit>().problemId}. ${context.read<ProblemsCubit>().title}",
                  style: Styles.titleLarge22,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              verticalSpace(10),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    subject,
                    style: Styles.bodyLarge16,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
          ProblemTimer(
            problemIndex: context.read<ProblemsCubit>().problemIndex,
            expectedTime: context.read<ProblemsCubit>().expectedTime,
          )
        ],
      ),
    );
  }
}
