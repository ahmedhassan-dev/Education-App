import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/data/models/problems.dart';
import 'package:education_app/data/models/solved_problems.dart';
import 'package:flutter/foundation.dart';

class FirestoreServices {
  FirestoreServices._();

  static final instance = FirestoreServices._();

  final _fireStore = FirebaseFirestore.instance;

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = _fireStore.doc(path);
    debugPrint('Request Data: $data');
    await reference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = _fireStore.doc(path);
    debugPrint('Path: $path');
    await reference.delete();
  }

  Future<List<Problems>> retrieveProblems(
      {required String subject,
      required String path,
      required String sortedBy}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(path)
        .where("topics", arrayContains: subject)
        .orderBy(sortedBy)
        .get();
    return snapshot.docs
        .map((docSnapshot) => Problems.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<SolvedProblems>> retrieveSolvedProblems(
      {required String subject,
      required String mainCollectionPath,
      required String uid,
      required String collectionPath,
      required String sortedBy}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(mainCollectionPath)
        .doc(uid)
        .collection(collectionPath)
        .where("topics", arrayContains: subject)
        .orderBy(sortedBy)
        .get();
    return snapshot.docs
        .map((docSnapshot) => SolvedProblems.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Stream<T> documentsStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId) builder,
  }) {
    final reference = _fireStore.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  Stream<List<T>> collectionsStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = _fireStore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map(
            (snapshot) => builder(
              snapshot.data() as Map<String, dynamic>,
              snapshot.id,
            ),
          )
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }
}
