import 'package:education_app/business_logic/teacher_cubit/teacher_cubit.dart';
import 'package:education_app/utilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SchoolSubjectsList extends StatelessWidget {
  final String subject;
  const SchoolSubjectsList({
    super.key,
    required this.subject,
  });

  Widget buildBlocWidget() {
    return BlocBuilder<TeacherCubit, TeacherState>(
      builder: (context, state) {
        if (state is Loading) {
          return showLoadingIndicator();
        } else {
          return subjectElement(context);
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

  Widget subjectElement(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<TeacherCubit>(context)
              .getSelectedSubject(subject: subject);
        },
        child: Container(
          decoration: BoxDecoration(
              color: BlocProvider.of<TeacherCubit>(context)
                      .isSubjectAvailable(subject: subject)
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          height: 140.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                subject,
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
