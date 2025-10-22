import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/failures.dart';
import '../../core/params.dart';
import '../../core/usecase.dart';
import '../repositories/i_theme_repository.dart';

final class GetCurrentThemeUseCase
    extends UseCaseSync<ThemeMode, NoParams, StorageFailure> {
  final IThemeRepository _themeRepository;

  GetCurrentThemeUseCase(this._themeRepository);

  @override
  Either<StorageFailure, ThemeMode> call(NoParams params) {
    return right(ThemeMode.values[_themeRepository.getThemeMode() ?? 0]);
  }
}
