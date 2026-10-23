import 'package:flutter/material.dart';

class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Card ${index + 1} of $count',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: .circle,
                color: i == index
                    ? scheme.onSurface
                    : scheme.onSurfaceVariant.withValues(alpha: 0.35),
              ),
            ),
        ],
      ),
    );
  }
}
