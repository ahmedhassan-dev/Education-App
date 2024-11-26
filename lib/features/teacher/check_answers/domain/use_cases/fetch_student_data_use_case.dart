import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/features/authentication/data/models/student.dart';
import 'package:education_app/features/problems/data/repos/problems_repo.dart';

class FetchStudentDataUseCase {
  final ProblemsRepository problemsRepo;

  FetchStudentDataUseCase(this.problemsRepo);

  Future<Either<Failure, Student>> call({required String docName}) async {
    try {
      return right(await problemsRepo.retrieveStudentData(docName: docName));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
