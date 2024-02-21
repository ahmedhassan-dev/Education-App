import 'package:bloc/bloc.dart';
import 'package:education_app/features/courses/data/models/courses_model.dart';
import 'package:education_app/features/courses/data/repos/courses_repo.dart';
import 'package:education_app/core/constants/api_path.dart';

part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  List<CoursesModel> courses = [];
  CoursesRepository coursesRepository;
  CoursesCubit(this.coursesRepository) : super(CoursesInitial());

  List<CoursesModel> getAllCourses() {
    coursesRepository.getAllCourses(path: ApiPath.courses()).then((courses) {
      emit(CoursesLoaded(courses));
      this.courses = courses;
    });
    return courses;
  }
}
