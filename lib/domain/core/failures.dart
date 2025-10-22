sealed class Failure {
  final int? code;
  final String? message;

  const Failure({this.code, this.message});
}

final class ValidationFailure extends Failure {
  const ValidationFailure({super.code, super.message});
}

final class StorageFailure extends Failure {
  const StorageFailure({super.code, super.message});
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.code, super.message});
}
