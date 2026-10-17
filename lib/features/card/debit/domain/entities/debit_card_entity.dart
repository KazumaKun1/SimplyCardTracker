import 'package:simplycardtracker/features/card/common/domain/entities/card_entity.dart';

class DebitCardEntity extends CardEntity {
  final int currentAmountMinor;

  const DebitCardEntity({
    required super.id,
    required super.cardName,
    required super.lastFourDigits,
    required super.currency,
    required this.currentAmountMinor,
  });
}
