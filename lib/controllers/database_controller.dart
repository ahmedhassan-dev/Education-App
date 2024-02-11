import 'package:education_app/data/models/solved_problems.dart';
import 'package:education_app/data/models/user_data.dart';
import 'package:education_app/data/services/firestore_services.dart';
import 'package:education_app/utilities/api_path.dart';

abstract class Database {
  Future<void> setUserData(Student userData);
  setToken(String uid, String userToken);
  Future<void> submitSolution(SolvedProblems address);
}

class FirestoreDatabase implements Database {
  final String uid;
  final _service = FirestoreServices.instance;

  FirestoreDatabase(this.uid);

  @override
  Future<void> setUserData(Student userData) async => await _service.setData(
        path: ApiPath.user(userData.uid),
        data: userData.toMap(),
      );

  @override
  Future<void> setToken(String uid, String userToken) async =>
      await _service.setData(
        path: ApiPath.userToken(uid),
        data: {"token": userToken},
      );

  @override
  Future<void> submitSolution(SolvedProblems solution) => _service.setData(
        path: ApiPath.solvedProblems(
          uid,
          solution.id,
        ),
        data: solution.toMap(),
      );
}
