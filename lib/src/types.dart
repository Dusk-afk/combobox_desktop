import 'package:flutter/widgets.dart';

typedef ComboboxItemBuilder<T> = Widget Function(T value);
typedef ComboboxItemChanged<T> = void Function(T? value);
typedef ComboboxItemStringifier<T> = String Function(T value);
typedef ComboboxCursorBuilder = Widget Function();
typedef ComboboxItemBackgroundBuilder = Widget Function(int index);
typedef ComboboxItemsIndicatorBuilder = Widget Function();
