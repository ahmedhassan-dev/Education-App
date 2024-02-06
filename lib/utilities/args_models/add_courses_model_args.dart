import 'package:education_app/controllers/database_controller.dart';
import 'package:education_app/data/models/courses_model.dart';

class AddCoursesModelArgs {
  final Database database;
  final CoursesModel? courseList;

  AddCoursesModelArgs({required this.database, this.courseList});
}
