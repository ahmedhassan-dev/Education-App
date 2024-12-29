import 'package:education_app/core/constants/constants.dart';
import 'package:education_app/core/functions/service_locator.dart';
import 'package:education_app/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/routing/router.dart';
import 'package:education_app/core/routing/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theming/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AuthManager.isWeb && !AuthManager.userType.isNullOrEmpty()) {
      getIt<FirebaseMessaging>().subscribeToTopic('allUsers');
      getIt<FirebaseMessaging>()
          .subscribeToTopic(AuthManager.userType!.toLowerCase());
    }
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'IronMan-Edu',
        theme: appTheme(context),
        onGenerateRoute: onGenerate,
        initialRoute: AppRoutes.landingPageRoute,
      ),
    );
  }
}
