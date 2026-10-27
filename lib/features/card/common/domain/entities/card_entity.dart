import 'package:simplycardtracker/core/domain/currency.dart';
import 'package:simplycardtracker/features/card/common/domain/payment_network.dart';

abstract class CardEntity {
  static const String defaultColorKey = 'teal';

  final String id;
  final String? bankName;
  final String? cardName;
  final String? lastFourDigits;
  final PaymentNetwork? network;
  final String? tier;
  final Currency currency;
  final String colorKey;

  const CardEntity({
    required this.id,
    this.bankName,
    this.cardName,
    this.lastFourDigits,
    this.network,
    this.tier,
    required this.currency,
    this.colorKey = defaultColorKey,
  });

  String getCardType() {
    return 'Default';
  }
}
