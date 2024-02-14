import 'package:bloc/bloc.dart';
import 'package:education_app/data/repository/teacher_repo.dart';
import 'package:education_app/utilities/api_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  dynamic subjects = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> teacherData = {};
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
    } else {
      subjects.add(subject);
    }
    emit(SubjectEdited());
  }

  bool isSubjectAvailable({required String subject}) {
    return subjects.contains(subject);
  }

  Future<void> saveSubjects() async {
    emit(Loading());
    final teacherData = {"subjects": subjects};
    await teacherRepository.updateTeacherData(
      data: teacherData,
      path: ApiPath.teacher(uid),
    );
    // emit(TeacherDataUpdated());
  }

  bool get isSubjectsEmpty => subjects.isEmpty;
}
