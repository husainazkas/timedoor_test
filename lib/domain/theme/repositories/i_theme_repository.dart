abstract interface class IThemeRepository {
  Future<void> saveThemeMode(int themeMode);
  int? getThemeMode();
}
