import 'package:simplycardtracker/features/card/common/domain/entities/bill_entity.dart';
import 'package:simplycardtracker/features/card/common/domain/entities/card_entity.dart';

class CreditCardEntity extends CardEntity {
  final int creditLimitMinor;
  final int availableCreditMinor;
  final bool hasAnnualFee;
  final BillEntity? currentBill;

  const CreditCardEntity({
    required super.id,
    required super.cardName,
    required super.lastFourDigits,
    required super.currency,
    required this.creditLimitMinor,
    required this.availableCreditMinor,
    required this.hasAnnualFee,
    this.currentBill,
  });
}
