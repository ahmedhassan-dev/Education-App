import 'package:education_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFieldWithCameraButton extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool needReview;
  final VoidCallback onTap;
  final Function(String?) validator;
  const TextFormFieldWithCameraButton({
    super.key,
    required this.controller,
    required this.labelText,
    required this.needReview,
    required this.onTap,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            fillColor: AppColors.textFormFieldFillColor,
            filled: true,
            contentPadding: needReview
                ? EdgeInsets.only(
                    right: 40.w, left: 15.w, bottom: 20.h, top: 20.h)
                : null),
        validator: (value) {
          return validator(value);
        },
      ),
      needReview
          ? Positioned(
              top: 17.h,
              right: 10.w,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    // color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                  ),
                ),
              ))
          : const SizedBox(),
    ]);
  }
}
