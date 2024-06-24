import 'package:bloc/bloc.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/use_cases/fetch_solved_problems_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'fetch_solved_problems_state.dart';

class FetchSolvedProblemsCubit extends Cubit<FetchSolvedProblemsState> {
  final FetchSolvedProblemsUseCase fetchSolvedProblemsUseCase;
  FetchSolvedProblemsCubit(this.fetchSolvedProblemsUseCase)
      : super(FetchSolvedProblemsInitial());

  Future<void> fetchSolvedProblems(List<String> needReviewSolutionsList) async {
    var result = await fetchSolvedProblemsUseCase.call(needReviewSolutionsList);
    result.fold((failure) {
      debugPrint(failure.message);
      emit(NeedReviewSolutionsFailure(errorMsg: failure.message));
    }, (needReviewSolutions) {
      emit(NeedReviewSolutionsLoaded(needReviewSolutions: needReviewSolutions));
    });
  }
}
