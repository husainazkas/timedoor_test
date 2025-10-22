part of 'home_bloc.dart';

final class HomeState {
  final ThemeMode themeMode;
  final ClassType? classType;
  final Set<int> selectedSeat;
  final Map<String, Map<ClassType, Set<int>>> bookedSeat;
  final int totalPrice;

  final bool isLoading;
  final Option<Either<Failure, Unit>> bookFailureOrSuccessOption;

  const HomeState._({
    required this.themeMode,
    required this.classType,
    required this.selectedSeat,
    required this.bookedSeat,
    required this.totalPrice,
    required this.isLoading,
    required this.bookFailureOrSuccessOption,
  });

  factory HomeState.initial() => const HomeState._(
    themeMode: ThemeMode.system,
    classType: null,
    selectedSeat: {},
    bookedSeat: {},
    totalPrice: 0,
    isLoading: false,
    bookFailureOrSuccessOption: None(),
  );

  HomeState copyWith({
    ThemeMode? themeMode,
    ValueGetter<ClassType?>? classType,
    Set<int>? selectedSeat,
    Map<String, Map<ClassType, Set<int>>>? bookedSeat,
    int? totalPrice,
    bool? isLoading,
    Option<Either<Failure, Unit>>? bookFailureOrSuccessOption,
  }) {
    return HomeState._(
      themeMode: themeMode ?? this.themeMode,
      classType: classType != null ? classType() : this.classType,
      selectedSeat: selectedSeat ?? this.selectedSeat,
      bookedSeat: bookedSeat ?? this.bookedSeat,
      totalPrice: totalPrice ?? this.totalPrice,
      isLoading: isLoading ?? this.isLoading,
      bookFailureOrSuccessOption:
          bookFailureOrSuccessOption ?? this.bookFailureOrSuccessOption,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeState &&
        other.themeMode == themeMode &&
        other.classType == classType &&
        setEquals(other.selectedSeat, selectedSeat) &&
        mapEquals(other.bookedSeat, bookedSeat) &&
        other.totalPrice == totalPrice &&
        other.isLoading == isLoading &&
        other.bookFailureOrSuccessOption == bookFailureOrSuccessOption;
  }

  @override
  int get hashCode {
    return themeMode.hashCode ^
        classType.hashCode ^
        selectedSeat.hashCode ^
        bookedSeat.hashCode ^
        totalPrice.hashCode ^
        isLoading.hashCode ^
        bookFailureOrSuccessOption.hashCode;
  }

  @override
  String toString() {
    return 'HomeState(themeMode: $themeMode, classType: $classType, selectedSeat: $selectedSeat, bookedSeat: $bookedSeat, totalPrice: $totalPrice, isLoading: $isLoading, bookFailureOrSuccessOption: $bookFailureOrSuccessOption)';
  }
}

enum ClassType {
  regular('Regular Class'),
  express('Express Class');

  const ClassType(this.label);

  final String label;
}
