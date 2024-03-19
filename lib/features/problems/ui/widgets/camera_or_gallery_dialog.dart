import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/features/problems/logic/problems_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

cameraOrGalleryDialog(BuildContext blocContext) {
  return showDialog(
    context: blocContext,
    builder: (BuildContext context) {
      return SimpleDialog(
        backgroundColor: AppColors.secondaryColor,
        children: [
          SimpleDialogOption(
            onPressed: () {
              BlocProvider.of<ProblemsCubit>(blocContext)
                  .pickImage(ImageSource.camera);
              Navigator.pop(context);
            },
            padding: const EdgeInsets.all(20),
            child: Text(
              "From Camera",
              style: TextStyle(
                fontSize: 18.sp,
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              BlocProvider.of<ProblemsCubit>(blocContext)
                  .pickImage(ImageSource.gallery);
              Navigator.pop(context);
            },
            padding: EdgeInsets.all(20.w),
            child: Text(
              "From Gallary",
              style: TextStyle(
                fontSize: 18.sp,
              ),
            ),
          ),
        ],
      );
    },
  );
}
