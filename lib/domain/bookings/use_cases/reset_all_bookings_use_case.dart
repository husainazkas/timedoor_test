import 'package:dartz/dartz.dart';

import '../../core/failures.dart';
import '../../core/params.dart';
import '../../core/usecase.dart';
import '../repositories/i_bookings_repository.dart';

final class ResetAllBookingsUseCase
    extends UseCase<Unit, NoParams, StorageFailure> {
  final IBookingsRepository _bookingsRepository;

  ResetAllBookingsUseCase(this._bookingsRepository);

  @override
  Future<Either<StorageFailure, Unit>> call(NoParams params) async {
    try {
      await _bookingsRepository.saveBookings(const {});
    } catch (e) {
      return const Left(
        StorageFailure(message: 'Something error when saving new bookings'),
      );
    }

    return const Right(unit);
  }
}
