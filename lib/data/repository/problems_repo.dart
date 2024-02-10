import 'package:education_app/data/models/problems.dart';
import 'package:education_app/data/models/solved_problems.dart';
import 'package:education_app/data/services/firestore_services.dart';

class ProblemsRepository {
  FirestoreServices firestoreServices;
  ProblemsRepository(this.firestoreServices);

  Future<dynamic> retrieveUserData(
      {required String path, required String docName}) async {
    final userData = await firestoreServices.retrieveDataFormDocument(
        path: path, docName: docName) as dynamic;
    return userData;
  }

  // TODO: maybe I can make a copywith method in the userdata class to edit theclass and updata the data throw the model
  Future<void> updateUserData(
          {required String path,
          required int score,
          required Map<String, dynamic> userScores,
          required Map<String, dynamic> lastProblemIdx,
          required Map<String, dynamic> lastProblemTime}) async =>
      await firestoreServices.updateUserData(
          path: path,
          score: score,
          userScores: userScores,
          lastProblemIdx: lastProblemIdx,
          lastProblemTime: lastProblemTime);

  Future<List<Problems>> retrieveSubjectProblems(
      {required String subject,
      required String path,
      required String sortedBy}) async {
    final subjectProblems = await firestoreServices.retrieveSortedData(
        subject: subject, path: path, sortedBy: sortedBy) as List;
    return subjectProblems
        .map((docSnapshot) => Problems.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<SolvedProblems>> retrieveSolvedProblems(
      {required String subject,
      required String mainCollectionPath,
      required String uid,
      required String collectionPath,
      required String sortedBy}) async {
    final subjectProblems = await firestoreServices.retrieveSolvedProblems(
        subject: subject,
        mainCollectionPath: mainCollectionPath,
        uid: uid,
        collectionPath: collectionPath,
        sortedBy: sortedBy) as List;
    return subjectProblems
        .map((docSnapshot) => SolvedProblems.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<void> submitSolution(
          {required SolvedProblems solution, required String path}) =>
      firestoreServices.setData(
        path: path,
        data: solution.toMap(),
      );
}
