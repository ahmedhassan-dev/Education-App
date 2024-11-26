import 'package:education_app/core/functions/service_locator.dart';
import 'package:education_app/core/services/firebase_messaging_system.dart';
import 'package:education_app/firebase_options/firebase_options_prod.dart';
import 'package:education_app/core/widgets/simple_bloc_observer.dart';
import 'package:education_app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  await ScreenUtil.ensureScreenSize();
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}
