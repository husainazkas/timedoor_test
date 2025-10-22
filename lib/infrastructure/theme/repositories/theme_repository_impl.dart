import '../../../domain/theme/repositories/i_theme_repository.dart';
import '../data_source/i_theme_data_source.dart';

final class ThemeRepositoryImpl implements IThemeRepository {
  final IThemeDataSource _dataSource;

  const ThemeRepositoryImpl(this._dataSource);

  @override
  Future<void> saveThemeMode(int themeMode) =>
      _dataSource.saveThemeMode(themeMode);

  @override
  int? getThemeMode() => _dataSource.getThemeMode();
}
