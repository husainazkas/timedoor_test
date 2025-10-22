import 'package:flutter/material.dart';

class DynamicContainer extends StatelessWidget {
  const DynamicContainer({
    super.key,
    this.padding = const EdgeInsets.all(16.0),
    this.child,
  });

  final EdgeInsetsGeometry padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surface,
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        boxShadow: Theme.brightnessOf(context) == Brightness.dark
            ? null
            : [
                BoxShadow(
                  color: ColorScheme.of(context).surfaceContainerHighest,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
        border: Theme.brightnessOf(context) == Brightness.dark
            ? Border.all(color: Theme.of(context).dividerColor)
            : null,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
