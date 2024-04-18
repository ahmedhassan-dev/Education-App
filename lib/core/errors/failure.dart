abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
  factory ServerFailure.fromResponse() {
    return ServerFailure('There was an error , please try again');
  }
}
