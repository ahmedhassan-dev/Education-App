import 'package:education_app/core/helpers/spacing.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/theming/styles.dart';
import 'package:education_app/core/widgets/get_list_of_strings_text.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as b;

import '../../logic/courses_student_feedback_cubit.dart';

class CoursesFeedbackList extends StatelessWidget {
  final Courses course;
  const CoursesFeedbackList({
    super.key,
    required this.course,
  });

  Widget courseElement(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(AppRoutes.checkAnswersRoute,
                arguments: course.solutionsNeedingReview)
            .then((v) {
          context.read<CoursesStudentFeedbackCubit>().getTeacherSortedCourses();
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 32.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        height: 140.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text("${course.stage} Course",
                  overflow: TextOverflow.ellipsis, style: Styles.bodyLarge16),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: GetListOfStringsText(
                        stringList: course.topics.cast<String>())),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    course.needReviewCounter.toString(),
                    style: Styles.bodyLarge16,
                  ),
                )
              ],
            ),
            Flexible(
              child: Text(
                course.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Styles.bodyMedium14,
              ),
            ),
            verticalSpace(10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return courseElement(context);
  }
}
