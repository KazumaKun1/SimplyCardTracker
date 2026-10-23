sealed class PaymentNetwork {
  String get label;
  List<String> get tiers;
}

enum Network implements PaymentNetwork {
  visa('Visa', [
    'Classic',
    'Gold',
    'Platinum',
    'Signature',
    'Infinite',
    'Infinite Privilege',
    'Infinite Private',
  ]),
  mastercard('Mastercard', [
    'Standard',
    'Gold',
    'Titanium',
    'Platinum',
    'World',
    'World Elite',
    'World Legend',
  ]),
  jcb('JCB', ['Classic', 'Gold', 'Platinum', 'Ultimate', 'The Class']),
  amex('AMEX', ['Blue', 'Green', 'Gold', 'Platinum', 'Centurion']),
  unionPay('UnionPay', ['Classic', 'Gold', 'Platinum', 'Diamond']),
  dinersClub('Diners Club', ['Standard', 'Premier']);

  const Network(this.label, this.tiers);

  @override
  final String label;
  @override
  final List<String> tiers;
}

class CustomNetwork extends PaymentNetwork {
  CustomNetwork({required this.id, required this.label, this.tiers = const []});

  final String id;
  @override
  final String label;
  @override
  final List<String> tiers;
}
