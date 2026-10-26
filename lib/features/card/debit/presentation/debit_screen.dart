import 'package:flutter/material.dart';
import 'package:simplycardtracker/features/card/common/widgets/horizontal_card_container.dart';
import 'package:simplycardtracker/features/card/debit/widgets/debit_card.dart';

import 'package:simplycardtracker/features/card/test_data/card_data.dart';

class DebitScreen extends StatefulWidget {
  const DebitScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DebitScreenState();
}

class _DebitScreenState extends State<DebitScreen> {
  int selectedCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const .only(bottom: 100.0),
          child: HorizontalCardContainer(
            cardTypeLabel: 'Credit',
            cards: debitCards,
            footerBuilder: (card) => DebitCard(entity: card),
          ),
        ),
      ),
    );
  }
}
