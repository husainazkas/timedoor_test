import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<bool?> showConfirmationBookDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Confirm your booking'),
      contentPadding: const EdgeInsets.all(24.0),
      children: [
        const Text(
          'Make sure all your travel details are correct before continuing.',
        ),
        const SizedBox(height: 24.0),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: ColorScheme.of(context).primary,
            foregroundColor: ColorScheme.of(context).onPrimary,
          ),
          onPressed: () => context.pop(true),
          child: const Text('Continue'),
        ),
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
      ],
    ),
  );
}
