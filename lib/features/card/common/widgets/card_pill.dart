import 'package:flutter/material.dart';

class CardPill extends StatelessWidget {
  const CardPill({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(6),
    this.radius = 12,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
