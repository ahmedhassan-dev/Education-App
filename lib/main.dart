import 'package:education_app/firebase_options.dart';
import 'package:education_app/services/auth.dart';
import 'package:education_app/utilities/router.dart';
import 'package:education_app/utilities/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (_) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Education App',
        // TODO: Refactor this theme away from the main file
        theme: ThemeData(
            appBarTheme:
                const AppBarTheme(color: Color.fromRGBO(42, 42, 42, 1)),
            scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
            primaryColor: Colors.red,
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: Theme.of(context).textTheme.subtitle1,
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
