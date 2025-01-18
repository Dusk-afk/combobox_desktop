import 'package:flutter/material.dart';

class ComboboxMenuDecoration {
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;
  final Offset globalOffset;

  const ComboboxMenuDecoration({
    this.borderRadius = BorderRadius.zero,
    this.boxShadow = const [],
    this.globalOffset = Offset.zero,
  });
}
