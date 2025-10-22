import 'package:dartz/dartz.dart';

import '../../core/failures.dart';
import '../../core/usecase.dart';
import '../repositories/i_bookings_repository.dart';

final class SaveNewBookingsUseCase
    extends UseCase<Unit, Map<String, Map<int, Set<int>>>, StorageFailure> {
  final IBookingsRepository _bookingsRepository;

  SaveNewBookingsUseCase(this._bookingsRepository);

  @override
  Future<Either<StorageFailure, Unit>> call(
    Map<String, Map<int, Set<int>>> params,
  ) async {
    try {
      await _bookingsRepository.saveBookings(params);
    } catch (e) {
      return const Left(
        StorageFailure(message: 'Something error when saving new bookings'),
      );
    }

    return const Right(unit);
  }
}
