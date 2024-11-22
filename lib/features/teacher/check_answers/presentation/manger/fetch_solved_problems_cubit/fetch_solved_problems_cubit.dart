import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/use_cases/fetch_solved_problems_use_case.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fetch_problems_cubit/fetch_problems_cubit.dart';

part 'fetch_solved_problems_state.dart';

class FetchSolvedProblemsCubit extends Cubit<FetchSolvedProblemsState> {
  final FetchSolvedProblemsUseCase fetchSolvedProblemsUseCase;
  FetchSolvedProblemsCubit(this.fetchSolvedProblemsUseCase)
      : super(FetchSolvedProblemsInitial());
  late List<NeedReviewSolutionsEntity> needReviewSolutions;

  Future<void> fetchSolvedProblems(
      List<String> solutionsNeedingReview, BuildContext context) async {
    var result = await fetchSolvedProblemsUseCase.call(solutionsNeedingReview);
    result.fold((failure) {
      debugPrint(failure.message);
      emit(NeedReviewSolutionsFailure(errorMsg: failure.message));
    }, (needReviewSolutions) {
      this.needReviewSolutions = needReviewSolutions;
      showFirstProblem(context);
      emit(NeedReviewSolutionsLoaded(needReviewSolutions: needReviewSolutions));
    });
  }

  void showFirstProblem(BuildContext context) {
    context
        .read<FetchProblemsCubit>()
        .showCurrentProblem(needReviewSolutions.first.getProblemId());
  }
}
