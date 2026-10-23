import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplycardtracker/features/card/common/widgets/base_card.dart';
import 'package:simplycardtracker/features/card/common/widgets/horizontal_card_carousel.dart';
import 'package:simplycardtracker/features/card/common/widgets/page_dots.dart';
import 'package:simplycardtracker/features/card/credit/widgets/credit_card.dart';

import 'package:simplycardtracker/features/card/test_data/card_data.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
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
                numberOfItems: creditCards.length,
                selectedIndex: selectedCardIndex,
                onSelectedChanged: (index) {
                  HapticFeedback.selectionClick();
                  setState(() => selectedCardIndex = index);
                },
                itemBuilder: (context, index) => BaseCard(
                  entity: creditCards[index],
                  footer: CreditCard(entity: creditCards[index]),
                  onTap: () async {
                    await HapticFeedback.lightImpact();
                    debugPrint('tapped ${creditCards[index].cardName}');
                  },
                ),
              ),
              PageDots(count: creditCards.length, index: selectedCardIndex),
            ],
          ),
        ),
      ),
    );
  }
}
