import 'package:education_app/features/onboarding/ui/widgets/animated_logo_image.dart';
import 'package:education_app/features/onboarding/ui/widgets/custom_list_view_user_type.dart';
import 'package:flutter/material.dart';

class SelectUserPage extends StatelessWidget {
  const SelectUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedLogoImage(
          height: 170,
        ),
        CustomListViewUserType(),
      ],
    );
  }
}
