import 'package:bloc/bloc.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'add_new_course_state.dart';

class AddNewCourseCubit extends Cubit<AddNewCourseState> {
  String? userName;
  String? email;
  AddNewCourseCubit() : super(Loading());

  Future<void> getTeacherDataFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      userName = prefs.getString('userName');
      email = prefs.getString('email');
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
    emit(TeacherDataLoaded());
  }

  saveNewCourse({required Courses course}) {
    try {
      // TODO: Sending data
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
    emit(CourseDataStored());
  }
}
