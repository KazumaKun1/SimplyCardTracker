import 'package:flutter/material.dart';
import 'package:simplycardtracker/core/extensions/formatting/currency_formatting.dart';
import 'package:simplycardtracker/features/card/debit/domain/entities/debit_card_entity.dart';

class DebitCard extends StatelessWidget {
  const DebitCard({super.key, required this.entity});

  final DebitCardEntity entity;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('Balance', style: textTheme.bodyLarge),
        FittedBox(
          fit: .scaleDown,
          child: Text(
            entity.currency.format(entity.currentAmountMinor),
            style: textTheme.displayMedium?.copyWith(fontWeight: .w600),
          ),
        ),
        if (entity.lastFourDigits case final lastFourDigits?
            when lastFourDigits.isNotEmpty)
          Text('•••• $lastFourDigits', style: textTheme.bodyLarge),
        if (entity.network case final network?) Text(network.label),
      ],
    );
  }
}
