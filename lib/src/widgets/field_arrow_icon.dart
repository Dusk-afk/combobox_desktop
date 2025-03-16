import 'package:combobox_desktop/combobox_desktop.dart';
import 'package:flutter/material.dart';

class FieldArrowIcon extends StatelessWidget {
  final Duration duration;
  final ComboboxMenuPosition menuPosition;
  final Color strokeColor;
  final Color fillColor;
  final double? size;
  final double borderWidth;
  final Radius topRightRadius;
  final Radius bottomRightRadius;
  final VoidCallback onPressed;

  const FieldArrowIcon({
    super.key,
    required this.duration,
    required this.menuPosition,
    required this.strokeColor,
    required this.fillColor,
    this.size,
    required this.borderWidth,
    required this.topRightRadius,
    required this.bottomRightRadius,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 44 / 34,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: duration,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.only(
                topRight: topRightRadius,
                bottomRight: bottomRightRadius,
              ),
              border: Border.all(
                color: strokeColor,
                width: borderWidth,
              ),
            ),
            child: Center(
              child: FittedBox(
                child: Transform.rotate(
                  angle: switch (menuPosition) {
                    ComboboxMenuPosition.below => 3 * 3.14 / 2,
                    ComboboxMenuPosition.right => 3.14,
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: strokeColor,
                    size: size ?? 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
