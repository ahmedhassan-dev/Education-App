import 'package:bloc/bloc.dart';
import 'package:education_app/features/authentication/data/models/teacher.dart';
import 'package:education_app/features/authentication/data/repos/auth_repo.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:meta/meta.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:education_app/core/constants/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/features/authentication/data/models/student.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:education_app/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  String? mytoken;
  AuthRepository authRepository;
  String email;
  String password;
  AuthFormType authFormType;
  String userType;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  AuthCubit(
    this.authRepository, {
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
    await storeUserTypeInSharedPreferences();
    await storeTeacherEmailInSharedPreferences(email: email);
    emit(SubmitionVerified());
  }

  storeUserTypeInSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType);
  }

  storeTeacherEmailInSharedPreferences({required String email}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  getAndSendToken(String? uid) async {
    mytoken = await FirebaseMessaging.instance.getToken();
    if (mytoken != null && uid != null) {
      Map<String, String> userToken = {"token": mytoken!};
      await authRepository.setToken(
          userToken, ApiPath.userToken(uid, userType));
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
      await authRepository.setUserData(
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

  // Future<void> logOut() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     emit(LogedOut());
  //   } catch (e) {
  //     emit(LogedOutError(errorMsg: e.toString()));
  //   }
  // }

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
          await authRepository.setUserData(
              userData: userObject(user.uid, user.displayName, user.email),
              path: userPath(user.uid));
        }
        await storeUserTypeInSharedPreferences();
        await storeTeacherEmailInSharedPreferences(email: user.email!);
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
