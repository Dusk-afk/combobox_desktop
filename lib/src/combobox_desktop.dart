import 'package:combobox_desktop/combobox_desktop.dart';
import 'package:combobox_desktop/src/listeners/structure_listener.dart';
import 'package:combobox_desktop/src/listeners/visibility_listener.dart';
import 'package:combobox_desktop/src/stores/field_store.dart';
import 'package:combobox_desktop/src/stores/menu_store.dart';
import 'package:combobox_desktop/src/widgets/combobox_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComboboxDesktop<T> extends StatefulWidget {
  /// List of items to display in the combobox.
  final List<ComboboxItem<T>> items;

  /// The current value of the combobox.
  final T? value;

  /// Callback when the value changes.
  ///
  /// It is mandatory to update the value in the parent widget.
  /// Otherwise, the combobox will not work as expected and there will
  /// be consequences in the future when the value is updated.
  final ComboboxItemChanged<T> onChanged;

  /// Function to convert the item to a string.
  ///
  /// This is used to display the item in the field.
  ///
  /// This will also be used to display the item in the menu if [itemBuilder] is not provided.
  final ComboboxItemStringifier<T>? stringifier;

  /// Function to build the item in the menu.
  final ComboboxItemBuilder<T>? itemBuilder;

  /// Error text to be displayed below the field.
  ///
  /// If null, no error will be displayed.
  /// If empty, only border will be displayed.
  /// If not empty, message will also be displayed.
  final String? errorText;

  /// The controller for the field.
  ///
  /// WARNING: This must only be used for reading the value.
  /// If used for writing, the state of the combobox will be inconsistent.
  final TextEditingController? controller;

  /// The focus node for the field.
  final FocusNode? focusNode;

  /// The position of the menu.
  final ComboboxMenuPosition menuPosition;

  /// The cursor builder for the menu.
  final ComboboxCursorBuilder? cursorBuilder;

  /// The background builder for the menu items.
  ///
  /// This is recommended instead of implementing the background in the item builder.
  /// Because the list will be displayed in between the background and the item if this is used.
  final ComboboxItemBackgroundBuilder? itemBackgroundBuilder;

  /// The action item to display at the top of the menu.
  final ComboboxActionItem? actionItem;

  /// The indicator to display if the items are available either above or below.
  ///
  /// This will be flipped to be used as bottom indicator.
  final ComboboxItemsIndicatorBuilder? itemsIndicatorBuilder;

  /// The decoration for the field.
  final ComboboxFieldDecoration fieldDecoration;

  /// The decoration for the menu.
  final ComboboxMenuDecoration? menuDecoration;

  /// If true, the field is read-only.
  final bool readOnly;

  /// If true, the field is disabled.
  ///
  /// In this state, the field is read-only and their is additional styling to show that the field is disabled.
  final bool disabled;

  /// The delay to move the focus after selecting the item.
  final Duration? nextFocusDelay;

  /// The focus node to move the focus to after selecting the item.
  final FocusNode? nextFocusNode;

  /// If true, the first item will be automatically selected if there is only one item
  /// and the text field is empty.
  final bool autoSelect;

  const ComboboxDesktop({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.stringifier,
    this.itemBuilder,
    this.errorText,
    this.controller,
    this.focusNode,
    this.menuPosition = ComboboxMenuPosition.below,
    this.actionItem,
    this.cursorBuilder,
    this.itemBackgroundBuilder,
    required this.fieldDecoration,
    this.menuDecoration,
    this.itemsIndicatorBuilder,
    this.readOnly = false,
    this.disabled = false,
    this.nextFocusDelay,
    this.nextFocusNode,
    this.autoSelect = true,
  });

  @override
  State<ComboboxDesktop<T>> createState() => _ComboboxDesktopState<T>();
}

class _ComboboxDesktopState<T> extends State<ComboboxDesktop<T>> {
  ComboboxItemStringifier<T> get _itemStringifier =>
      widget.stringifier ?? (item) => item.toString();

