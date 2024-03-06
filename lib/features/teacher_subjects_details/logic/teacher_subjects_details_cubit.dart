import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'teacher_subjects_details_state.dart';

class TeacherSubjectsDetailsCubit extends Cubit<TeacherSubjectsDetailsState> {
  TeacherSubjectsDetailsCubit() : super(TeacherSubjectsDetailsInitial());
}
