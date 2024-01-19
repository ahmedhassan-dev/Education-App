import 'package:education_app/controllers/database_controller.dart';
import 'package:education_app/models/user_data.dart';
import 'package:education_app/services/auth.dart';
import 'package:education_app/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:education_app/utilities/enums.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController with ChangeNotifier {
  final AuthBase auth;
  String email;
  String password;
  AuthFormType authFormType;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  // TODO: It's not a best practice thing but it's temporary
  final database = FirestoreDatabase('123');

  AuthController({
    required this.auth,
    this.email = '',
    this.password = '',
    this.authFormType = AuthFormType.login,
  });

  Future<void> submit() async {
    try {
      if (authFormType == AuthFormType.login) {
        await auth.loginWithEmailAndPassword(email, password);
      } else {
        final user = await auth.signUpWithEmailAndPassword(email, password);
        await database.setUserData(UserData(
          uid: user?.uid ?? documentIdFromLocalData(),
          email: email,
          lastProblem: {"0": DateTime.now()},
        ));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> googleLogIn() async {
    try {
      final googleUser = await googleSignIn.signIn();
      _user = googleUser;
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = authFormType == AuthFormType.login
        ? AuthFormType.register
        : AuthFormType.login;
    copyWith(
      email: '',
      password: '',
      authFormType: formType,
    );
  }

  void updateEmail(String email) => copyWith(email: email);

  void updatePassword(String password) => copyWith(password: password);

  void copyWith({
    String? email,
    String? password,
    AuthFormType? authFormType,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.authFormType = authFormType ?? this.authFormType;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await auth.logout();
    } catch (e) {
      rethrow;
    }
  }
}
