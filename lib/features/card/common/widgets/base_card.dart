import 'package:flutter/material.dart';
import 'package:simplycardtracker/features/card/common/domain/entities/card_entity.dart';
import 'package:simplycardtracker/features/card/common/widgets/card_pattern_painter.dart';
import 'package:simplycardtracker/features/card/common/widgets/card_swatch.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    required this.entity,
    required this.footer,
    this.onTap,
  });

  final CardEntity entity;
  final Widget footer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final swatch = CardSwatch.fromKey(entity.colorKey);

    return _CardSurface(
      swatch: swatch,
      useGradient: false,
      onTap: onTap,
      child: _WhiteForeground(
        child: Column(
          spacing: 8,
          crossAxisAlignment: .start,
          children: [
            _CardType(type: entity.getCardType()),
            _CardHeader(
              bankName: entity.bankName,
              cardName: entity.cardName,
              tier: entity.tier,
            ),
            const Spacer(),
            footer,
          ],
        ),
      ),
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({
    required this.swatch,
    required this.useGradient,
    required this.onTap,
    required this.child,
  });

  final CardSwatch swatch;
  final bool useGradient;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fill = swatch.fill(theme.brightness);

    return Material(
      elevation: 10,
      shadowColor: isDark ? swatch.color.shade800 : Colors.black,
      color: fill,
      clipBehavior: .antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(20),
        side: isDark
            ? BorderSide(color: swatch.color.shade700, width: 1)
            : .none,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: useGradient
              ? LinearGradient(
                  begin: .topLeft,
                  end: .bottomRight,
                  colors: [swatch.color.shade800, swatch.color.shade900],
                )
              : null,
        ),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: .expand,
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: CardPatternPainter()),
              ),
              Padding(padding: const .all(24), child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _WhiteForeground extends StatelessWidget {
  const _WhiteForeground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTextTheme = theme.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );

    return Theme(
      data: theme.copyWith(
        textTheme: cardTextTheme,
        iconTheme: theme.iconTheme.copyWith(color: Colors.white),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Colors.white),
        child: child,
      ),
    );
  }
}

class _CardType extends StatelessWidget {
  const _CardType({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final cardTextTheme = Theme.of(context).textTheme;

    return Container(
      padding: const .all(6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: .circular(12.0),
      ),
      child: Text(
        type,
        style: cardTextTheme.labelLarge?.copyWith(fontWeight: .w600),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.bankName,
    required this.cardName,
    required this.tier,
  });

  final String? bankName;
  final String? cardName;
  final String? tier;

  @override
  Widget build(BuildContext context) {
    final cardTextTheme = Theme.of(context).textTheme;

    final isCardNameMissing = cardName == null || cardName!.isEmpty;

    final isTierMissing = tier == null || tier!.isEmpty;

    final tierStyle = isCardNameMissing
        ? cardTextTheme.displaySmall?.copyWith(fontWeight: .w600)
        : cardTextTheme.bodyMedium;

    final bankNameStyle = isCardNameMissing && isTierMissing
        ? cardTextTheme.displaySmall?.copyWith(fontWeight: .w600)
        : cardTextTheme.titleLarge;

    return Column(
      crossAxisAlignment: .start,
      children: [
        if (bankName case final bankName? when bankName.isNotEmpty)
          Text(bankName, style: bankNameStyle),
        if (cardName case final cardName? when cardName.isNotEmpty)
          Text(
            cardName,
            style: cardTextTheme.displaySmall?.copyWith(fontWeight: .bold),
          ),
        if (tier case final tier? when tier.isNotEmpty)
          Text(tier, style: tierStyle),
      ],
    );
  }
}
