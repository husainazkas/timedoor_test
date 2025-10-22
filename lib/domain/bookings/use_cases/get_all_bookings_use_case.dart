import 'package:dartz/dartz.dart';

import '../../core/failures.dart';
import '../../core/params.dart';
import '../../core/usecase.dart';
import '../repositories/i_bookings_repository.dart';

final class GetAllBookingsUseCase
    extends UseCase<Map<String, Map<int, Set<int>>>, NoParams, StorageFailure> {
  final IBookingsRepository _bookingsRepository;

  GetAllBookingsUseCase(this._bookingsRepository);

  @override
  Future<Either<StorageFailure, Map<String, Map<int, Set<int>>>>> call(
    NoParams params,
  ) async {
    try {
      final result = await _bookingsRepository.getBookings();
      return right(result);
    } catch (e) {
      return left(StorageFailure(message: e.toString()));
    }
  }
}
