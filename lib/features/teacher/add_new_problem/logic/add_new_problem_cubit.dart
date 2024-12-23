import 'package:bloc/bloc.dart';
import 'package:education_app/core/functions/service_locator.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/features/teacher/add_new_problem/data/repos/add_new_problem_repo.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../courses/data/repos/courses_repo.dart';

part 'add_new_problem_state.dart';

class AddNewProblemCubit extends Cubit<AddNewProblemState> {
  List<String> subjects = [];
  List<String> educationalStages = [];
  int newGlobalProblemId = 0;
  int newProblemId = 0;
  late String userName;
  late String email;
  Map<String, dynamic> teacherData = {};
  AddNewProblemRepository teacherRepository;
  AddNewProblemCubit(this.teacherRepository) : super(TeacherInitial());

  Future<void> storeNewProblem(Problems problem) async {
    await teacherRepository.storeNewProblem(
      path: ApiPath.storingProblem(problem.globalProblemId),
      data: problem,
    );
  }

  Future<void> saveNewProblem({required Problems problem}) async {
    emit(Loading());
    await generateGlobalProblemId();
    await generateProblemId(problem.courseId!);
    problem = problem.copyWith(
        globalProblemId: newGlobalProblemId, problemId: newProblemId);
    await storeNewProblem(problem);
    emit(ProblemStored());
  }

  Future<void> generateGlobalProblemId() async {
    try {
      await teacherRepository.incrementProblemsCount();
      await teacherRepository.retrieveLastProblemId().then((lastProblemId) {
        newGlobalProblemId = lastProblemId.data()!["problemsCount"];
      });
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  Future<void> generateProblemId(String courseId) async {
    CoursesRepository coursesRepository = getIt<CoursesRepository>();
    try {
      await coursesRepository.incrementProblemsCount(courseId);
      await coursesRepository
          .retrieveLastProblemId(courseId)
          .then((lastProblemId) {
        newProblemId = lastProblemId.data()!["problemsCount"];
      });
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
        .retrieveCourseProblems(path: ApiPath.problems(), courseId: course.id!)
        .then((problemsList) {
      emit(ModalBottomSheetProblemsLoaded(problemsList: problemsList));
    });
  }
}
