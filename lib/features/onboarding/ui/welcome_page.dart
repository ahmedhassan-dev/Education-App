import 'package:education_app/core/routing/routes.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/theming/styles.dart';
import 'package:education_app/features/onboarding/ui/widgets/animated_logo_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 350.h,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(220),
                      topRight: Radius.circular(220))),
              child: Opacity(
                  opacity: 0.5,
                  child: Image.asset("assets/welcome_image.jpeg")),
            ),
            Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height / 3.8),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(220),
                            topRight: Radius.circular(220))),
                  ),
                  Positioned(
                    bottom: (MediaQuery.of(context).size.height / 3.8) - 20,
                    child: const AnimatedLogoImage(
                      height: 45,
                    ),
                  ),
                  Positioned(
                    bottom: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushReplacementNamed(
                                AppRoutes.selectUserTypeRoute);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor),
                      child: Text(
                        "Let's Start",
                        textDirection: TextDirection.ltr,
                        style: Styles.titleLarge22.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ]),
          ],
        ),
      ),
    );
  }
}
