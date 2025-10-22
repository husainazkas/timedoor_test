import '../../../domain/bookings/repositories/i_bookings_repository.dart';
import '../data_source/i_bookings_data_source.dart';

final class BookingsRepositoryImpl implements IBookingsRepository {
  final IBookingsDataSource _dataSource;

  const BookingsRepositoryImpl(this._dataSource);

  @override
  Future<void> saveBookings(Map<String, Map<int, Set<int>>> data) =>
      _dataSource.saveBookings(data);

  @override
  Future<Map<String, Map<int, Set<int>>>> getBookings() =>
      _dataSource.getBookings();
}
