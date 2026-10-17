import 'package:simplycardtracker/core/domain/currency.dart';

abstract class CardEntity {
  final String id;
  final String cardName;
  final String? lastFourDigits;
  final Currency currency;

  // TODO: - Add customizable cardthemes here like enum based

  const CardEntity({
    required this.id,
    required this.cardName,
    this.lastFourDigits,
    required this.currency,
  });
}
