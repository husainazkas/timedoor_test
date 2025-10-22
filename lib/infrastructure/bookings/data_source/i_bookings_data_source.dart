import 'package:hive_ce_flutter/hive_flutter.dart';

part 'bookings_local_data_source_impl.dart';

abstract interface class IBookingsDataSource {
  static const String boxName = 'bookings';

  Future<void> saveBookings(Map<String, Map<int, Set<int>>> data);
  Future<Map<String, Map<int, Set<int>>>> getBookings();
}
