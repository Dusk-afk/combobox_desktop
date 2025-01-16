import 'package:combobox_desktop/combobox_desktop.dart';
import 'package:combobox_desktop/src/stores/menu_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ComboboxMenu<T> extends StatelessWidget {
  final MenuStore<T> store;
  final ComboboxItemBuilder<T> itemBuilder;
  final BuildContext realContext;

  const ComboboxMenu({
    super.key,
    required this.store,
    required this.itemBuilder,
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
            child: Material(
              color: Colors.red,
              child: Theme(
                data: Theme.of(realContext).copyWith(
                  canvasColor: Colors.transparent,
                ),
                child: Center(
                  child: Stack(
                    children: [
                      if (store.actionItem != null)
                        Positioned(
                          left: 0,
                          top: 0,
                          width: store.menuStructure!.actionSize.width,
                          height: store.menuStructure!.actionSize.height,
                          child: GestureDetector(
                            onTap: store.callActionItem,
                            child: store.actionItem!.builder(context),
                          ),
                        ),
                      AnimatedPositioned(
                        duration: duration,
                        left: store.menuStructure!.listPos.dx,
                        top: store.menuStructure!.listPos.dy,
                        width: store.menuStructure!.listSize.width,
                        height: store.menuStructure!.listSize.height,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green,
                                Colors.greenAccent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Stack(
                            children: [
                              for (int i = store.menuStructure!.visibleItems.$1;
                                  i <= store.menuStructure!.visibleItems.$2;
                                  i++)
                                AnimatedPositioned(
                                  key: ValueKey(i),
                                  duration: duration,
                                  left: 0,
                                  top: i == 0
                                      ? -store.menuStructure!.listScrollOffset
                                      : store.menuStructure!
                                              .cumalativeSizes[i - 1].height -
                                          store.menuStructure!.listScrollOffset,
                                  width: store.menuStructure!.listSize.width,
                                  height:
                                      store.menuStructure!.itemSizes[i].height,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    onEnter: (event) {
                                      print("Mouse enter $i");
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        store.selectItem(i);
                                      },
                                      child: itemBuilder(
                                          store.menuStructure!.items[i].value),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: duration,
                        left: store.menuStructure!.cursorPos.dx,
                        top: store.menuStructure!.cursorPos.dy,
                        width: store.menuStructure!.cursorSize.width,
                        height: store.menuStructure!.cursorSize.height,
                        child: IgnorePointer(
                          child: Container(
                            color: Colors.blueAccent.withValues(alpha: 50),
                          ),
                        ),
                      ),
                    ],
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
