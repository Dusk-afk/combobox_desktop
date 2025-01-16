import 'package:combobox_desktop/combobox_desktop.dart';
import 'package:flutter/material.dart';

class MenuStructure<T> {
  final List<ComboboxItem<T>> items;

  /// Position of the frame
  ///
  /// This is relative to the screen
  final Offset framePos;
  final Size frameSize;

  /// Position of the list inside the frame
  ///
  /// This is relative to the [framePos]
  final Offset listPos;
  final Size listSize;
  final double listScrollOffset;

  /// Position of the cursor inside the list
  ///
  /// This is relative to the [listPos]
  final Offset cursorPos;
  final Size cursorSize;

  final Size actionSize;
  final List<Size> itemSizes;
  final List<Size> cumalativeSizes;
  final (int start, int end) visibleItems;

  MenuStructure({
    required this.items,
    required this.framePos,
    required this.frameSize,
    required this.listPos,
    required this.listSize,
    required this.listScrollOffset,
    required this.cursorPos,
    required this.cursorSize,
    required this.actionSize,
    required this.itemSizes,
    required this.cumalativeSizes,
    required this.visibleItems,
  });
}
