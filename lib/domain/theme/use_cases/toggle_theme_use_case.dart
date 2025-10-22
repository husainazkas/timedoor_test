import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/failures.dart';
import '../../core/usecase.dart';
import '../repositories/i_theme_repository.dart';

final class ToggleThemeUseCase extends UseCase<ThemeMode, ThemeMode, StorageFailure> {
  final IThemeRepository _themeRepository;

  ToggleThemeUseCase(this._themeRepository);

  @override
  Future<Either<StorageFailure, ThemeMode>> call(ThemeMode params) async {
    try {
      await _themeRepository.saveThemeMode(params.index);
    } catch (e) {
      return const Left(
        StorageFailure(message: 'Something error when saving theme mode'),
      );
    }
    return right(params);
  }
}
