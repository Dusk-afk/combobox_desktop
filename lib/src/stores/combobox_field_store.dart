import 'package:combobox_desktop/combobox_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'combobox_field_store.g.dart';

// This is the class used by rest of your codebase
class ComboboxFieldStore<T> = _ComboboxFieldStore<T>
    with _$ComboboxFieldStore<T>;

// The store-class
abstract class _ComboboxFieldStore<T> with Store {
  final ComboboxItemStringifier<T> _itemStringifier;

  _ComboboxFieldStore(this._itemStringifier);

  @observable
  TextEditingController controller = TextEditingController();

  @observable
  late FocusNode focusNode = _createFocusNode();

  @observable
  T? item;

  /// Sets a string value to the controller.
  ///
  /// To set an item, use [setItem].
  void setValue(String value) {
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  // This is used to ignore the next setItem call.
  // Useful for case when the item needs to be updated
  // while keeping the current value.
  bool _ignoreNextSetItemFromMenuStore = false;
  void ignoreNextSetItem() {
    _ignoreNextSetItemFromMenuStore = true;
  }

  bool _ignoreNotifyingListeners = false;
  void ignoreNotifyingListeners() {
    _ignoreNotifyingListeners = true;
  }

  void setItem(T? item) {
    this.item = item;

    // If ignore request from [MenuStore]
    if (_ignoreNextSetItemFromMenuStore) {
      _ignoreNextSetItemFromMenuStore = false;
      return;
    }

    // Generate a ignore request for notifying listeners
    ignoreNotifyingListeners();

    if (item == null) {
      setValue('');
    } else {
      setValue(_itemStringifier(item));
    }
  }

  // Hooks
  final Map<LogicalKeyboardKey, VoidCallback?> _focusNodeBlacklistedKeys = {
    LogicalKeyboardKey.arrowDown: null,
    LogicalKeyboardKey.arrowUp: null,
    LogicalKeyboardKey.enter: null,
  };

  set onArrowDown(VoidCallback? callback) {
    _focusNodeBlacklistedKeys[LogicalKeyboardKey.arrowDown] = callback;
  }

  set onArrowUp(VoidCallback? callback) {
    _focusNodeBlacklistedKeys[LogicalKeyboardKey.arrowUp] = callback;
  }

  set onEnter(VoidCallback? callback) {
    _focusNodeBlacklistedKeys[LogicalKeyboardKey.enter] = callback;
  }

  /// Creates a new [FocusNode] with blacklisted keys.
  FocusNode _createFocusNode() {
    return FocusNode(onKeyEvent: (node, event) {
      if (_focusNodeBlacklistedKeys.containsKey(event.logicalKey)) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          _focusNodeBlacklistedKeys[event.logicalKey]?.call();
        }
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    });
  }

  VoidCallback? _onTextChangeHook;
  set onTextChanged(void Function(String)? callback) {
    if (_onTextChangeHook != null) {
      controller.removeListener(_onTextChangeHook!);
    }

    if (callback != null) {
      _onTextChangeHook = () {
        // Ignore the call if requested earlier
        if (_ignoreNotifyingListeners) {
          _ignoreNotifyingListeners = false;
          return;
        }

        callback(controller.text);
      };
      controller.addListener(_onTextChangeHook!);
    }
  }

  /// Error text to be displayed below the field.
  ///
  /// If null, no error will be displayed.
  /// If empty, only border will be displayed.
  /// If not empty, message will also be displayed.
  @observable
  String? errorText;

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}
