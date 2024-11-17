import 'package:education_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class CheckAnswerButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final IconData icon;
  const CheckAnswerButton(
      {super.key,
      required this.onTap,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 50,
          width: 70,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(13)),
          child: Icon(
            icon,
            color: AppColors.whiteColor,
            size: 40,
          )),
    );
  }
}
