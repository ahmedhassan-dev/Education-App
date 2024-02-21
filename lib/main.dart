import 'package:education_app/firebase_options.dart';
import 'package:education_app/presentation/widgets/simple_bloc_observer.dart';
import 'package:education_app/utilities/router.dart';
import 'package:education_app/utilities/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDIOA5lceD2iUPSJO4jMafw12sVO-FwzVA",
            authDomain: "education-app-ece7a.firebaseapp.com",
            projectId: "education-app-ece7a",
            storageBucket: "education-app-ece7a.appspot.com",
            messagingSenderId: "893761268354",
            appId: "1:893761268354:web:15d015e9b76d6be74e229b"));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: SimpleBlocObserver(),
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.subscribeToTopic('admin');
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Education App',
        // TODO: Refactor this theme away from the main file
        theme: ThemeData(
            disabledColor: Colors.white,
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
            appBarTheme:
                const AppBarTheme(color: Color.fromRGBO(42, 42, 42, 1)),
            scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
            primaryColor: const Color.fromRGBO(244, 67, 54, 1),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
              floatingLabelStyle: const TextStyle(color: Colors.white),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
            )),
        onGenerateRoute: onGenerate,
        initialRoute: AppRoutes.landingPageRoute,
      ),
    );
  }
}
