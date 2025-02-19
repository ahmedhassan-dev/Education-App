import 'package:bloc/bloc.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/courses/data/repos/courses_repo.dart';
part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  List<Courses> courses = [];
  CoursesRepository coursesRepository;
  CoursesCubit(this.coursesRepository) : super(CoursesInitial());

  Future<List<Courses>> getAllCourses() async {
    await coursesRepository.getAllCourses().then((courses) {
      emit(CoursesLoaded(courses));
      this.courses = courses;
    });
    return courses;
  }
}
