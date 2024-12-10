import 'package:education_app/core/functions/service_locator.dart';
import 'package:education_app/core/services/firebase_messaging_system.dart';
import 'package:education_app/firebase_options/firebase_options_prod.dart';
import 'package:education_app/core/widgets/simple_bloc_observer.dart';
import 'package:education_app/my_app.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SentryFlutter.init((options) {
    options.dsn =
        'https://3163e1d5c310fcbb083ff5427380d808@o4508444759293952.ingest.us.sentry.io/4508444772728832';
    options.tracesSampleRate = 1.0;
    options.profilesSampleRate = 1.0;
    options.attachScreenshot = true;

    options.screenshotQuality = SentryScreenshotQuality.medium;
    options.attachViewHierarchy = true;
    options.enableAutoSessionTracking = true;
    options.reportPackages = false;
    options.enableNativeCrashHandling = true;
  }, appRunner: () async {
    if (kIsWeb) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
    } else {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await configureDependencies();

    await FireBaseMessagingSystem.getPermissionStatus();
    await FireBaseMessagingSystem.setMessagingInForeGround();

    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );

    await ScreenUtil.ensureScreenSize();
    Bloc.observer = SimpleBlocObserver();
    runApp(const MyApp());
  });
}
