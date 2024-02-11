import 'package:bloc/bloc.dart';
// import 'package:education_app/data/repository/auth_repo.dart';
import 'package:meta/meta.dart';
import 'package:education_app/controllers/database_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:education_app/utilities/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/data/models/user_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:education_app/utilities/constants.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  String? mytoken;
  // final AuthBase auth;
  String email;
  String password;
  AuthFormType authFormType;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  final database = FirestoreDatabase('123');
  AuthCubit({
    // required this.auth,
    this.email = '',
    this.password = '',
    this.authFormType = AuthFormType.login,
  }) : super(AuthInitial());

  Future<void> submit() async {
    emit(Loading());
    if (authFormType == AuthFormType.login) {
      await signIn();
    } else {
      await signUp();
    }
    emit(SubmitionVerified());
  }

  getAndSendToken(String? uid) async {
    mytoken = await FirebaseMessaging.instance.getToken();
    if (mytoken != null && uid != null) {
      await database.setToken(uid, mytoken!);
    }
  }

  Future<void> signIn() async {
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      getAndSendToken(user.user?.uid);
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  Future<void> signUp() async {
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      getAndSendToken(user.user?.uid);
      await database.setUserData(Student(
        uid: user.user?.uid ?? documentIdFromLocalData(),
        userName: "user",
        email: email,
      ));
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser() {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }

  Future<void> googleLogIn() async {
    emit(Loading());
    try {
      final googleUser = await googleSignIn.signIn();
      _user = googleUser;
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        getAndSendToken(user.uid);
        if (userCredential.additionalUserInfo!.isNewUser) {
          await database.setUserData(Student(
            uid: user.uid,
            userName: user.displayName,
            email: user.email,
          ));
        }
      }
      emit(SubmitionVerified());
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
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
    emit(UpdateEmailAndPassword());
  }
}
