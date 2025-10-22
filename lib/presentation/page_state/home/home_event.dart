part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

final class ReadSavedData extends HomeEvent {
  const ReadSavedData();
}

final class ToggleTheme extends HomeEvent {
  const ToggleTheme();
}

final class SetDepartureDate extends HomeEvent {
  final String value;

  const SetDepartureDate(this.value);
}

final class SelectClassType extends HomeEvent {
  final ClassType type;

  const SelectClassType(this.type);
}

final class SelectSeat extends HomeEvent {
  final int index;

  const SelectSeat(this.index);
}

final class BookTicket extends HomeEvent {
  const BookTicket();
}

final class ResetForm extends HomeEvent {
  const ResetForm();
}
