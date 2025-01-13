import 'package:combobox_desktop/src/stores/combobox_field_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ComboboxField extends StatelessWidget {
  const ComboboxField({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<ComboboxFieldStore>();

    return Observer(builder: (context) {
      return Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: store.errorText != null
                        ? Border.all(color: Colors.red)
                        : null,
                  ),
                  child: EditableText(
                    controller: store.controller,
                    focusNode: store.focusNode,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                    selectionColor: Colors.blue,
                    cursorColor: Colors.blue,
                    backgroundCursorColor: Colors.grey,
                  ),
                ),
                if (store.errorText?.isNotEmpty == true)
                  Text(
                    store.errorText!,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
          ListenableBuilder(
            listenable: store.focusNode,
            builder: (context, _) {
              return Text("Focus State: ${store.focusNode.hasFocus}");
            },
          ),
        ],
      );
    });
  }
}
