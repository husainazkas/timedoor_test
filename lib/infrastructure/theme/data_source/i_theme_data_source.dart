import 'package:hive_ce_flutter/hive_flutter.dart';

part 'theme_local_data_source_impl.dart';

abstract interface class IThemeDataSource {
  static const String boxName = 'theme';

  Future<void> saveThemeMode(int themeMode);
  int? getThemeMode();
}
