import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../page_state/home/home_bloc.dart';
import '../../widgets/confirmation_book_dialog.dart';
import '../../widgets/dotted_seperator.dart';
import '../../widgets/dynamic_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy');
    final nf = NumberFormat();

    return Scaffold(
      body: SingleChildScrollView(
        padding: MediaQuery.viewPaddingOf(context),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16.0,
                    64.0,
                    8.0 + kMinInteractiveDimension,
                    16.0,
                  ),
                  child: Text(
                    'Book Your Travel Tickets Easily and With The Best Service!',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DynamicContainer(
                    child: Column(
                      spacing: 16.0,
                      children: [
                        Column(
                          spacing: 4.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('Departure Date'),
                            ),
                            TextField(
                              controller: context
                                  .read<HomeBloc>()
                                  .departDateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: 'dd/mm/yyyy',
                              ),
                              onTap: () async {
                                final now = DateTime.now();
                                final date = await showDatePicker(
                                  context: context,
                                  firstDate: now,
                                  lastDate: now.add(
                                    const Duration(days: 30 * 3),
                                  ),
                                  currentDate: switch (context
                                      .read<HomeBloc>()
                                      .departDateController
                                      .text) {
                                    '' => null,
                                    final currDate => df.parse(currDate),
                                  },
                                );

                                if (date != null && context.mounted) {
                                  context.read<HomeBloc>().add(
                                    SetDepartureDate(df.format(date)),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          spacing: 4.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('Class Type'),
                            ),
                            BlocBuilder<HomeBloc, HomeState>(
                              buildWhen: (p, c) => p.classType != c.classType,
                              builder: (context, state) =>
                                  RadioGroup<ClassType>(
                                    groupValue: state.classType,
                                    onChanged: (value) => context
                                        .read<HomeBloc>()
                                        .add(SelectClassType(value!)),
                                    child: Row(
                                      children: ClassType.values
                                          .map(
                                            (e) => _HorizontalRadioItem(
                                              value: e,
                                              label: e.label,
                                              onTap: () => context
                                                  .read<HomeBloc>()
                                                  .add(SelectClassType(e)),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (p, c) =>
                      p.classType == null || c.classType == null,
                  builder: (context, state) {
                    if (state.classType == null) return const SizedBox.shrink();
                    return Column(
                      children: [
                        const SizedBox(height: 32.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: DottedSeparator(
                            height: 1.5,
                            color: Theme.of(context).dividerColor,
                            // color: ColorScheme.of(
                            //   context,
                            // ).inverseSurface.withAlpha(255 * 1 ~/ 3),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DynamicContainer(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              spacing: 8.0,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox.square(
                                  dimension: 40.0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: const Icon(
                                      Symbols.search_hands_free,
                                    ),
                                  ),
                                ),
                                BlocBuilder<HomeBloc, HomeState>(
                                  buildWhen: (p, c) =>
                                      p.classType != c.classType ||
                                      p.bookedSeat != c.bookedSeat ||
                                      p.selectedSeat != c.selectedSeat ||
                                      p.isLoading != c.isLoading,
                                  builder: (context, state) => _GridSeat(
                                    corridorWidth: 40.0,
                                    spacing: 8.0,
                                    colCount: 4,
                                    rowCount: switch (state.classType!) {
                                      ClassType.regular => 5,
                                      ClassType.express => 3,
                                    },
                                    seatWidth: 40.0,
                                    seatHeight: switch (state.classType!) {
                                      ClassType.regular => 40.0,
                                      ClassType.express => 80.0,
                                    },
                                    disabledSeat:
                                        state.bookedSeat[context
                                            .read<HomeBloc>()
                                            .departDateController
                                            .text]?[state.classType!] ??
                                        const {},
                                    selectedSeat: state.selectedSeat,
                                    onSelected: (value) => context
                                        .read<HomeBloc>()
                                        .add(SelectSeat(value)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: BlocBuilder<HomeBloc, HomeState>(
                                    buildWhen: (p, c) =>
                                        p.totalPrice != c.totalPrice,
                                    builder: (context, state) => Text(
                                      'Total Price: Rp ${nf.format(state.totalPrice)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BlocBuilder<HomeBloc, HomeState>(
                          buildWhen: (p, c) =>
                              p.selectedSeat.isEmpty || c.selectedSeat.isEmpty,
                          builder: (context, state) => SizedBox(
                            height:
                                24.0 +
                                (state.selectedSeat.isEmpty
                                    ? 0.0
                                    : kMinInteractiveDimension),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: PopupMenuButton<int>(
                onSelected: (value) => switch (value) {
                  0 => context.read<HomeBloc>().add(const ToggleTheme()),
                  1 => context.read<HomeBloc>().add(const ResetForm()),
                  _ => null,
                },
                itemBuilder: (context) =>
                    {0: 'Toggle Theme', 1: 'Reset All Seat'}.entries
                        .map(
                          (e) =>
                              PopupMenuItem(value: e.key, child: Text(e.value)),
                        )
                        .toList(),
                icon: const Icon(Icons.menu_open),
                position: PopupMenuPosition.under,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.widthOf(context) / 2,
                  minWidth: kToolbarHeight + 100,
                ),
                padding: const EdgeInsets.all(16.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (p, c) => p.isLoading != c.isLoading,
        listener: (context, state) {
          if (state.isLoading) return;
          state.bookFailureOrSuccessOption.fold(
            () {},
            (a) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: a.fold(
                  (_) => ColorScheme.of(context).error,
                  (_) => null,
                ),
                content: Text(
                  a.fold(
                    (l) => l.message ?? 'Unknown error occurred',
                    (r) => 'Booking has been placed',
                  ),
                ),
              ),
            ),
          );
        },
        buildWhen: (p, c) => p.selectedSeat.isEmpty || c.selectedSeat.isEmpty,
        builder: (context, state) => state.selectedSeat.isEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                width: double.infinity,
                height: kMinInteractiveDimension,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorScheme.of(context).primary,
                      foregroundColor: ColorScheme.of(context).onPrimary,
                    ),
                    onPressed: () =>
                        showConfirmationBookDialog(context).then((isOk) {
                          if (isOk == true && context.mounted) {
                            context.read<HomeBloc>().add(const BookTicket());
                          }
                        }),
                    child: const Text('Book Now'),
                  ),
                ),
              ),
      ),
    );
  }
}

class _HorizontalRadioItem<T> extends StatelessWidget {
  final T value;
  final String label;
  final VoidCallback? onTap;

  const _HorizontalRadioItem({
    super.key,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(value: value),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(label),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridSeat extends StatelessWidget {
  const _GridSeat({
    required this.corridorWidth,
    required this.spacing,
    required this.colCount,
    required this.rowCount,
    required this.seatWidth,
    required this.seatHeight,
    this.disabledSeat = const {},
    this.selectedSeat = const {},
    this.onSelected,
  }) : assert(
         colCount % 2 == 0,
         'Currently only support even numbers of column seat',
       );

  final double corridorWidth;
  final double spacing;
  final int colCount;
  final int rowCount;
  final double seatWidth;
  final double seatHeight;

  final Set<int> disabledSeat;
  final Set<int> selectedSeat;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: spacing,
      children: List.generate(
        rowCount,
        (rowIndex) => Row(
          spacing: corridorWidth,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: spacing,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(colCount ~/ 2, (leftColIndex) {
                final index = getIndex(rowIndex, leftColIndex);
                return SizedBox(
                  width: seatWidth,
                  height: seatHeight,
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    color: disabledSeat.contains(index)
                        ? ColorScheme.of(context).secondary
                        : selectedSeat.contains(index)
                        ? ColorScheme.of(context).primary
                        : ColorScheme.of(context).surfaceContainerHighest,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    child: InkWell(
                      onTap: onSelected == null
                          ? null
                          : () => onSelected!(index),
                      child: Center(
                        child: Text(
                          '${getRowLabel(rowIndex)}${leftColIndex + 1}',
                          style: TextStyle(
                            color: disabledSeat.contains(index)
                                ? ColorScheme.of(context).onSecondary
                                : selectedSeat.contains(index)
                                ? ColorScheme.of(context).onPrimary
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            Row(
              spacing: spacing,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(colCount ~/ 2, (rightColIndex) {
                final index = getIndex(rowIndex, rightColIndex, true);
                return SizedBox(
                  width: seatWidth,
                  height: seatHeight,
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    color: disabledSeat.contains(index)
                        ? ColorScheme.of(context).secondary
                        : selectedSeat.contains(index)
                        ? ColorScheme.of(context).primary
                        : ColorScheme.of(context).surfaceContainerHighest,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    child: InkWell(
                      onTap: onSelected == null
                          ? null
                          : () => onSelected!(index),
                      child: Center(
                        child: Text(
                          '${getRowLabel(rowIndex)}${rightColIndex + colCount ~/ 2 + 1}',
                          style: TextStyle(
                            color: disabledSeat.contains(index)
                                ? ColorScheme.of(context).onSecondary
                                : selectedSeat.contains(index)
                                ? ColorScheme.of(context).onPrimary
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String getRowLabel(int index) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var label = '';

    while (index >= 0) {
      final remainder = index % letters.length;
      label = letters[remainder] + label;
      index = (index ~/ 26) - 1;
    }

    return label;
  }

  int getIndex(int rowIndex, int colIndex, [bool isRight = false]) {
    final index = rowIndex * colCount + colIndex;
    if (isRight) return index + colCount ~/ 2;
    return index;
  }
}
