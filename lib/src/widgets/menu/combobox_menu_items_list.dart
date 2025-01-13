import 'package:combobox_desktop/src/stores/menu_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ComboboxMenuItemsList extends StatelessWidget {
  final MenuStore store;
  const ComboboxMenuItemsList({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return ListView.builder(
          itemCount: store.filteredItems.length,
          itemBuilder: (context, index) {
            final item = store.filteredItems[index];
            return Observer(builder: (context) {
              return ListTile(
                title: Text(
                  item.value.toString(),
                  style: TextStyle(
                    color: store.focusedIndex == index
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  store.selectItem(index);
                },
              );
            });
          },
        );
      },
    );
  }
}
