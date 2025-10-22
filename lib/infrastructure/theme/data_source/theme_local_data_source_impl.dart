part of 'i_theme_data_source.dart';

final class ThemeDataSourceImpl implements IThemeDataSource {
  static const String _themeModeKey = 'theme_mode';

  @override
  Future<void> saveThemeMode(int themeMode) {
    return Hive.box(IThemeDataSource.boxName).put(_themeModeKey, themeMode);
  }

  @override
  int? getThemeMode() => Hive.box(IThemeDataSource.boxName).get(_themeModeKey);
}
