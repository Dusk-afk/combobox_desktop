import 'dart:math' as math;
import 'package:combobox_desktop/combobox_desktop.dart';
import 'package:combobox_desktop/src/models/menu_structure.dart';
import 'package:combobox_desktop/src/services/size_retriever.dart';
import 'package:combobox_desktop/src/stores/field_store.dart';
import 'package:combobox_desktop/src/stores/menu_store.dart';
import 'package:flutter/material.dart';

/// Listener for structure changes on the menu.
/// This includes changes to the position, size, scroll, offset
///
/// It then updates the [MenuStore] accordingly.
class StructureListener<T> {
  final FieldStore<T> fieldStore;
  final MenuStore<T> menuStore;
  final BuildContext context;
  final ComboboxItemBuilder<T> itemBuilder;

  StructureListener(
      this.context, this.fieldStore, this.menuStore, this.itemBuilder) {
    menuStore.onStructureInputChange.add(onItemsChange);
  }

  late final SizeRetriever<ComboboxActionItem> _sizeRetrieverAction =
      SizeRetriever(context);
  late final SizeRetriever<T> _sizeRetrieverItem = SizeRetriever(context);

  void onItemsChange(
    ComboboxActionItem? actionItem,
    List<ComboboxItem<T>> items,
    int focusedIndex,
    ComboboxMenuDecoration? decoration,
  ) async {
    double gradientHeight = 100;

    final (Offset? fieldPos, Size? fieldSize) = fieldStore.getPositionAndSize();
    if (fieldPos == null || fieldSize == null) return;
    // print("fieldPos: $fieldPos");
    // print("fieldSize: $fieldSize");

    Size screenSize = MediaQuery.of(context).size;
    // print("screenSize: $screenSize");

    double width = _calculateWidth(screenSize, fieldPos, fieldSize, decoration);
    // print("width: $width");

    Size actionSize = await _calculateActionItemSize(actionItem, width);
    // print("actionSize: $actionSize");

    int focusedIndex = menuStore.focusedIndex;
    // print("focusedIndex: $focusedIndex");

    List<Size> itemSizes = await _getItemSizes(items, width);
    // print("itemSizes: $itemSizes");
    Size totalSize = _calculateTotalSize(itemSizes);
    // print("totalSize: $totalSize");
    List<Size> cumulativeSizes = _calculateCumulativeSizes(itemSizes);
    // print("cumulativeSizes: $cumulativeSizes");
    double? virtualCursorPos = _calculateVirtualCursorPos(
      itemSizes,
      focusedIndex,
    );
    // print("virtualCursorPos: $virtualCursorPos");

    Offset framePos = _calculateFramePosition(
      fieldPos,
      fieldSize,
      totalSize,
      actionSize,
      virtualCursorPos,
      gradientHeight,
    );
    // print("framePos: $framePos");
    Size availableSize = Size(
      screenSize.width - framePos.dx,
      screenSize.height - framePos.dy,
    );
    bool isScrollable =
        totalSize.height + actionSize.height > availableSize.height;
    Size frameSize = _calculateFrameSize(
      width,
      isScrollable,
      availableSize,
      totalSize,
      actionSize,
      cumulativeSizes,
      gradientHeight,
      focusedIndex,
    );
    // print("frameSize: $frameSize");

    Offset listPos = Offset(0, actionSize.height);
    // print("listPos: $listPos");
    Size listSize = Size(frameSize.width, frameSize.height - actionSize.height);
    // print("listSize: $listSize");
    double listScrollOffset = _calculateListScrollOffset(
      virtualCursorPos,
      listSize,
      totalSize,
      actionSize,
      isScrollable,
      gradientHeight,
    );
    // print("listScrollOffset: $listScrollOffset");
    // double cursorPos = virtualCursorPos - listScrollOffset;
    Offset cursorPos = _calculateCursorPos(
      virtualCursorPos,
      listScrollOffset,
      actionSize.height,
    );
    // print("cursorPos: $cursorPos");
    Size cursorSize = _calculateCursorSize(
      actionSize,
      itemSizes,
      width,
      focusedIndex,
    );
    // print("cursorSize: $cursorSize");
    (int start, int end) visibleItems = _calculateVisibleItems(
      itemSizes,
      cumulativeSizes,
      listScrollOffset,
      listSize,
    );
    // print("visibleItems: $visibleItems");

    final (bool itemsAbove, bool itemsBelow) = _calculateItemsAboveAndBelow(
      listScrollOffset,
      listSize,
      totalSize,
    );

    menuStore.menuStructure = MenuStructure<T>(
      items: items,
      framePos: framePos,
      frameSize: frameSize,
      listPos: listPos,
      listSize: listSize,
      listScrollOffset: listScrollOffset,
      cursorPos: cursorPos,
      cursorSize: cursorSize,
      actionSize: actionSize,
      itemSizes: itemSizes,
      cumalativeSizes: cumulativeSizes,
      visibleItems: visibleItems,
      itemsAbove: itemsAbove,
      itemsBelow: itemsBelow,
    );
  }

