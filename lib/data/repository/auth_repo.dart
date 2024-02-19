import 'package:education_app/data/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<User?> loginWithEmailAndPassword(String email, String password);

  Future<User?> signUpWithEmailAndPassword(String email, String password);

  Future<void> setUserData({required User userData, required String path});

  Future<void> setToken(Map<String, String> userToken, String path);

  Future<void> logout();
}

class AuthRepository implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  FirestoreServices firestoreServices;
  AuthRepository(this.firestoreServices);

  @override
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    final userAuth = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userAuth.user;
  }

  @override
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    final userAuth = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userAuth.user;
  }

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<void> setUserData(
          {required dynamic userData, required String path}) async =>
      await firestoreServices.setData(
        path: path,
        data: userData.toMap(),
      );

  @override
  Future<void> setToken(Map<String, String> userToken, String path) async =>
      await firestoreServices.setData(
        path: path,
        data: userToken,
      );

  //TODO: need to be refactored
  @override
  Future<void> logout() async => await _firebaseAuth.signOut();
}
