import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreServices {
  FirestoreServices();
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

  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = _fireStore.doc(path);
    await reference.update(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = _fireStore.doc(path);
    debugPrint('Path: $path');
    await reference.delete();
  }

  Future<dynamic> retrieveSortedData(
      {required String subject,
      required String path,
      required String sortedBy}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(path)
        .where("topics", arrayContains: subject)
        .orderBy(sortedBy)
        .get();
    return snapshot.docs;
  }

  Future<dynamic> retrieveData({
    required String path,
    Query Function(Query query)? queryBuilder,
  }) async {
    Query query = _fireStore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs;
  }

  Future<dynamic> retrieveDataFormDocument(
      {required String path, required String docName}) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _fireStore.collection(path).doc(docName).get();
    return snapshot;
  }

  Future<dynamic> retrieveSolvedProblems(
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
    return snapshot.docs;
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
