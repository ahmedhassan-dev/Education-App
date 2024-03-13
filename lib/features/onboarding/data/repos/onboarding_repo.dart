import 'package:education_app/core/services/firestore_services.dart';
import 'package:education_app/features/onboarding/data/models/publicinfo.dart';

class OnBoardingRepository {
  FirestoreServices firestoreServices;
  OnBoardingRepository(this.firestoreServices);

  Future<PublicInfo> getPublicInfo(
      {required String path, required String docName}) async {
    dynamic publicInfo = await firestoreServices.retrieveDataFormDocument(
        path: path, docName: docName);
    return PublicInfo.fromJson(publicInfo.data()!);
  }
}
