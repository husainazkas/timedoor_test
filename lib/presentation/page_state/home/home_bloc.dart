import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' show mapEquals, setEquals;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/core/failures.dart';
import '../../routes/router.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
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

  void _onToggleTheme(ToggleTheme event, Emitter<HomeState> emit) {
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

  void _onBookTicket(BookTicket event, Emitter<HomeState> emit) {
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

    departDateController.clear();

    emit(
      state.copyWith(
        classType: () => null,
        selectedSeat: const {},
        bookedSeat: bookedSeat,
        totalPrice: 0,
        isLoading: false,
      ),
    );
  }

  void _onResetForm(ResetForm event, Emitter<HomeState> emit) {
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
  }
}
