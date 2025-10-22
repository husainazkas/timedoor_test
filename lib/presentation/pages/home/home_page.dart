import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../widgets/confirmation_book_dialog.dart';
import '../../widgets/dotted_seperator.dart';
import '../../widgets/dynamic_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                        const Column(
                          spacing: 4.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('Departure Date'),
                            ),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'dd/mm/yyyy',
                              ),
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
                            RadioGroup<int>(
                              onChanged: (value) {},
                              child: Row(
                                children:
                                    {1: 'Regular Class', 2: 'Express Class'}
                                        .entries
                                        .map(
                                          (e) => _HorizontalRadioItem(
                                            value: e.key,
                                            label: e.value,
                                            onTap: () {},
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
                            child: const Icon(Symbols.search_hands_free),
                          ),
                        ),
                        _GridSeat(
                          corridorWidth: 40.0,
                          spacing: 8.0,
                          colCount: 4,
                          rowCount: 3,
                          seatWidth: 40.0,
                          seatHeight: 80.0,
                          disabledSeat: {1, 4, 8, 13},
                          selectedIndex: 5,
                          onSelected: (value) {},
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Total Price: Rp 170.000',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: kMinInteractiveDimension + 16.0),
              ],
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: PopupMenuButton<int>(
                onSelected: (value) => switch (value) {
                  0 => null,
                  _ => null,
                },
                itemBuilder: (context) => {0: 'Reset All Seat'}.entries
                    .map(
                      (e) => PopupMenuItem(value: e.key, child: Text(e.value)),
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
      floatingActionButton: SizedBox(
        width: double.infinity,
        height: kMinInteractiveDimension,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorScheme.of(context).primary,
              foregroundColor: ColorScheme.of(context).onPrimary,
            ),
            onPressed: () => showConfirmationBookDialog(context),
            child: const Text('Book Now'),
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
    this.selectedIndex,
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
  final int? selectedIndex;
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
                    color: disabledSeat.any((e) => e == index)
                        ? ColorScheme.of(context).secondary
                        : selectedIndex == index
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
                            color: disabledSeat.any((e) => e == index)
                                ? ColorScheme.of(context).onSecondary
                                : selectedIndex == index
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
                    color: disabledSeat.any((e) => e == index)
                        ? ColorScheme.of(context).secondary
                        : selectedIndex == index
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
                            color: disabledSeat.any((e) => e == index)
                                ? ColorScheme.of(context).onSecondary
                                : selectedIndex == index
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
