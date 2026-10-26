import 'package:flutter/material.dart';

enum CardSwatch {
  teal(Colors.teal),
  red(Colors.red),
  blue(Colors.blue),
  purple(Colors.purple),
  green(Colors.green),
  orange(Colors.orange),
  pink(Colors.pink);

  const CardSwatch(this.color);
  final MaterialColor color;

  Color fill(Brightness brightness) =>
      brightness == Brightness.dark ? color.shade900 : color.shade800;

  static const defaultSwatch = teal;

  static CardSwatch fromKey(String key) =>
      CardSwatch.values.asNameMap()[key] ?? defaultSwatch;
}
