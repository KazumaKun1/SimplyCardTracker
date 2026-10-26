import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplycardtracker/features/card/common/domain/entities/card_entity.dart';
import 'package:simplycardtracker/features/card/common/widgets/base_card.dart';
import 'package:simplycardtracker/features/card/common/widgets/horizontal_card_carousel.dart';
import 'package:simplycardtracker/features/card/common/widgets/no_cards_widget.dart';
import 'package:simplycardtracker/features/card/common/widgets/page_dots.dart';

class HorizontalCardContainer<T extends CardEntity> extends StatefulWidget {
  const HorizontalCardContainer({
    super.key,
    required this.cardTypeLabel,
    required this.cards,
    required this.footerBuilder,
  });

  final String cardTypeLabel;
  final List<T> cards;
  final Widget Function(T card) footerBuilder;

  @override
  State<HorizontalCardContainer<T>> createState() =>
      _HorizontalCardContainerState<T>();
}

class _HorizontalCardContainerState<T extends CardEntity>
    extends State<HorizontalCardContainer<T>> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) {
      return NoCardsWidget(
        text:
            'No ${widget.cardTypeLabel} Cards added. You can add a card by pressing "+" button below.',
      );
    }

    return Column(
      children: [
        HorizontalCardCarousel(
          numberOfItems: widget.cards.length,
          selectedIndex: selectedIndex,
          onSelectedChanged: (index) {
            HapticFeedback.selectionClick();
            setState(() => selectedIndex = index);
          },
          itemBuilder: (context, index) => BaseCard(
            entity: widget.cards[index],
            footer: widget.footerBuilder(widget.cards[index]),
            onTap: () async {
              await HapticFeedback.lightImpact();
              debugPrint('tapped ${widget.cards[index].cardName}');
            },
          ),
        ),
        PageDots(count: widget.cards.length, index: selectedIndex),
      ],
    );
  }
}
