import 'package:education_app/core/constants/assets.dart';
import 'package:education_app/core/helpers/spacing.dart';
import 'package:education_app/core/theming/styles.dart';
import 'package:education_app/features/problems/logic/problems_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProblemsAppBar extends StatelessWidget {
  final String subject;
  final BuildContext context;
  const ProblemsAppBar({
    super.key,
    required this.subject,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        subject,
        style: Styles.bodyLarge16,
      ),
      automaticallyImplyLeading: false,
      actions: [
        Text(
          context.read<ProblemsCubit>().userScore,
          style: Styles.bodyLarge16.copyWith(fontWeight: FontWeight.w600),
        ),
        horizontalSpace(5),
        Image.asset(
          AppAssets.starIcon,
          height: 35.h,
        ),
        horizontalSpace(5)
      ],
    );
  }
}
