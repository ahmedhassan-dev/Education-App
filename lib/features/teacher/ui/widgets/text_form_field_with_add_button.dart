import 'package:education_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFieldWithAddButton extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final List<String> stringList;
  final VoidCallback onTap;
  const TextFormFieldWithAddButton({
    super.key,
    required this.controller,
    required this.labelText,
    required this.stringList,
    required this.onTap,
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
            contentPadding: EdgeInsets.only(
                right: 40.w, left: 15.w, bottom: 20.h, top: 20.h)),
        validator: (value) => (value!.isNotEmpty || stringList.isNotEmpty)
            ? null
            : 'Please enter any ${labelText.toLowerCase()}',
      ),
      Positioned(
          top: 17.h,
          right: 10.w,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ))
    ]);
  }
}
