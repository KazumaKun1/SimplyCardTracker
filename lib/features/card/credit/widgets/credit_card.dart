import 'package:flutter/material.dart';
import 'package:simplycardtracker/core/extensions/formatting/currency_formatting.dart';
import 'package:simplycardtracker/core/extensions/comparison/date_comparison.dart';
import 'package:simplycardtracker/core/extensions/formatting/date_style_formatting.dart';
import 'package:simplycardtracker/features/card/common/widgets/card_pill.dart';
import 'package:simplycardtracker/features/card/credit/domain/entities/credit_card_entity.dart';

class CreditCard extends StatelessWidget {
  const CreditCard({super.key, required this.entity});

  final CreditCardEntity entity;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        if (entity.currentBill case final currentBill?) ...[
          Text(
            'Bill · due ${currentBill.dueDate.isThisYear ? currentBill.dueDate.shortMonthDay : currentBill.dueDate.shortMonthDayYear}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          FittedBox(
            fit: .scaleDown,
            child: Text(
              entity.currency.format(currentBill.amountDueMinor),
              style: textTheme.displayMedium?.copyWith(fontWeight: .w600),
            ),
          ),
        ],
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            if (entity.lastFourDigits case final lastFourDigits?
                when lastFourDigits.isNotEmpty)
              Text('•••• $lastFourDigits', style: textTheme.bodyLarge),
            if (!entity.hasAnnualFee)
              CardPill(
                padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                radius: 20,
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(Icons.check, size: textTheme.bodyMedium?.fontSize),
                    Text(
                      'No Annual Fee',
                      style: textTheme.labelMedium?.copyWith(fontWeight: .w600),
                    ),
                  ],
                ),
              ),
          ],
        ),
        if (entity.network case final network?) Text(network.label),
      ],
    );
  }
}
