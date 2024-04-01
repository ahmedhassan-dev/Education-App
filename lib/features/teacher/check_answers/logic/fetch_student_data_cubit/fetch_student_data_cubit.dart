import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fetch_student_data_state.dart';

class FetchStudentDataCubit extends Cubit<FetchStudentDataState> {
  FetchStudentDataCubit() : super(FetchStudentDataInitial());
}
