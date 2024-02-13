import 'package:bloc/bloc.dart';
import 'package:education_app/data/repository/teacher_repo.dart';
import 'package:education_app/utilities/api_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  dynamic subjects = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  dynamic teacherData = {};
  TeacherRepository teacherRepository;
  TeacherCubit(this.teacherRepository) : super(TeacherInitial());

  retrieveTeacherData() async {
    emit(Loading());
    await teacherRepository
        .retrieveTeacherData(path: ApiPath.teachersCollection(), docName: uid)
        .then((teacherData) {
      this.teacherData = teacherData.data()!;
    });
    initTeacherData();
  }

  initTeacherData() {
    subjects = teacherData["subjects"];
    emit(TeacherDataLoaded());
  }

  getSelectedSubject({required String subject}) {
    if (subjects.contains(subject)) {
      subjects.removeAt(subjects.indexOf(subject));
      emit(SubjectDelete());
    } else {
      subjects.add(subject);
      emit(SubjectAdded());
    }
    print("subjects: $subjects");
  }

  bool isSubjectAvailable({required String subject}) {
    return subjects.contains(subject);
  }

  bool get isSubjectsEmpty => subjects.isEmpty;
}
