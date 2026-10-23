import 'package:simplycardtracker/features/card/common/domain/entities/card_entity.dart';

class DebitCardEntity extends CardEntity {
  final int currentAmountMinor;

  const DebitCardEntity({
    required super.id,
    super.bankName,
    super.cardName,
    super.network,
    super.tier,
    super.lastFourDigits,
    super.colorKey,
    required super.currency,
    required this.currentAmountMinor,
  });

  @override
  String getCardType() {
    return 'Debit';
  }
}
