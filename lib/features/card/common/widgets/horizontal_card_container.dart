import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplycardtracker/features/card/common/domain/entities/card_entity.dart';
import 'package:simplycardtracker/features/card/common/widgets/base_card.dart';
import 'package:simplycardtracker/features/card/common/widgets/horizontal_card_carousel.dart';
import 'package:simplycardtracker/features/card/common/widgets/no_cards_widget.dart';
import 'package:simplycardtracker/features/card/common/widgets/page_dots.dart';

class HorizontalCardContainer<T extends CardEntity> extends StatelessWidget {
  const HorizontalCardContainer({
    super.key,
    required this.cardTypeLabel,
    required this.cards,
    required this.selectedIndex,
    required this.onSelectedChanged,
    required this.footerBuilder,
  });

  final String cardTypeLabel;
  final List<T> cards;
  final int selectedIndex;
  final ValueChanged<int> onSelectedChanged;
  final Widget Function(T card) footerBuilder;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return NoCardsWidget(
        text:
            'No $cardTypeLabel Cards added. You can add a card by pressing "+" button below.',
      );
    }

    return Column(
      children: [
        HorizontalCardCarousel(
          numberOfItems: cards.length,
          selectedIndex: selectedIndex,
          onSelectedChanged: (index) {
            HapticFeedback.selectionClick();
            onSelectedChanged(index);
          },
          itemBuilder: (context, index) => BaseCard(
            entity: cards[index],
            footer: footerBuilder(cards[index]),
            onTap: () async {
              await HapticFeedback.lightImpact();
              debugPrint('tapped ${cards[index].cardName}');
            },
          ),
        ),
        PageDots(count: cards.length, index: selectedIndex),
      ],
    );
  }
}