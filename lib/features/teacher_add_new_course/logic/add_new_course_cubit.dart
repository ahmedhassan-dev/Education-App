import 'package:bloc/bloc.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:education_app/core/functions/service_locator.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher_add_new_course/data/repos/add_new_course_repo.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'add_new_course_state.dart';

class AddNewCourseCubit extends Cubit<AddNewCourseState> {
  String? userName;
  String? email;
  List<String>? subjects;
  AddNewCourseRepository addNewCourseRepository;
  AddNewCourseCubit(this.addNewCourseRepository) : super(Loading());

  Future<void> getTeacherDataFromSharedPreferences() async {
    userName = getIt<SharedPreferences>().getString('userName');
    email = getIt<SharedPreferences>().getString('email');
    subjects = getIt<SharedPreferences>().getStringList('subjects');

    emit(TeacherDataLoaded());
  }

  Future<void> saveNewCourse({required Courses course}) async {
    try {
      await addNewCourseRepository.storeNewCourse(
          path: ApiPath.coursesID(course.id!), data: course);
      emit(CourseDataStored());
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }
}