  double _calculateWidth(
    Size screenSize,
    Offset fieldPos,
    Size fieldSize,
    ComboboxMenuDecoration? decoration,
  ) {
    double availableWidth = switch (menuStore.menuPosition) {
      ComboboxMenuPosition.below => screenSize.width - fieldPos.dx,
      ComboboxMenuPosition.right =>
        screenSize.width - fieldPos.dx - fieldSize.width,
    };

    double desiredWidth = fieldSize.width;

    return math.min(desiredWidth, availableWidth);
  }

  Future<Size> _calculateActionItemSize(
    ComboboxActionItem? actionItem,
    double width,
  ) async {
    if (actionItem == null) return Size.zero;
    return await _sizeRetrieverAction.getSize(
      SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            actionItem.builder(),
          ],
        ),
      ),
      actionItem,
    );
  }

  Future<List<Size>> _getItemSizes(
      List<ComboboxItem<T>> items, double width) async {
    List<KeyedWidget<T>> widgets = [];
    for (var item in items) {
      widgets.add((_getWidget(item, width), item.value));
    }
    List<Size> sizes = await _sizeRetrieverItem.getSizes(widgets);
    List<Size> widthAdjustedSizes =
        sizes.map((e) => Size(width, e.height)).toList();
    return widthAdjustedSizes;
  }

  Widget _getWidget(ComboboxItem<T> item, double width) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          itemBuilder(item.value),
        ],
      ),
    );
  }

  double? _calculateVirtualCursorPos(
    List<Size> itemSizes,
    int focusedIndex,
  ) {
    if (focusedIndex == -1) return null;

    double virtualCursorPos = 0;
    for (int i = 0; i < focusedIndex; i++) {
      virtualCursorPos += itemSizes[i].height;
    }
    return virtualCursorPos;
  }

  Size _calculateTotalSize(List<Size> itemSizes) {
    if (itemSizes.isEmpty) return Size.zero;
    double width =
        itemSizes.map((e) => e.width).reduce((a, b) => a > b ? a : b);
    double height = itemSizes.map((e) => e.height).reduce((a, b) => a + b);
    return Size(width, height);
  }

  List<Size> _calculateCumulativeSizes(List<Size> itemSizes) {
    List<Size> cumulativeSizes = [];
    double totalHeight = 0;
    for (int i = 0; i < itemSizes.length; i++) {
      totalHeight += itemSizes[i].height;
      cumulativeSizes.add(Size(itemSizes[i].width, totalHeight));
    }
    return cumulativeSizes;
  }

  Offset _calculateFramePosition(
    Offset fieldPos,
    Size fieldSize,
    Size totalSize,
    Size actionSize,
    double? virtualCursorPos,
    double gradientHeight,
  ) {
    switch (menuStore.menuPosition) {
      case ComboboxMenuPosition.below:
        double x = fieldPos.dx;
        double y = fieldPos.dy + fieldSize.height;
        return Offset(x, y);

      case ComboboxMenuPosition.right:
        double x = fieldPos.dx + fieldSize.width;
        double y = fieldPos.dy;
        if (virtualCursorPos == null) return Offset(x, y);
        return Offset(
          x,
          y - math.min(virtualCursorPos, gradientHeight) - actionSize.height,
        );
    }
  }

  Size _calculateFrameSize(
    double width,
    bool isScrollable,
    Size availableSize,
    Size totalSize,
    Size actionSize,
    List<Size> cumulativeSizes,
    double gradientHeight,
    int focusedIndex,
  ) {
    switch (menuStore.menuPosition) {
      case ComboboxMenuPosition.below:
        return Size(
          width,
          isScrollable
              ? availableSize.height
              : totalSize.height + actionSize.height,
        );

      case ComboboxMenuPosition.right:
        double height = isScrollable
            ? availableSize.height
            : totalSize.height + actionSize.height;
        double leftItemsHeight = totalSize.height -
            (focusedIndex <= 0
                ? 0.0
                : cumulativeSizes[focusedIndex - 1].height);
        return Size(
          width,
          math.min(
              actionSize.height + gradientHeight + leftItemsHeight, height),
        );
    }
  }

  double _calculateListScrollOffset(
    double? virtualCursorPos,
    Size listSize,
    Size totalSize,
    Size actionSize,
    bool isScrollable,
    double gradientHeight,
  ) {
    if (virtualCursorPos == null) return 0;

    switch (menuStore.menuPosition) {
      case ComboboxMenuPosition.below:
        if (!isScrollable) return 0;
        double mid = listSize.height / 2;
        if (virtualCursorPos < mid) {
          return 0;
        } else if (virtualCursorPos > totalSize.height - mid) {
          return totalSize.height - listSize.height;
        } else {
          return virtualCursorPos - mid;
        }

      case ComboboxMenuPosition.right:
        if (virtualCursorPos < gradientHeight) {
          return 0;
        } else {
          return virtualCursorPos - gradientHeight;
        }
    }
  }

  Offset _calculateCursorPos(
    double? virtualCursorPos,
    double listScrollOffset,
    double actionHeight,
  ) {
    if (virtualCursorPos == null) {
      return Offset(0, 0);
    } else {
      return Offset(0, virtualCursorPos - listScrollOffset + actionHeight);
    }
  }

  Size _calculateCursorSize(
    Size actionSize,
    List<Size> itemSizes,
    double width,
    int focusedIndex,
  ) {
    if (focusedIndex == -1) return actionSize;
    if (itemSizes.isEmpty) return Size.zero;
    return Size(width, itemSizes[focusedIndex].height);
  }

  (int, int) _calculateVisibleItems(
    List<Size> itemSizes,
    List<Size> cumulativeSizes,
    double listScrollOffset,
    Size listSize,
  ) {
    int start = 0;
    int end = itemSizes.length - 1;

    // A simple binary search to find the startindex of the visible items
    int l = 0;
    int r = itemSizes.length - 1;
    while (l < r) {
      int mid = (l + r) ~/ 2;
      if (cumulativeSizes[mid].height < listScrollOffset) {
        l = mid + 1;
      } else {
        start = mid;
        r = mid;
      }
    }

    l = 0;
    r = itemSizes.length - 1;
    while (l < r) {
      int mid = (l + r) ~/ 2;
      if (cumulativeSizes[mid].height < listScrollOffset + listSize.height) {
        l = mid + 1;
      } else {
        end = mid;
        r = mid;
      }
    }

    // Add relaxation
    if (start > 0) start--;
    if (end < itemSizes.length - 1) end++;

    return (start, end);
  }

  (bool, bool) _calculateItemsAboveAndBelow(
    double listScrollOffset,
    Size listSize,
    Size totalSize,
  ) {
    bool itemsAbove = listScrollOffset > 0;
    bool itemsBelow = listScrollOffset < (totalSize.height - listSize.height);
    return (itemsAbove, itemsBelow);
  }

  void dispose() {
    menuStore.onStructureInputChange.remove(onItemsChange);
  }
}
