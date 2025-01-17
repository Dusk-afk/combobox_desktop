import 'dart:async';

import 'package:flutter/material.dart';

typedef KeyedWidget<T> = (Widget, T);

/// A service to retrieve the size of a widget.
///
/// [T] is the type of the key which is used to cache the size.
class SizeRetriever<T> {
  final Map<T, Size> _cache = {};
  final BuildContext context;

  SizeRetriever(this.context);

  /// Returns the size of a widget.
  Future<Size> getSize(Widget widget, T key) async {
    return (await getSizes([(widget, key)]))[0];
  }

  /// Returns the size of list of widgets.
  Future<List<Size>> getSizes(List<KeyedWidget<T>> widgets) async {
    // debugPrint("Getting sizes of ${widgets.length} widgets");
    List<Size> sizes = List.filled(widgets.length, Size.zero);
    List<int> uncachedIndexes = [];
    List<Widget> uncachedWidgets = [];

    for (int i = 0; i < widgets.length; i++) {
      final keyedWidget = widgets[i];
      final widget = keyedWidget.$1;
      final key = keyedWidget.$2;
      if (_cache.containsKey(key)) {
        sizes[i] = _cache[key]!;
      } else {
        uncachedIndexes.add(i);
        uncachedWidgets.add(widget);
      }
    }

    // debugPrint("Uncached widgets: ${uncachedWidgets.length}");

    DateTime start = DateTime.now();
    List<Size> uncachedSizes = await _getSizesOfWidgets(uncachedWidgets);
    // debugPrint(
    // "Time taken: ${DateTime.now().difference(start).inMilliseconds}ms");

    for (int i = 0; i < uncachedIndexes.length; i++) {
      final index = uncachedIndexes[i];
      final size = uncachedSizes[i];
      sizes[index] = size;
      _cache[widgets[index].$2] = size;
    }

    return sizes;
  }

  Future<List<Size>> _getSizesOfWidgets(List<Widget> widgets) async {
    Completer<List<Size>> completer = Completer();
    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) {
        return _OverlayWidget(
          widgets: widgets,
          onSizesRetrieved: (sizes) {
            completer.complete(sizes);
            entry?.remove();
          },
          realContext: context,
        );
      },
    );

    Overlay.of(context).insert(entry);
    return completer.future;
  }

  void dispose() {
    _cache.clear();
  }
}

class _OverlayWidget extends StatefulWidget {
  final List<Widget> widgets;
  final void Function(List<Size> sizes) onSizesRetrieved;
  final BuildContext realContext;

  const _OverlayWidget({
    super.key,
    required this.widgets,
    required this.onSizesRetrieved,
    required this.realContext,
  });

  @override
  State<_OverlayWidget> createState() => __OverlayWidgetState();
}

class __OverlayWidgetState extends State<_OverlayWidget> {
  late final List<GlobalKey> keys =
      List.generate(widget.widgets.length, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getSizes();
    });
  }

  void _getSizes() {
    List<Size> sizes = [];
    for (int i = 0; i < widget.widgets.length; i++) {
      final key = keys[i];
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        sizes.add(renderBox.size);
      }
    }
    widget.onSizesRetrieved(sizes);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Theme(
        data: Theme.of(widget.realContext),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Stack(
              children: [
                for (int i = 0; i < widget.widgets.length; i++)
                  Positioned(
                    key: keys[i],
                    child: widget.widgets[i],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
