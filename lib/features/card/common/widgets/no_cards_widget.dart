import 'package:flutter/material.dart';

class NoCardsWidget extends StatelessWidget {
  const NoCardsWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    return Padding(
      padding: const .symmetric(horizontal: 24, vertical: 16),
      child: Text(
        text,
        style: textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        textAlign: .center,
      ),
    );
  }
}
