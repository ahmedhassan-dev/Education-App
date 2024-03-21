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
  String? userName;
  String? phoneNum;
  String userType;
  String? uid;
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

  late bool userDataAvailability;
  Future<bool> _checkUserDataAvailability(String uid) async {
    userDataAvailability =
        await _checkUserDataAvailabilityInSharedPreferences();
    if (userDataAvailability) {
      return true;
    }
    await _checkUserDataAvailabilityInFireStore(uid);
    return userDataAvailability;
  }

  Future<bool> _checkUserDataAvailabilityInSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userName = prefs.getString('userName');
    if (userName == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _checkUserDataAvailabilityInFireStore(String uid) async {
    await authRepository
        .getUserData(
            path: "${userType.toLowerCase()}s", uid: uid, userType: userType)
        .then((data) async {
      if (data == null) {
        userDataAvailability = false;
      } else if (userType == "Teacher") {
        Teacher teacher = data as Teacher;
        await _storeUserDataInSharedPreferences(
            userName: teacher.userName!,
            email: teacher.email!,
            phoneNum: teacher.phoneNum!);
        userDataAvailability = true;
      } else {
        Student student = data as Student;
        await _storeUserDataInSharedPreferences(
            userName: student.userName!,
            email: student.email!,
            phoneNum: student.phoneNum!);
        userDataAvailability = true;
      }
    });
  }

  Future<void> _storeUserTypeInSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType);
  }

  Future<void> _storeUserDataInSharedPreferences(
      {required String userName,
      required String email,
      required String phoneNum}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('email', email);
    await prefs.setString('phoneNum', phoneNum);
  }

  Future<void> _getAndSendToken(String? uid) async {
    if (!AuthManager.isWeb) {
      mytoken = await FirebaseMessaging.instance.getToken();
      if (mytoken != null && uid != null) {
        Map<String, String> userToken = {"token": mytoken!};
        await authRepository.setToken(
            userToken, ApiPath.userToken(uid, userType));
      }
    }
  }

  Future<void> signIn() async {
    emit(Loading());
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await _getAndSendToken(user.user?.uid);
      await _storeUserTypeInSharedPreferences();
      await _checkUserDataAvailability(user.user!.uid);
      emit(SubmitionVerified());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(ErrorOccurred(errorMsg: 'User not found'));
      } else if (ex.code == 'wrong-password') {
        emit(ErrorOccurred(errorMsg: 'Wrong password'));
      } else if (ex.code == 'too-many-requests') {
        emit(ErrorOccurred(errorMsg: 'Please try again later'));
      }
      emit(ErrorOccurred(errorMsg: ex.code));
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  void setUserType({required String userType}) {
    this.userType = userType;
  }

  userObject(String? uid, String? userName, String? email, String? phoneNum) {
    if (userType == "Teacher") {
      return Teacher(
        uid: uid ?? documentIdFromLocalData(),
        userName: userName,
        email: email,
        phoneNum: phoneNum,
      );
    } else if (userType == "Student") {
      return Student(
          uid: uid ?? documentIdFromLocalData(),
          userName: userName,
          email: email,
          phoneNum: phoneNum);
    }
  }

  userPath(String? uid) {
    if (userType == "Teacher") {
      return ApiPath.teacher(uid!);
    } else if (userType == "Student") {
      return ApiPath.student(uid!);
    }
  }

  Future<void> signUp(String userName, String phoneNum) async {
    emit(Loading());
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await _getAndSendToken(user.user?.uid);
      await authRepository.setUserData(
          userData: userObject(user.user?.uid, userName, email, phoneNum),
          path: userPath(user.user!.uid));
      await _storeUserTypeInSharedPreferences();
      await _storeUserDataInSharedPreferences(
          userName: userName, email: email, phoneNum: phoneNum);
      emit(SubmitionVerified());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'email-already-in-use') {
        emit(ErrorOccurred(errorMsg: 'Email already in use'));
      } else if (ex.code == 'wrong-password') {
        emit(ErrorOccurred(errorMsg: 'Wrong password'));
      }
      emit(ErrorOccurred(errorMsg: ex.code));
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  Future<void> storeUserData(String userName, String phoneNum) async {
    await authRepository.setUserData(
        userData: userObject(uid, userName, email, phoneNum),
        path: userPath(uid));
    await _storeUserTypeInSharedPreferences();
    await _storeUserDataInSharedPreferences(
        userName: userName, email: email, phoneNum: phoneNum);
    emit(SubmitionVerified());
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
        await _getAndSendToken(user.uid);
        uid = user.uid;
        email = user.email!;
        if (userCredential.additionalUserInfo!.isNewUser) {
          emit(GetUserData());
        } else {
          await _checkUserDataAvailability(user.uid);
          if (userDataAvailability) {
            await _storeUserTypeInSharedPreferences();
            emit(SubmitionVerified());
          } else {
            emit(GetUserData());
          }
        }
      }
    } on FirebaseAuthException catch (ex) {
      emit(ErrorOccurred(errorMsg: ex.code));
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
