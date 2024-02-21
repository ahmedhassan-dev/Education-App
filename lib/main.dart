import 'package:education_app/firebase_options.dart';
import 'package:education_app/core/widgets/simple_bloc_observer.dart';
import 'package:education_app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
}
