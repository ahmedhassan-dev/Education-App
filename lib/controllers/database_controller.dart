import 'package:education_app/models/courses_model.dart';
import 'package:education_app/models/solved_problems.dart';
import 'package:education_app/models/user_data.dart';
import 'package:education_app/services/firestore_services.dart';
import 'package:education_app/utilities/api_path.dart';

abstract class Database {
  Stream<List<CoursesModel>> courseListStream();

  Future<void> setUserData(UserData userData);
  setToken(String uid, String userToken);
  Future<void> submitSolution(SolvedProblems address);
}

class FirestoreDatabase implements Database {
  final String uid;
  final _service = FirestoreServices.instance;

  FirestoreDatabase(this.uid);

  @override
  Stream<List<CoursesModel>> courseListStream() => _service.collectionsStream(
        path: ApiPath.courses(),
        builder: (data, documentId) => CoursesModel.fromMap(data!, documentId),
      );

  @override
  Future<void> setUserData(UserData userData) async => await _service.setData(
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
