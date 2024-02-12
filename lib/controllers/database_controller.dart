import 'package:education_app/data/models/solved_problems.dart';
import 'package:education_app/data/models/student.dart';
import 'package:education_app/data/services/firestore_services.dart';
import 'package:education_app/utilities/api_path.dart';

abstract class Database {
  Future<void> setUserData({required Student userData, required String path});
  setToken(String uid, String userToken, String path);
  Future<void> submitSolution(SolvedProblems address);
}

class FirestoreDatabase implements Database {
  final String uid;
  final _service = FirestoreServices.instance;

  FirestoreDatabase(this.uid);

  @override
  Future<void> setUserData(
          {required dynamic userData, required String path}) async =>
      await _service.setData(
        path: path,
        data: userData.toMap(),
      );

  @override
  Future<void> setToken(String uid, String userToken, String path) async =>
      await _service.setData(
        path: path,
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
