import 'package:flutter/material.dart';

class ComboboxActionItem {
  final String title;
  final VoidCallback onPressed;
  final Widget Function()? _builder;

  ComboboxActionItem({
    required this.title,
    required this.onPressed,
    Widget Function()? builder,
  }) : _builder = builder;

  Widget Function() get _defaultBuilder => () {
        return SizedBox(
          height: 50,
          child: Center(
            child: Text(title),
          ),
        );
      };

  Widget Function() get builder => _builder ?? _defaultBuilder;
}
