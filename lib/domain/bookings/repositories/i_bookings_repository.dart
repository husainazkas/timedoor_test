abstract interface class IBookingsRepository {
  Future<void> saveBookings(Map<String, Map<int, Set<int>>> data);
  Future<Map<String, Map<int, Set<int>>>> getBookings();
}