  ComboboxItemBuilder<T> get _itemBuilder =>
      widget.itemBuilder ??
      (item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            _itemStringifier(item),
          ),
        );
      };

  ComboboxCursorBuilder get _cursorBuilder =>
      widget.cursorBuilder ??
      () {
        return Container(
          color: Colors.blue,
        );
      };

  late final fieldStore = FieldStore(
    _itemStringifier,
    widget.disabled,
    widget.focusNode,
    widget.controller,
  );
  late final menuStore = MenuStore<T>(
    fieldStore,
    widget.items,
    _itemStringifier,
    widget.onChanged,
    widget.menuPosition,
    widget.actionItem,
    widget.menuDecoration,
    widget.nextFocusDelay,
    widget.nextFocusNode,
    widget.autoSelect,
  );
  late final visibilityListener = VisibilityListener<T>(
    context,
    fieldStore,
    menuStore,
    _itemBuilder,
    _cursorBuilder,
    widget.itemBackgroundBuilder,
    widget.itemsIndicatorBuilder,
    widget.disabled,
  );

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fieldStore.setItem(widget.value);
      });
    }
  }

  @override
  void didUpdateWidget(covariant ComboboxDesktop<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      fieldStore.setItem(widget.value);
    }

    if (!listEquals(oldWidget.items, widget.items)) {
      menuStore.setItems(widget.items);
    }

    if (oldWidget.errorText != widget.errorText) {
      fieldStore.errorText = widget.errorText;
    }

    if (oldWidget.onChanged != widget.onChanged) {
      menuStore.onChanged = widget.onChanged;
    }

    if (oldWidget.stringifier != widget.stringifier) {
      fieldStore.itemStringifier = _itemStringifier;
      menuStore.itemStringifier = _itemStringifier;
    }

    if (oldWidget.menuPosition != widget.menuPosition) {
      // TODO: This won't work if the menu is already open
      menuStore.menuPosition = widget.menuPosition;
    }

    if (oldWidget.actionItem != widget.actionItem) {
      menuStore.actionItem = widget.actionItem;
    }

    if (oldWidget.menuDecoration != widget.menuDecoration) {
      menuStore.decoration = widget.menuDecoration;
    }

    if (oldWidget.disabled != widget.disabled || oldWidget.readOnly != widget.readOnly) {
      fieldStore.disabled = widget.disabled || widget.readOnly;
      visibilityListener.disabled = widget.disabled || widget.readOnly;
    }

    if (oldWidget.controller != widget.controller) {
      // TODO: Handle this
    }

    if (oldWidget.focusNode != widget.focusNode) {
      // TODO: Handle this
    }

    if (oldWidget.nextFocusDelay != widget.nextFocusDelay) {
      menuStore.nextFocusDelay = widget.nextFocusDelay;
    }

    if (oldWidget.nextFocusNode != widget.nextFocusNode) {
      menuStore.nextFocusNode = widget.nextFocusNode;
    }

    if (oldWidget.autoSelect != widget.autoSelect) {
      menuStore.autoSelect = widget.autoSelect;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FieldStore>(
          create: (_) => fieldStore,
          dispose: (_, store) => store.dispose(),
        ),
        Provider<MenuStore>(
          create: (_) => menuStore,
          dispose: (_, store) => store.dispose(),
        ),
        Provider<VisibilityListener<T>>(
          create: (context) => visibilityListener,
          dispose: (_, listener) => listener.dispose(),
          lazy: false,
        ),
        Provider<StructureListener<T>>(
          create: (context) => StructureListener<T>(
            context,
            fieldStore,
            menuStore,
            _itemBuilder,
          ),
          dispose: (_, listener) => listener.dispose(),
          lazy: false,
        ),
      ],
      child: ComboboxField(
        decoration: widget.fieldDecoration,
        menuPosition: widget.menuPosition,
        disabled: widget.disabled,
        readOnly: widget.readOnly,
      ),
    );
  }
}
