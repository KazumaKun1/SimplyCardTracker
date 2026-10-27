import 'package:flutter/material.dart';
import 'package:simplycardtracker/features/card/common/widgets/horizontal_card_container.dart';
import 'package:simplycardtracker/features/card/credit/widgets/credit_card.dart';

import 'package:simplycardtracker/features/card/test_data/card_data.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const .only(bottom: 100.0),
          child: HorizontalCardContainer(
            cardTypeLabel: 'Credit',
            cards: creditCards,
            selectedIndex: selectedIndex,
            onSelectedChanged: (index) => setState(() => selectedIndex = index),
            footerBuilder: (card) => CreditCard(entity: card),
          ),
        ),
      ),
    );
  }
}
