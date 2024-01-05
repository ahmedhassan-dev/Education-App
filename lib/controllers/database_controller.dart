import 'package:education_app/models/courses_model.dart';
import 'package:education_app/services/firestore_services.dart';
import 'package:education_app/utilities/api_path.dart';

abstract class Database {
  Stream<List<CoursesModel>> courseListStream();
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
}
