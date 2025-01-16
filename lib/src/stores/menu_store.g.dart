// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MenuStore<T> on _MenuStore<T>, Store {
  Computed<int>? _$focusedIndexComputed;

  @override
  int get focusedIndex =>
      (_$focusedIndexComputed ??= Computed<int>(() => super.focusedIndex,
              name: '_MenuStore.focusedIndex'))
          .value;

  late final _$isMenuOpenAtom =
      Atom(name: '_MenuStore.isMenuOpen', context: context);

  @override
  bool get isMenuOpen {
    _$isMenuOpenAtom.reportRead();
    return super.isMenuOpen;
  }

  @override
  set isMenuOpen(bool value) {
    _$isMenuOpenAtom.reportWrite(value, super.isMenuOpen, () {
      super.isMenuOpen = value;
    });
  }

  late final _$itemsAtom = Atom(name: '_MenuStore.items', context: context);

  @override
  List<ComboboxItem<T>> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(List<ComboboxItem<T>> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  late final _$_focusedIndexAtom =
      Atom(name: '_MenuStore._focusedIndex', context: context);

  @override
  int get _focusedIndex {
    _$_focusedIndexAtom.reportRead();
    return super._focusedIndex;
  }

  @override
  set _focusedIndex(int value) {
    _$_focusedIndexAtom.reportWrite(value, super._focusedIndex, () {
      super._focusedIndex = value;
    });
  }

  late final _$filteredItemsAtom =
      Atom(name: '_MenuStore.filteredItems', context: context);

  @override
  List<ComboboxItem<T>> get filteredItems {
    _$filteredItemsAtom.reportRead();
    return super.filteredItems;
  }

  bool _filteredItemsIsInitialized = false;

  @override
  set filteredItems(List<ComboboxItem<T>> value) {
    _$filteredItemsAtom.reportWrite(
        value, _filteredItemsIsInitialized ? super.filteredItems : null, () {
      super.filteredItems = value;
      _filteredItemsIsInitialized = true;
    });
  }

  late final _$menuStructureAtom =
      Atom(name: '_MenuStore.menuStructure', context: context);

  @override
  MenuStructure<dynamic>? get menuStructure {
    _$menuStructureAtom.reportRead();
    return super.menuStructure;
  }

  @override
  set menuStructure(MenuStructure<dynamic>? value) {
    _$menuStructureAtom.reportWrite(value, super.menuStructure, () {
      super.menuStructure = value;
    });
  }

  late final _$actionItemAtom =
      Atom(name: '_MenuStore.actionItem', context: context);

  @override
  ComboboxActionItem? get actionItem {
    _$actionItemAtom.reportRead();
    return super.actionItem;
  }

  @override
  set actionItem(ComboboxActionItem? value) {
    _$actionItemAtom.reportWrite(value, super.actionItem, () {
      super.actionItem = value;
    });
  }

  late final _$_MenuStoreActionController =
      ActionController(name: '_MenuStore', context: context);

  @override
  void openMenu() {
    final _$actionInfo =
        _$_MenuStoreActionController.startAction(name: '_MenuStore.openMenu');
    try {
      return super.openMenu();
    } finally {
      _$_MenuStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeMenu() {
    final _$actionInfo =
        _$_MenuStoreActionController.startAction(name: '_MenuStore.closeMenu');
    try {
      return super.closeMenu();
    } finally {
      _$_MenuStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setItems(List<ComboboxItem<T>> items) {
    final _$actionInfo =
        _$_MenuStoreActionController.startAction(name: '_MenuStore.setItems');
    try {
      return super.setItems(items);
    } finally {
      _$_MenuStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void focusNextItem() {
    final _$actionInfo = _$_MenuStoreActionController.startAction(
        name: '_MenuStore.focusNextItem');
    try {
      return super.focusNextItem();
    } finally {
      _$_MenuStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void focusPreviousItem() {
    final _$actionInfo = _$_MenuStoreActionController.startAction(
        name: '_MenuStore.focusPreviousItem');
    try {
      return super.focusPreviousItem();
    } finally {
      _$_MenuStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectItem([int? index]) {
    final _$actionInfo =
        _$_MenuStoreActionController.startAction(name: '_MenuStore.selectItem');
    try {
      return super.selectItem(index);
    } finally {
      _$_MenuStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void callActionItem() {
    final _$actionInfo = _$_MenuStoreActionController.startAction(
        name: '_MenuStore.callActionItem');
    try {
      return super.callActionItem();
    } finally {
      _$_MenuStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void filterItems(String value) {
    final _$actionInfo = _$_MenuStoreActionController.startAction(
        name: '_MenuStore.filterItems');
    try {
      return super.filterItems(value);
    } finally {
      _$_MenuStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetFilter() {
    final _$actionInfo = _$_MenuStoreActionController.startAction(
        name: '_MenuStore.resetFilter');
    try {
      return super.resetFilter();
    } finally {
      _$_MenuStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isMenuOpen: ${isMenuOpen},
items: ${items},
filteredItems: ${filteredItems},
menuStructure: ${menuStructure},
actionItem: ${actionItem},
focusedIndex: ${focusedIndex}
    ''';
  }
}
