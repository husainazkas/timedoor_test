import 'package:get_it/get_it.dart';

import 'domain/bookings/repositories/i_bookings_repository.dart';
import 'domain/bookings/use_cases/get_all_bookings_use_case.dart';
import 'domain/bookings/use_cases/reset_all_bookings_use_case.dart';
import 'domain/bookings/use_cases/save_new_bookings_use_case.dart';
import 'domain/theme/repositories/i_theme_repository.dart';
import 'domain/theme/use_cases/get_current_theme_use_case.dart';
import 'domain/theme/use_cases/toggle_theme_use_case.dart';
import 'infrastructure/bookings/data_source/i_bookings_data_source.dart';
import 'infrastructure/bookings/repositories/bookings_repository_impl.dart';
import 'infrastructure/theme/data_source/i_theme_data_source.dart';
import 'infrastructure/theme/repositories/theme_repository_impl.dart';

final sl = GetIt.instance;

void initDependencies() {
  sl.registerLazySingleton<IBookingsDataSource>(() => BookingsDataSourceImpl());
  sl.registerLazySingleton<IBookingsRepository>(
    () => BookingsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetAllBookingsUseCase(sl()));
  sl.registerLazySingleton(() => ResetAllBookingsUseCase(sl()));
  sl.registerLazySingleton(() => SaveNewBookingsUseCase(sl()));

  sl.registerLazySingleton<IThemeDataSource>(() => ThemeDataSourceImpl());
  sl.registerLazySingleton<IThemeRepository>(() => ThemeRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCurrentThemeUseCase(sl()));
  sl.registerLazySingleton(() => ToggleThemeUseCase(sl()));
}
