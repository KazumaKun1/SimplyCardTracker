import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: shell,
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      bottomNavigationBar: _PillTabBar(
        currentIndex: shell.currentIndex,
        onTap: shell.goBranch,
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.icon, this.label);
  final IconData icon;
  final String label;
}

const _items = [
  _TabSpec(Icons.account_balance_wallet_outlined, 'Debit'),
  _TabSpec(Icons.credit_card, 'Credit'),
  _TabSpec(Icons.settings_outlined, 'Settings'),
];

class _PillTabBar extends StatelessWidget {
  const _PillTabBar({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const .fromLTRB(48, 0, 48, 0),
        child: Container(
          height: 64,
          decoration: ShapeDecoration(
            color: scheme.surfaceContainer,
            shape: StadiumBorder(
              side: BorderSide(color: scheme.outlineVariant, width: 1),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.18),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _SlidingHighlight(currentIndex: currentIndex),
              Row(
                children: [
                  for (final (index, spec) in _items.indexed)
                    Expanded(
                      child: _TabItem(
                        spec: spec,
                        selected: index == currentIndex,
                        onTap: () => onTap(index),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlidingHighlight extends StatelessWidget {
  const _SlidingHighlight({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      alignment: Alignment(-1 + 2 * currentIndex / (_items.length - 1), 0),
      child: FractionallySizedBox(
        widthFactor: 1 / _items.length,
        heightFactor: 1,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: scheme.surfaceContainerHighest,
              shape: const StadiumBorder(),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  final _TabSpec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : scheme.onSurface;

    return Semantics(
      button: true,
      selected: selected,
      label: spec.label,
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(spec.icon, color: color),
              Text(spec.label, style: TextStyle(color: color, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
