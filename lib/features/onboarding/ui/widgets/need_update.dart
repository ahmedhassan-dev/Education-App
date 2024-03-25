import 'package:education_app/core/helpers/spacing.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NeedToUpdate extends StatelessWidget {
  final VoidCallback onTap;
  const NeedToUpdate({
    super.key,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Please Update The App❤️",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        verticalSpace(20),
        MainButton(
          text: "Update Now?",
          onTap: onTap,
          width: 170.w,
        )
      ],
    );
  }
}
