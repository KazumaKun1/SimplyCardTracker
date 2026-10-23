import 'dart:math';

import 'package:intl/intl.dart';
import 'package:simplycardtracker/core/domain/currency.dart';

extension CurrencyFormatting on Currency {
  String format(int minor) {
    final factor = pow(10, decimals).toInt();
    return NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimals,
    ).format(minor / factor);
  }
}
