import 'package:flutter/material.dart';

class ComboboxActionItem {
  final String title;
  final VoidCallback onPressed;
  final WidgetBuilder? _builder;

  ComboboxActionItem({
    required this.title,
    required this.onPressed,
    WidgetBuilder? builder,
  }) : _builder = builder;

  WidgetBuilder get _defaultBuilder => (context) {
        return Container(
          height: 50,
          child: Center(
            child: Text(title),
          ),
        );
      };

  WidgetBuilder get builder => _builder ?? _defaultBuilder;
}
