import 'package:education_app/utilities/app_colors.dart';
import 'package:education_app/utilities/assets.dart';
import 'package:education_app/utilities/routes.dart';
import 'package:flutter/material.dart';

class UserTypeList extends StatelessWidget {
  final String userType;
  const UserTypeList({
    super.key,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushReplacementNamed(
              AppRoutes.loginPageRoute,
              arguments: userType);
        },
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 160,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userType,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              Image.asset(AppAssets.selectUserListImages(userType)),
            ],
          ),
        ),
      ),
    );
  }
}
