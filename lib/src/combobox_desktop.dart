import 'package:combobox_desktop/src/listeners/menu_listener.dart';
import 'package:combobox_desktop/src/stores/combobox_field_store.dart';
import 'package:combobox_desktop/src/stores/menu_store.dart';
import 'package:combobox_desktop/src/types.dart';
import 'package:combobox_desktop/src/widgets/combobox_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'models/combobox_item.dart';

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
  final ComboboxItemStringifier<T>? stringifier;

  /// Error text to be displayed below the field.
  ///
  /// If null, no error will be displayed.
  /// If empty, only border will be displayed.
  /// If not empty, message will also be displayed.
  final String? errorText;

  const ComboboxDesktop({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.stringifier,
    this.errorText,
  });

  @override
  State<ComboboxDesktop<T>> createState() => _ComboboxDesktopState<T>();
}

class _ComboboxDesktopState<T> extends State<ComboboxDesktop<T>> {
  late final ComboboxItemStringifier<T> _itemStringifier =
      widget.stringifier ?? (item) => item.toString();

  late final fieldStore = ComboboxFieldStore(_itemStringifier);
  late final menuStore = MenuStore<T>(
    fieldStore,
    widget.items,
    _itemStringifier,
    widget.onChanged,
  );

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
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ComboboxFieldStore>(
          create: (_) => fieldStore,
          dispose: (_, store) => store.dispose(),
        ),
        Provider<MenuStore>(
          create: (_) => menuStore,
          dispose: (_, store) => store.dispose(),
        ),
        Provider<MenuListener>(
          create: (context) => MenuListener(context, fieldStore, menuStore),
          dispose: (_, listener) => listener.dispose(),
          lazy: false,
        ),
      ],
      child: ComboboxField(),
    );
  }
}
