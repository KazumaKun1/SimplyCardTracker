import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplycardtracker/features/card/common/widgets/base_card.dart';

import 'package:simplycardtracker/features/card/common/widgets/horizontal_card_carousel.dart';
import 'package:simplycardtracker/features/card/common/widgets/page_dots.dart';
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
          child: Column(
            children: [
              HorizontalCardCarousel(
                numberOfItems: debitCards.length,
                selectedIndex: selectedCardIndex,
                onSelectedChanged: (index) {
                  HapticFeedback.selectionClick();
                  setState(() => selectedCardIndex = index);
                },
                itemBuilder: (context, index) => BaseCard(
                  entity: debitCards[index],
                  footer: DebitCard(entity: debitCards[index]),
                  onTap: () async {
                    await HapticFeedback.lightImpact();
                    debugPrint('tapped ${debitCards[index].cardName}');
                  },
                ),
              ),
              PageDots(count: debitCards.length, index: selectedCardIndex),
            ],
          ),
        ),
      ),
    );
  }
}
