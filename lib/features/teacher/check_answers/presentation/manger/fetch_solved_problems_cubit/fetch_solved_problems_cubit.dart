import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fetch_solved_problems_state.dart';

class FetchSolvedProblemsCubit extends Cubit<FetchSolvedProblemsState> {
  FetchSolvedProblemsCubit() : super(FetchSolvedProblemsInitial());
}
