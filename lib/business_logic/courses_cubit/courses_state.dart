part of 'courses_cubit.dart';

sealed class CoursesState {}

final class CoursesInitial extends CoursesState {}

class CoursesLoaded extends CoursesState {
  final List<CoursesModel> courses;

  CoursesLoaded(this.courses);
}