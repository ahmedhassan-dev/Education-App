import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/features/teacher/ui/widgets/problems_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showProblemsModel(BuildContext context,
    {required List<Problems> problemsList}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.backGroundColor,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.0.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProblemsList(problemsList),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildProblemsList(List<Problems> problemsList) {
  return ListView.builder(
    itemCount: problemsList.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int i) {
      final problem = problemsList[i];
      return ProblemsList(
        problem: problem,
      );
    },
  );
}
