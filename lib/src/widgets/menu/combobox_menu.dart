import 'package:combobox_desktop/src/stores/menu_store.dart';
import 'package:combobox_desktop/src/widgets/menu/combobox_menu_items_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ComboboxMenu extends StatelessWidget {
  final MenuStore store;
  const ComboboxMenu({super.key, required this.store});

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

        return Positioned(
          left: 0,
          top: 80,
          child: Material(
            child: TextFieldTapRegion(
              child: Container(
                width: 200,
                height: 300,
                color: Colors.orangeAccent,
                child: ComboboxMenuItemsList(store: store),
              ),
            ),
          ),
        );
      },
    );
  }
}
