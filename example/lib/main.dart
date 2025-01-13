import 'package:flutter/material.dart';
import 'package:combobox_desktop/combobox_desktop.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Center(
                  child: Text('Hello World!'),
                ),
                Row(
                  children: [
                    _DummyFocus(),
                    Expanded(
                      child: Example(),
                    ),
                    _DummyFocus(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  List<String> items1 = [
    "Banana",
    "Apple",
    "Orange",
    "Pineapple",
    "Grapes",
    "Mango",
    "Strawberry",
    "Watermelon",
  ];

  List<String> items2 = [
    "BMW",
    "Audi",
    "Mercedes",
    "Toyota",
    "Honda",
    "Ford",
    "Chevrolet",
    "Hyundai",
    "Kia",
    "Nissan",
    "Volkswagen",
  ];

  List<String> items3 = [
    "Red",
    "Green",
    "Blue",
    "Yellow",
    "Orange",
    "Purple",
    "Pink",
    "Black",
    "White",
    "Gray",
  ];

  late List<List<String>> itemsList = [items1, items2, items3];
  int _itemsIndex = 0;
  List<String> get items => itemsList[_itemsIndex];
  String? value;

  String? _error;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            FilledButton(
              onPressed: () {
                setState(() {
                  if (value == null) {
                    value = items.first;
                  } else {
                    value = items[(items.indexOf(value!) + 1) % items.length];
                  }
                });
              },
              child: Text("Next"),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _itemsIndex = (_itemsIndex + 1) % itemsList.length;
                });
              },
              child: Text("Switch Items"),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  if (_error == null) {
                    _error = "";
                  } else {
                    _error = null;
                  }
                });
              },
              child: Text("Toggle Error Border"),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  if (_error == null) {
                    _error = "Error message";
                  } else {
                    _error = null;
                  }
                });
              },
              child: Text("Toggle Error Message"),
            ),
          ],
        ),
        ComboboxDesktop<String>(
          items: items.map((e) => ComboboxItem(value: e)).toList(),
          value: value,
          onChanged: (value) {
            setState(() {
              this.value = value;
              if (_error != null && value != null) {
                _error = null;
              }
            });
          },
          errorText: _error,
        ),
        if (value != null) Text("Selected: $value"),
      ],
    );
  }
}

class _DummyFocus extends StatefulWidget {
  const _DummyFocus({super.key});

  @override
  State<_DummyFocus> createState() => __DummyFocusState();
}

class __DummyFocusState extends State<_DummyFocus> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: ListenableBuilder(
          listenable: _focusNode,
          builder: (context, _) {
            bool hasFocus = _focusNode.hasFocus;
            return Container(
              color: hasFocus ? Colors.blue : Colors.red,
              width: 100,
              height: 50,
            );
          }),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
