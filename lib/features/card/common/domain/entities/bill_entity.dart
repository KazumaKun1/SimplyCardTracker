enum BillStatus { unpaid, paid }

class BillEntity {
  final int amountDueMinor;
  final DateTime dueDate;
  final BillStatus status;

  const BillEntity({
    required this.amountDueMinor,
    required this.dueDate,
    required this.status,
  });
}
