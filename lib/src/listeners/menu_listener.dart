import 'package:combobox_desktop/src/stores/combobox_field_store.dart';
import 'package:combobox_desktop/src/stores/menu_store.dart';
import 'package:combobox_desktop/src/widgets/menu/combobox_menu.dart';
import 'package:flutter/material.dart';

/// Listener for the menu.
///
/// This will create an overlay menu when the field is focused.
/// The menu will be closed when the field loses focus.
///
/// It then updates the [MenuStore] accordingly.
class MenuListener {
  final ComboboxFieldStore fieldStore;
  final MenuStore menuStore;
  final BuildContext context;

  MenuListener(this.context, this.fieldStore, this.menuStore) {
    fieldStore.focusNode.addListener(_focusListener);
  }

  OverlayEntry? _overlayEntry;

  /// Listener for the focus state of the field.
  void _focusListener() {
    if (fieldStore.focusNode.hasFocus && !menuStore.isMenuOpen) {
      _openMenu();
    } else if (!fieldStore.focusNode.hasFocus && menuStore.isMenuOpen) {
      _closeMenu();
    }
  }

  /// Creates a new overlay entry for the menu.
  OverlayEntry _createEntry() {
    return OverlayEntry(
      builder: (context) {
        return ComboboxMenu(store: menuStore);
      },
    );
  }

  /// Creates a new overlay entry for the menu.
  void _openMenu() {
    menuStore.openMenu();
    _overlayEntry = _createEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Close the menu
  void _closeMenu() {
    menuStore.closeMenu();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void dispose() {
    fieldStore.focusNode.removeListener(_focusListener);
    _overlayEntry?.remove();
  }
}
