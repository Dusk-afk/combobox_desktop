import 'package:collection/collection.dart';
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
    "BMW - 2",
    "Audi - 2",
    "Mercedes - 2",
    "Toyota - 2",
    "Honda - 2",
    "Ford - 2",
    "Chevrolet - 2",
    "Hyundai - 2",
    "Kia - 2",
    "Nissan - 2",
    "Volkswagen - 2",
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
            Text("Value: $value"),
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
        SizedBox(
          width: 200,
          child: ComboboxDesktop<String>(
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
            actionItem: ComboboxActionItem(
              title: "Create New",
              onPressed: () {},
            ),
          ),
        ),
        SizedBox(
          width: 400,
          child: ComboboxDesktop<String>(
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
            menuPosition: ComboboxMenuPosition.right,
          ),
        ),
        SizedBox(
          width: 400,
          child: ComboboxDesktop<String>(
            items: items
                .mapIndexed((i, e) => ComboboxItem(
                      value: e,
                    ))
                .toList(),
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
            menuPosition: ComboboxMenuPosition.right,
            actionItem: ComboboxActionItem(
              title: "Create New",
              onPressed: () {
                showAboutDialog(context: context);
              },
              builder: () => Container(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 9,
                          horizontal: 26,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFEBF4FF),
                          border: Border.all(
                            width: 1,
                            color: Color(0xFF1A84F6),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Create New',
                            style: TextStyle(
                              color: Color(0xFF2D2D2D),
                              fontSize: 14,
                              // fontFamily: 'Segoe UI',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            itemBackgroundBuilder: (i) => Container(
              color: [
                Colors.grey.shade100,
                Colors.white,
              ][i % 2],
            ),
            cursorBuilder: () => Container(
              decoration: BoxDecoration(
                color: Color(0xFFEBF4FF),
                border: Border.all(
                  width: 1,
                  color: Color(0xFF1A84F6),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            itemBuilder: (item) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              );
            },
            menuDecoration: ComboboxMenuDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 4),
                  blurRadius: 5,
                )
              ],
            ),
            itemsIndicatorBuilder: () => Container(
              height: 75,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withValues(alpha: 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.2,
                    1.0,
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: Transform.rotate(
                    angle: 3.14,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 300,
        ),
        SizedBox(
          width: 400,
          child: ComboboxDesktop<String>(
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
            menuPosition: ComboboxMenuPosition.right,
            actionItem: ComboboxActionItem(
              title: "Create New",
              onPressed: () {},
            ),
          ),
        ),
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
