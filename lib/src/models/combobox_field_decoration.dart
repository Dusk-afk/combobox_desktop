import 'package:flutter/material.dart';

class ComboboxFieldDecoration {
  final BorderRadius borderRadius;

  final Color filledColor;
  final Color filledFocusColor;
  final Color filledErrorColor;
  final Color filledErrorFocusColor;
  final Color filledDisabledColor;

  final Color cursorColor;
  final Color cursorErrorColor;
  final Color backgroundCursorColor;

  final Color borderColor;
  final Color borderFocusColor;
  final Color borderErrorColor;
  final Color borderErrorFocusColor;
  final Color borderDisabledColor;
  final double borderWidth;

  final Color arrowFillColor;
  final Color arrowFillErrorColor;
  final Color arrowFillDisabledColor;
  final double? arrowSize;

  final Color selectionColor;
  final Color selectionUnfocusedColor;

  final Color errorTextColor;

  final TextStyle? style;
  final TextStyle? placeholderStyle;
  final TextStyle? errorStyle;

  final String? placeholderText;

  final double? height;
  final EdgeInsets padding;

  const ComboboxFieldDecoration({
    this.borderRadius = BorderRadius.zero,
    this.filledColor = Colors.white,
    this.filledFocusColor = Colors.white,
    this.filledErrorColor = Colors.white,
    this.filledErrorFocusColor = Colors.white,
    this.filledDisabledColor = const Color.fromARGB(255, 240, 240, 240),
    this.cursorColor = Colors.blue,
    this.cursorErrorColor = Colors.red,
    this.backgroundCursorColor = Colors.grey,
    this.borderColor = Colors.blue,
    this.borderFocusColor = Colors.blue,
    this.borderErrorColor = Colors.red,
    this.borderErrorFocusColor = Colors.red,
    this.borderDisabledColor = Colors.grey,
    this.borderWidth = 1,
    this.arrowFillColor = const Color.fromARGB(255, 196, 229, 255),
    this.arrowFillErrorColor = const Color.fromARGB(255, 255, 200, 196),
    this.arrowFillDisabledColor = const Color.fromARGB(255, 240, 240, 240),
    this.arrowSize,
    this.selectionColor = const Color.fromARGB(255, 161, 213, 255),
    this.selectionUnfocusedColor = Colors.transparent,
    this.errorTextColor = Colors.red,
    this.style,
    this.placeholderStyle,
    this.errorStyle,
    this.placeholderText,
    this.height,
    this.padding = EdgeInsets.zero,
  });
}
