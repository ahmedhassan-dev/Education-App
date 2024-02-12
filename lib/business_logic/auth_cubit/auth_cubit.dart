import 'package:bloc/bloc.dart';
import 'package:education_app/data/models/teacher.dart';
import 'package:education_app/utilities/api_path.dart';
// import 'package:education_app/data/repository/auth_repo.dart';
import 'package:meta/meta.dart';
import 'package:education_app/controllers/database_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:education_app/utilities/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/data/models/student.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:education_app/utilities/constants.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  String? mytoken;
  // final AuthBase auth;
  String email;
  String password;
  AuthFormType authFormType;
  String userType;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  final database = FirestoreDatabase('123');
  AuthCubit({
    // required this.auth,
    this.email = '',
    this.password = '',
    this.authFormType = AuthFormType.login,
    this.userType = '',
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
      await database.setToken(uid, mytoken!, ApiPath.userToken(uid, userType));
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

  void setUserType({required String userType}) {
    this.userType = userType;
  }

  userObject(String? uid, String? userName, String? email) {
    if (userType == "Teacher") {
      return Teacher(
        uid: uid ?? documentIdFromLocalData(),
        userName: userName,
        email: email,
      );
    } else if (userType == "Student") {
      return Student(
        uid: uid ?? documentIdFromLocalData(),
        userName: userName,
        email: email,
      );
    }
  }

  userPath(String? uid) {
    if (userType == "Teacher") {
      return ApiPath.teacher(uid!);
    } else if (userType == "Student") {
      return ApiPath.student(uid!);
    }
  }

  Future<void> signUp() async {
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      getAndSendToken(user.user?.uid);
      await database.setUserData(
          userData: userObject(user.user?.uid, userType, email),
          path: userPath(user.user!.uid));
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(ErrorOccurred(errorMsg: 'user not found'));
      } else if (ex.code == 'wrong-password') {
        emit(ErrorOccurred(errorMsg: 'wrong password'));
      }
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
          await database.setUserData(
              userData: userObject(user.uid, user.displayName, user.email),
              path: userPath(user.uid));
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
