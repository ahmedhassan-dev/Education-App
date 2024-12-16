import 'package:education_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    this.leadingIcon,
    this.withNotification = false,
    this.blackIcon = false,
    this.onTap,
  });

  final String title;
  final String? leadingIcon;
  final bool withNotification;
  final bool blackIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: title,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (withNotification)
              TextSpan(
                text: '(2)',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Colors.black.withOpacity(0.30000001192092896),
                      fontWeight: FontWeight.w600,
                    ),
              ),
          ],
        ),
      ),
      // leading: leadingIcon != null
      //     ? SvgPicture.asset(
      //         leadingIcon!,
      //         colorFilter: blackIcon
      //             ? ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn)
      //             : null,
      //       )
      //     : null,
      // trailing: RotatedBox(
      //   quarterTurns: 90,
      //   child: Icon(
      //     Icons.arrow_back_ios_new_rounded,
      //     color: AppColors.whiteColor,
      //     size: 18.0.h,
      //   ),
      // ),
      onTap: onTap,
    );
  }
}
