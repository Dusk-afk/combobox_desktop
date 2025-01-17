import 'package:combobox_desktop/combobox_desktop.dart';
import 'package:combobox_desktop/src/stores/menu_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ComboboxMenu<T> extends StatelessWidget {
  final MenuStore<T> store;
  final ComboboxItemBuilder<T> itemBuilder;
  final ComboboxCursorBuilder cursorBuilder;
  final ComboboxItemBackgroundBuilder? itemBackgroundBuilder;
  final ComboboxItemsIndicatorBuilder? itemsIndicatorBuilder;
  final BuildContext realContext;

  const ComboboxMenu({
    super.key,
    required this.store,
    required this.itemBuilder,
    required this.cursorBuilder,
    this.itemBackgroundBuilder,
    this.itemsIndicatorBuilder,
    required this.realContext,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (store.isMenuOpen == false) {
          if (kDebugMode) {
            return Text("[Debug] Menu is closed");
          }
          return Container();
        }

        if (store.menuStructure == null) {
          if (kDebugMode) {
            return Text("[Debug] Menu structure is null");
          }
          return Container();
        }

        final duration = Duration(milliseconds: 50);

        return AnimatedPositioned(
          duration: duration,
          left: store.menuStructure!.framePos.dx,
          top: store.menuStructure!.framePos.dy,
          width: store.menuStructure!.frameSize.width,
          height: store.menuStructure!.frameSize.height,
          child: TextFieldTapRegion(
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  if (event.scrollDelta.dy > 0) {
                    store.focusNextItem();
                  } else {
                    store.focusPreviousItem();
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      store.decoration?.borderRadius ?? BorderRadius.zero,
                  boxShadow: store.decoration?.boxShadow,
                ),
                child: ClipRRect(
                  borderRadius:
                      store.decoration?.borderRadius ?? BorderRadius.zero,
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(),
                    child: Theme(
                      data: Theme.of(realContext).copyWith(
                        canvasColor: Colors.transparent,
                      ),
                      child: Center(
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: duration,
                              left: store.menuStructure!.listPos.dx,
                              top: store.menuStructure!.listPos.dy,
                              width: store.menuStructure!.listSize.width,
                              height: store.menuStructure!.listSize.height,
                              child: Stack(
                                children: [
                                  for (int i =
                                          store.menuStructure!.visibleItems.$1;
                                      i <= store.menuStructure!.visibleItems.$2;
                                      i++)
                                    AnimatedPositioned(
                                      key: ValueKey(i),
                                      duration: duration,
                                      left: 0,
                                      top: i == 0
                                          ? -store
                                              .menuStructure!.listScrollOffset
                                          : store
                                                  .menuStructure!
                                                  .cumalativeSizes[i - 1]
                                                  .height -
                                              store.menuStructure!
                                                  .listScrollOffset,
                                      width: store
                                          .menuStructure!.itemSizes[i].width,
                                      height: store
                                          .menuStructure!.itemSizes[i].height,
                                      child: itemBackgroundBuilder != null
                                          ? itemBackgroundBuilder!(i)
                                          : Container(),
                                    ),
                                ],
                              ),
                            ),
                            AnimatedPositioned(
                              duration: duration,
                              left: store.menuStructure!.cursorPos.dx,
                              top: store.menuStructure!.cursorPos.dy,
                              width: store.menuStructure!.cursorSize.width,
                              height: store.menuStructure!.cursorSize.height,
                              child: IgnorePointer(
                                child: cursorBuilder(),
                              ),
                            ),
                            if (store.actionItem != null)
                              Positioned(
                                left: 0,
                                top: 0,
                                width: store.menuStructure!.actionSize.width,
                                height: store.menuStructure!.actionSize.height,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: store.callActionItem,
                                    behavior: HitTestBehavior.opaque,
                                    child: store.actionItem!.builder(),
                                  ),
                                ),
                              ),
                            AnimatedPositioned(
                              duration: duration,
                              left: store.menuStructure!.listPos.dx,
                              top: store.menuStructure!.listPos.dy,
                              width: store.menuStructure!.listSize.width,
                              height: store.menuStructure!.listSize.height,
                              child: Stack(
                                children: [
                                  for (int i =
                                          store.menuStructure!.visibleItems.$1;
                                      i <= store.menuStructure!.visibleItems.$2;
                                      i++)
                                    AnimatedPositioned(
                                      key: ValueKey(i),
                                      duration: duration,
                                      left: 0,
                                      top: i == 0
                                          ? -store
                                              .menuStructure!.listScrollOffset
                                          : store
                                                  .menuStructure!
                                                  .cumalativeSizes[i - 1]
                                                  .height -
                                              store.menuStructure!
                                                  .listScrollOffset,
                                      width: store
                                          .menuStructure!.itemSizes[i].width,
                                      height: store
                                          .menuStructure!.itemSizes[i].height,
                                      child: MouseRegion(
                                        cursor: store.menuStructure!.items[i]
                                                .disabled
                                            ? SystemMouseCursors.basic
                                            : SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: store.menuStructure!.items[i]
                                                  .disabled
                                              ? null
                                              : () {
                                                  store.selectItem(i);
                                                },
                                          behavior: HitTestBehavior.opaque,
                                          child: Opacity(
                                            opacity: store.menuStructure!
                                                    .items[i].disabled
                                                ? 0.3
                                                : 1,
                                            child: itemBuilder(store
                                                .menuStructure!.items[i].value),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (itemsIndicatorBuilder != null &&
                                      (store.menuStructure!.itemsAbove ||
                                          store.menuStructure!.itemsBelow))
                                    Positioned.fill(
                                      child: IgnorePointer(
                                        child: Column(
                                          children: [
                                            AnimatedOpacity(
                                              duration: duration,
                                              opacity: store
                                                      .menuStructure!.itemsAbove
                                                  ? 1
                                                  : 0,
                                              child: itemsIndicatorBuilder!(),
                                            ),
                                            Spacer(),
                                            AnimatedOpacity(
                                              duration: duration,
                                              opacity: store
                                                      .menuStructure!.itemsBelow
                                                  ? 1
                                                  : 0,
                                              child: Transform.rotate(
                                                angle: 3.14,
                                                child: itemsIndicatorBuilder!(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
