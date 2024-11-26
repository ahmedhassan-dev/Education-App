import 'package:bloc/bloc.dart';
import 'package:education_app/features/authentication/data/models/student.dart';
import 'package:education_app/features/teacher/check_answers/domain/use_cases/fetch_student_data_use_case.dart';
import 'package:flutter/foundation.dart';

part 'fetch_student_data_state.dart';

class FetchStudentDataCubit extends Cubit<FetchStudentDataState> {
  final FetchStudentDataUseCase fetchStudentDataUseCase;
  FetchStudentDataCubit(this.fetchStudentDataUseCase)
      : super(FetchStudentDataInitial());

  Future<void> fetchStudentData({required String docName}) async {
    var result = await fetchStudentDataUseCase.call(docName: docName);
    result.fold((failure) {
      debugPrint(failure.message);
      emit(StudentDataFailure(errorMsg: failure.message));
    }, (student) {
      emit(StudentDataLoaded(student: student));
    });
  }
}
