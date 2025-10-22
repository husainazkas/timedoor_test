part of 'i_bookings_data_source.dart';

final class BookingsDataSourceImpl implements IBookingsDataSource {
  static const String _bookedSeatKey = 'booket_seat_key';

  @override
  Future<void> saveBookings(Map<String, Map<int, Set<int>>> data) {
    return Hive.lazyBox(IBookingsDataSource.boxName).put(_bookedSeatKey, data);
  }

  @override
  Future<Map<String, Map<int, Set<int>>>> getBookings() async {
    final data = await Hive.lazyBox(
      IBookingsDataSource.boxName,
    ).get(_bookedSeatKey);
    return data ?? const {};
  }
}
