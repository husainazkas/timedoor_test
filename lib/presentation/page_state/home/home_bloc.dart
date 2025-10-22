import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' show mapEquals, setEquals;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bookings/use_cases/get_all_bookings_use_case.dart';
import '../../../domain/bookings/use_cases/reset_all_bookings_use_case.dart';
import '../../../domain/bookings/use_cases/save_new_bookings_use_case.dart';
import '../../../domain/core/failures.dart';
import '../../../domain/core/params.dart';
import '../../../domain/theme/use_cases/get_current_theme_use_case.dart';
import '../../../domain/theme/use_cases/toggle_theme_use_case.dart';
import '../../routes/router.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllBookingsUseCase _getAllBookingsUseCase;
  final ResetAllBookingsUseCase _resetAllBookingsUseCase;
  final SaveNewBookingsUseCase _saveNewBookingsUseCase;
  final GetCurrentThemeUseCase _getCurrentThemeUseCase;
  final ToggleThemeUseCase _toggleThemeUseCase;

  HomeBloc(
    this._getAllBookingsUseCase,
    this._resetAllBookingsUseCase,
    this._saveNewBookingsUseCase,
    this._getCurrentThemeUseCase,
    this._toggleThemeUseCase,
  ) : super(HomeState.initial()) {
    on<ReadSavedData>(_onReadSavedData);
    on<ToggleTheme>(_onToggleTheme);
    on<SetDepartureDate>(_onSetDepartureDate);
    on<SelectClassType>(_onSelectClassType);
    on<SelectSeat>(_onSelectSeat);
    on<BookTicket>(_onBookTicket);
    on<ResetForm>(_onResetForm);
  }

  final TextEditingController departDateController = TextEditingController();

  @override
  Future<void> close() {
    departDateController.dispose();
    return super.close();
  }

  Future<void> _onReadSavedData(
    ReadSavedData event,
    Emitter<HomeState> emit,
  ) async {
    final themeResult = _getCurrentThemeUseCase(const NoParams());
    emit(state.copyWith(themeMode: themeResult.fold((_) => null, id)));

    final bookingsResult = await _getAllBookingsUseCase(const NoParams());
    emit(
      state.copyWith(
        bookedSeat: bookingsResult.fold(
          (_) => null,
          (r) => r.map(
            (k, v) =>
                MapEntry(k, v.map((k, v) => MapEntry(ClassType.values[k], v))),
          ),
        ),
      ),
    );
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<HomeState> emit,
  ) async {
    final themeMode = switch (state.themeMode) {
      // Retrieve context from navKey
      ThemeMode.system => switch (Theme.brightnessOf(navKey.currentContext!)) {
        Brightness.light => ThemeMode.dark,
        Brightness.dark => ThemeMode.light,
      },
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
    };
    emit(state.copyWith(themeMode: themeMode));

    // emit before save to ignore any error when saving
    await _toggleThemeUseCase(themeMode);
  }

  void _onSetDepartureDate(SetDepartureDate event, Emitter<HomeState> emit) {
    // Should modify [isLoading] to trigger UI update because [departDateController.text] is not managed by bloc
    emit(
      state.copyWith(isLoading: true, bookFailureOrSuccessOption: const None()),
    );
    departDateController.text = event.value;
    emit(state.copyWith(isLoading: false));
  }

  void _onSelectClassType(SelectClassType event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        classType: () => event.type,
        selectedSeat: const {},
        totalPrice: 0,
      ),
    );
  }

  void _onSelectSeat(SelectSeat event, Emitter<HomeState> emit) {
    if (state.bookedSeat[departDateController.text]?[state.classType!]
            ?.contains(event.index) ??
        false) {
      return;
    }

    final selectedSeat = {...state.selectedSeat};
    if (!selectedSeat.remove(event.index)) {
      selectedSeat.add(event.index);
    }
    emit(
      state.copyWith(
        selectedSeat: selectedSeat,
        totalPrice:
            selectedSeat.length *
            switch (state.classType!) {
              ClassType.regular => 85000,
              ClassType.express => 150000,
            },
        bookFailureOrSuccessOption: const None(),
      ),
    );
  }

  Future<void> _onBookTicket(BookTicket event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));

    if (departDateController.text.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          bookFailureOrSuccessOption: const Some(
            Left(ValidationFailure(message: 'Departure Date should be filled')),
          ),
        ),
      );
      return;
    }

    final bookedSeat = {...state.bookedSeat}
      ..putIfAbsent(departDateController.text, () => {});
    bookedSeat[departDateController.text]!
      ..putIfAbsent(state.classType!, () => {})
      ..[state.classType!]!.addAll(state.selectedSeat);

    final result = await _saveNewBookingsUseCase(
      bookedSeat.map(
        (k, v) => MapEntry(k, v.map((k, v) => MapEntry(k.index, v))),
      ),
    );

    if (result.isRight()) {
      departDateController.clear();
      emit(
        state.copyWith(
          classType: () => null,
          selectedSeat: const {},
          bookedSeat: bookedSeat,
          totalPrice: 0,
        ),
      );
    }

    emit(
      state.copyWith(
        isLoading: false,
        bookFailureOrSuccessOption: optionOf(result),
      ),
    );
  }

  Future<void> _onResetForm(ResetForm event, Emitter<HomeState> emit) async {
    final result = await _resetAllBookingsUseCase(const NoParams());
    result.fold((l) => debugPrint(l.message), (r) {
      departDateController.clear();
      emit(
        state.copyWith(
          classType: () => null,
          selectedSeat: const {},
          bookedSeat: const {},
          totalPrice: 0,
          isLoading: false,
          bookFailureOrSuccessOption: const None(),
        ),
      );
    });
  }
}
