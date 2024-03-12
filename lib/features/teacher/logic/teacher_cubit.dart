import 'package:bloc/bloc.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/features/teacher/data/repos/teacher_repo.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:education_app/core/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  List<String> subjects = [];
  List<String> educationalStages = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String newProblemId = "0";
  late String userName;
  late String email;
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

  Future<void> saveSubjects() async {
    emit(Loading());
    final teacherData = {
      "subjects": subjects,
    };
    await teacherRepository.updateTeacherData(
      data: teacherData,
      path: ApiPath.teacher(uid),
    );
    await storeSubjectsInSharedPreferences();
    // emit(TeacherDataUpdated());
  }

  Future<void> saveEducationalStages() async {
    emit(Loading());
    final teacherData = {"educationalStages": educationalStages};
    await teacherRepository.updateTeacherData(
      data: teacherData,
      path: ApiPath.teacher(uid),
    );
    await storeEducationalStagesInSharedPreferences();
    // emit(TeacherDataUpdated());
  }

  storeSubjectsInSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('subjects', subjects);
  }

  storeEducationalStagesInSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('educationalStages', educationalStages);
  }

  Future<void> storeNewProblem(Problems problem) async {
    await teacherRepository.storeNewProblem(
      path: ApiPath.storingProblem(newProblemId),
      data: problem,
    );
  }

  Future<void> saveNewProblem({required Problems problem}) async {
    emit(Loading());
    await generateProblemId();
    problem = problem.copyWith(id: newProblemId);
    await storeNewProblem(problem);
    await updateProblemsCount();
    emit(ProblemStored());
  }

  Future<void> generateProblemId() async {
    await teacherRepository
        .retrieveLastProblemId(
            path: ApiPath.publicInfo(), docName: 'problemsCount')
        .then((lastProblemId) {
      newProblemId = (lastProblemId.data()!["problemsCount"] + 1).toString();
    });
  }

  Future<void> updateProblemsCount() async {
    final problemsCount = {"problemsCount": int.parse(newProblemId)};
    try {
      await teacherRepository.updateProblemsCount(
        data: problemsCount,
        path: ApiPath.problemsCount(),
      );
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  getTeacherDataFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName')!;
    email = prefs.getString('email')!;
    emit(UserDataRetrieved());
  }

  late String latestAppVersion;
  checkForUpdates() async {
    emit(Loading());
    await getLatestAppVersion();
    if (latestAppVersion != teacherVersion) {
      emit(NeedUpdate());
    } else {
      await getTeacherDataFromSharedPreferences();
    }
  }

  getLatestAppVersion() async {
    await teacherRepository
        .getLatestAppVersion(
            path: ApiPath.publicInfo(), docName: 'teacherVersion')
        .then((latestAppVersion) {
      this.latestAppVersion = latestAppVersion.data()!["teacherVersion"];
    });
  }

  Future<void> getCourseProblems(Courses course) async {
    emit(LoadingModalBottomSheetData());
    await teacherRepository
        .retrieveCourseProblems(
            path: ApiPath.problems(), courseId: course.id!, sortedBy: "id")
        .then((problemsList) {
      emit(ModalBottomSheetProblemsLoaded(problemsList: problemsList));
    });
  }

  bool get isSubjectsEmpty => subjects.isEmpty;
}
