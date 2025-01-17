import 'dart:math' as math;
import 'package:combobox_desktop/combobox_desktop.dart';
import 'package:combobox_desktop/src/models/menu_structure.dart';
import 'package:combobox_desktop/src/services/hook.dart';
import 'package:combobox_desktop/src/stores/combobox_field_store.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'menu_store.g.dart';

// This is the class used by rest of your codebase
class MenuStore<T> = _MenuStore<T> with _$MenuStore<T>;

// The store-class
abstract class _MenuStore<T> with Store {
  final ComboboxFieldStore<T> fieldStore;
  ComboboxItemStringifier<T> itemStringifier;
  ComboboxItemChanged<T> onChanged;
  ComboboxMenuPosition menuPosition;

  _MenuStore(
    this.fieldStore,
    this.items,
    this.itemStringifier,
    this.onChanged,
    this.menuPosition,
    this.actionItem,
    this.decoration,
  ) {
    filteredItems = items;

    // Hook up the keyboard events
    fieldStore.onArrowDown = focusNextItem;
    fieldStore.onArrowUp = focusPreviousItem;
    fieldStore.onEnter = selectItem;
    fieldStore.onTextChangeHook.add(filterItems);

    // Automatic select on one item
    if (items.length == 1 && fieldStore.item == null) {
      Future.microtask(() {
        selectItem(0);
      });
    }
  }

  @observable
  bool isMenuOpen = false;

  @action
  void openMenu() {
    isMenuOpen = true;

    if (menuStructure == null) {
      callOnStructureInputChange();
    }
  }

  @action
  void closeMenu() {
    isMenuOpen = false;
    resetFilter();
  }

  @observable
  List<ComboboxItem<T>> items;

  /// Updates the items in the menu.
  ///
  /// If the current item is not in the new list, the item will be reset.
  @action
  void setItems(List<ComboboxItem<T>> items) {
    this.items = items;
    resetFilter();

    Future.microtask(() {
      callOnStructureInputChange();
    });

    // If the current item is not in the new list, reset the item
    if (fieldStore.item != null &&
        !items.any((item) => item.value == fieldStore.item)) {
      Future.microtask(() {
        onChanged.call(null);
      });
    }

    if (items.length == 1 && fieldStore.item == null) {
      Future.microtask(() {
        selectItem(0);
      });
    }
  }

  @observable
  int _focusedIndex = 0;

  /// Returns the index of the focused item by adhering to constraints:
  /// - The index should be within the bounds of the filtered items
  /// - The index should not point to a disabled item
  ///
  /// If both conditions are not met, -1 is returned no matter action item is present or not
  @computed
  int get focusedIndex {
    int index = math.max(
      math.min(_focusedIndex, filteredItems.length - 1),
      -1,
    );
    if (index < 0) {
      return index;
    }

    for (;
        index < filteredItems.length && filteredItems[index].disabled;
        index++) {}
    if (index >= filteredItems.length) {
      index--;
    }
    if (filteredItems[index].disabled) {
      for (; index >= 0 && filteredItems[index].disabled; index--) {}
    }
    return index;
  }

  /// Tries to focus to next enabled item
  /// If not possible, then stays on the current item
  @action
  void focusNextItem() {
    int newIndex = math.min(focusedIndex + 1, filteredItems.length - 1);
    for (;
        newIndex < filteredItems.length && filteredItems[newIndex].disabled;
        newIndex++) {}
    if (newIndex < filteredItems.length) {
      _focusedIndex = newIndex;
      callOnStructureInputChange();
    }
  }

  /// Tries to focus to previous enabled item
  /// If not possible, then stays on the current item
  @action
  void focusPreviousItem() {
    int newIndex = math.max(
      math.min(focusedIndex - 1, filteredItems.length - 1),
      actionItem != null ? -1 : 0,
    );
    for (; newIndex >= 0 && filteredItems[newIndex].disabled; newIndex--) {}
    if (newIndex >= 0 || actionItem != null) {
      _focusedIndex = newIndex;
      callOnStructureInputChange();
    }
  }

  @action
  void selectItem([int? index]) {
    _focusedIndex = index ?? focusedIndex;

    if (_focusedIndex < 0) {
      callActionItem();
      return;
    }

    final item = filteredItems[_focusedIndex];
    _ignoreFilter = itemStringifier(item.value);
    onChanged.call(item.value);
    if (fieldStore.focusNode.hasFocus) {
      fieldStore.focusNode.nextFocus();
    }
  }

  @action
  void callActionItem() {
    if (actionItem != null) {
      _focusedIndex = -1;
      actionItem!.onPressed();
    }
  }

  @observable
  late List<ComboboxItem<T>> filteredItems;

  Hook<
      void Function(
        ComboboxActionItem? actionItem,
        List<ComboboxItem<T>> items,
        int focusedIndex,
        ComboboxMenuDecoration? decoration,
      )> onStructureInputChange = Hook();

  void callOnStructureInputChange({
    ComboboxActionItem? actionItem,
    List<ComboboxItem<T>>? items,
    int? focusedIndex,
    ComboboxMenuDecoration? decoration,
  }) {
    onStructureInputChange((callback) {
      callback(
        actionItem ?? this.actionItem,
        items ?? filteredItems,
        focusedIndex ?? this.focusedIndex,
        decoration ?? this.decoration,
      );
    });
  }

  /// Used for preventing unnecessary filtering if the filter value hasn't changed
  String? _lastFilter;

  /// Used for preventing a loop when setting the value
  String? _ignoreFilter;

  @action
  void filterItems(String value) {
    if (_ignoreFilter == value) {
      _ignoreFilter = null;
      _lastFilter = value;
      return;
    }

    if (fieldStore.item != null &&
        itemStringifier(fieldStore.item as T) == value) {
      return;
    }

    if (_lastFilter == value) {
      return;
    }
    _lastFilter = value;

    filteredItems = items
        .where((item) =>
            item.value.toString().toLowerCase().contains(value.toLowerCase()))
        .toList();

    callOnStructureInputChange();

    if (fieldStore.item != null) {
      // While the user is typing, we do not want to select any item
      Future.microtask(() {
        // Prepare the field to ignore the next setItem call
        fieldStore.ignoreNextSetItem();
        // This relies on the fact that the onChanged callback will call the selectItem method
        // Therefore, callback should be properly set
        onChanged.call(null);
      });
    }
  }

  @action
  void resetFilter() {
    filteredItems = items;
    Future.microtask(() {
      callOnStructureInputChange();
    });
  }

  @observable
  MenuStructure<T>? menuStructure;

  @observable
  ComboboxActionItem? actionItem;

  @observable
  ComboboxMenuDecoration? decoration;

  @action
  void setDecoration(ComboboxMenuDecoration? decoration) {
    this.decoration = decoration;
    callOnStructureInputChange();
  }

  void dispose() {
    // Unhook the keyboard events
    fieldStore.onArrowDown = null;
    fieldStore.onArrowUp = null;
    fieldStore.onEnter = null;
    fieldStore.onTextChangeHook.remove(filterItems);
  }
}
