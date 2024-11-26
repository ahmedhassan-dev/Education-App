import 'package:bloc/bloc.dart';
import 'package:education_app/core/functions/service_locator.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/features/teacher/add_new_problem/data/repos/add_new_problem_repo.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'add_new_problem_state.dart';

class AddNewProblemCubit extends Cubit<AddNewProblemState> {
  List<String> subjects = [];
  List<String> educationalStages = [];
  int newProblemId = 0;
  late String userName;
  late String email;
  Map<String, dynamic> teacherData = {};
  AddNewProblemRepository teacherRepository;
  AddNewProblemCubit(this.teacherRepository) : super(TeacherInitial());

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
      newProblemId = lastProblemId.data()!["problemsCount"] + 1;
    });
  }

  Future<void> updateProblemsCount() async {
    final problemsCount = {"problemsCount": newProblemId};
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
    userName = getIt<SharedPreferences>().getString('userName')!;
    email = getIt<SharedPreferences>().getString('email')!;
    emit(UserDataRetrieved());
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
}
