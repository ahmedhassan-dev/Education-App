import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/widgets/get_list_of_strings_text.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoursesList extends StatelessWidget {
  final Courses course;
  const CoursesList({
    super.key,
    required this.course,
  });

  Widget courseElement(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.teacherSubjectsDetailsRoute,
              arguments: course);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${course.stage} Course",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              GetListOfStringsText(stringList: course.topics.cast<String>()),
              Flexible(
                child: Text(
                  course.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
              SizedBox(
                height: 10.h,
              )
              // Image.asset(AppAssets.selectUserListImages(userType)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return courseElement(context);
  }
}
