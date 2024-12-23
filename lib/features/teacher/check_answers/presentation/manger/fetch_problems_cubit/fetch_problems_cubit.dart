import 'package:bloc/bloc.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/use_cases/fetch_problems_use_case.dart';
import 'package:flutter/foundation.dart';

part 'fetch_problems_state.dart';

class FetchProblemsCubit extends Cubit<FetchProblemsState> {
  final FetchProblemsUseCase fetchProblemsUseCase;
  FetchProblemsCubit(this.fetchProblemsUseCase) : super(FetchProblemsLoading());

  late final List<ProblemsEntity> needReviewProblems;

  Future<void> fetchProblems(List<int> solutionsNeedingReview) async {
    var result = await fetchProblemsUseCase.call(solutionsNeedingReview);
    result.fold((failure) {
      debugPrint(failure.message);
      emit(NeedReviewProblemsFailure(errorMsg: failure.message));
    }, (needReviewProblems) {
      this.needReviewProblems = needReviewProblems;
      emit(NeedReviewProblemsLoaded(needReviewProblems: needReviewProblems));
    });
  }

  late ProblemsEntity currentProblem;
  void showCurrentProblem(int problemId) {
    emit(FetchProblemsLoading());
    currentProblem =
        needReviewProblems.firstWhere((e) => e.globalProblemId == problemId);
    emit(ShowCurrentProblem(problem: currentProblem));
  }
}
