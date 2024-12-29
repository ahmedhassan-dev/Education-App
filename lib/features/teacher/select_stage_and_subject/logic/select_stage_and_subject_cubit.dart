import 'package:bloc/bloc.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:education_app/core/functions/service_locator.dart';
import 'package:education_app/features/teacher/select_stage_and_subject/data/repos/select_stage_and_subject_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'select_stage_and_subject_state.dart';

class SelectStageAndSubjectCubit extends Cubit<SelectStageAndSubjectState> {
  List<String> subjects = [];
  List<String> educationalStages = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> teacherData = {};
  SelectStageAndSubjectRepository selectStageAndSubjectRepository;
  SelectStageAndSubjectCubit(this.selectStageAndSubjectRepository)
      : super(SelectStageAndSubjectInitial());

  final SharedPreferences _prefs = getIt<SharedPreferences>();

  retrieveTeacherData() async {
    emit(Loading());
    await selectStageAndSubjectRepository
        .retrieveTeacherData(path: ApiPath.teachersCollection(), docName: uid)
        .then((teacherData) {
      teacherData.data() == null
          ? emit(UserIsNotTeacher())
          : initTeacherData(teacherData.data());
    });
  }

  initTeacherData(Map<String, dynamic> teacherData) {
    this.teacherData = teacherData;
    var dynamicSubjects = teacherData["subjects"];
    var dynamicEducationalStages = teacherData["educationalStages"];
    subjects = List<String>.from(dynamicSubjects);
    educationalStages = List<String>.from(dynamicEducationalStages);
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

  getSelectedEducationalStages({required String stage}) {
    if (educationalStages.contains(stage)) {
      educationalStages.removeAt(educationalStages.indexOf(stage));
    } else {
      educationalStages.add(stage);
    }
    emit(SubjectEdited());
  }

  bool isSubjectAvailable({required String subject}) {
    return subjects.contains(subject);
  }

  bool isEducationalStageAvailable({required String stage}) {
    return educationalStages.contains(stage);
  }

  Future<void> saveEducationalStages() async {
    emit(Loading());
    final teacherData = {"educationalStages": educationalStages};
    await selectStageAndSubjectRepository.updateTeacherData(
      data: teacherData,
      path: ApiPath.teacher(uid),
    );
    await storeEducationalStagesInSharedPreferences();
    emit(EducationalStagesSaved());
  }

  storeEducationalStagesInSharedPreferences() async {
    await _prefs.setStringList('educationalStages', educationalStages);
  }

  Future<void> saveSubjects() async {
    emit(Loading());
    final teacherData = {
      "subjects": subjects,
    };
    await selectStageAndSubjectRepository.updateTeacherData(
      data: teacherData,
      path: ApiPath.teacher(uid),
    );
    await storeSubjectsInSharedPreferences();
    emit(SubjectsSaved());
  }

  storeSubjectsInSharedPreferences() async {
    await _prefs.setStringList('subjects', subjects);
  }
}
