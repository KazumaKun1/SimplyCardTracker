import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simplycardtracker/features/card/common/domain/entities/card_entity.dart';
import 'package:simplycardtracker/features/card/common/widgets/card_swatch.dart';

/// 4.5 = WCAG AA for normal text. Lower only on purpose.
const minContrast = 4.5;

/// Deliberate design exceptions: swatch -> lowest contrast we accept.
const contrastExceptions = {
  CardSwatch.orange:
      3.0, // loved color; fine for large text, tight for small lines
};

double contrastWithWhite(Color c) => 1.05 / (c.computeLuminance() + 0.05);

void main() {
  group('CardSwatch', () {
    for (final swatch in CardSwatch.values) {
      for (final brightness in Brightness.values) {
        test('${swatch.name} is readable with white in $brightness', () {
          final required = contrastExceptions[swatch] ?? minContrast;
          expect(
            contrastWithWhite(swatch.fill(brightness)),
            greaterThanOrEqualTo(required),
          );
        });
      }
    }

    test('Unknown key falls back to the default', () {
      expect(CardSwatch.fromKey('nope'), CardSwatch.defaultSwatch);
    });

    test('entity default key matches the swatch default', () {
      expect(
        CardSwatch.fromKey(CardEntity.defaultColorKey),
        CardSwatch.defaultSwatch,
      );
    });
  });
}
