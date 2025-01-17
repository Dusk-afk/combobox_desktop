import 'package:combobox_desktop/combobox_desktop.dart';
import 'package:combobox_desktop/src/stores/field_store.dart';
import 'package:combobox_desktop/src/widgets/field_arrow_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ComboboxField extends StatelessWidget {
  final ComboboxFieldDecoration decoration;
  final ComboboxMenuPosition menuPosition;
  final bool disabled;
  final bool readOnly;

  const ComboboxField({
    super.key,
    required this.decoration,
    required this.menuPosition,
    required this.disabled,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    final store = context.read<FieldStore>();
    final duration = const Duration(milliseconds: 100);
    final effectiveDisabled = disabled || readOnly;

    return Observer(
      builder: (context) {
        return ListenableBuilder(
          listenable: store.focusNode,
          builder: (context, _) {
            bool hasFocus = store.focusNode.hasFocus;
            bool hasError = store.errorText != null;

            // Editable Text
            Widget child = EditableText(
              controller: store.controller,
              focusNode: store.focusNode,
              style: decoration.style ?? TextStyle(),
              selectionColor: hasFocus
                  ? decoration.selectionColor
                  : decoration.selectionUnfocusedColor,
              cursorColor: hasError
                  ? decoration.cursorErrorColor
                  : decoration.cursorColor,
              backgroundCursorColor: decoration.backgroundCursorColor,
              readOnly: effectiveDisabled,
            );

            // Stacking with placeholder text
            child = Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: child,
                ),
                ListenableBuilder(
                  listenable: store.controller,
                  builder: (context, _) {
                    if (effectiveDisabled ||
                        decoration.placeholderText == null ||
                        store.controller.text.isNotEmpty) {
                      return SizedBox();
                    }
                    return Positioned.fill(
                      child: IgnorePointer(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            decoration.placeholderText!,
                            style: decoration.placeholderStyle,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );

            // Decorating with container
            child = AnimatedContainer(
              duration: duration,
              height: decoration.height,
              decoration: BoxDecoration(
                color: _resolveFocusErrorDisabledColor(
                  hasFocus,
                  hasError,
                  disabled,
                  decoration.filledColor,
                  decoration.filledFocusColor,
                  decoration.filledErrorColor,
                  decoration.filledErrorFocusColor,
                  decoration.filledDisabledColor,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: decoration.borderRadius.topLeft,
                  bottomLeft: decoration.borderRadius.bottomLeft,
                ),
                border: Border(
                  top: BorderSide(
                    width: decoration.borderWidth,
                    color: _resolveBorderColor(
                      hasFocus,
                      hasError,
                      disabled,
                    ),
                  ),
                  left: BorderSide(
                    width: decoration.borderWidth,
                    color: _resolveBorderColor(
                      hasFocus,
                      hasError,
                      disabled,
                    ),
                  ),
                  bottom: BorderSide(
                    width: decoration.borderWidth,
                    color: _resolveBorderColor(
                      hasFocus,
                      hasError,
                      disabled,
                    ),
                  ),
                ),
              ),
              padding: decoration.padding,
              child: child,
            );

            // Wrapping for gesture detection and mouse cursor
            child = MouseRegion(
              cursor: SystemMouseCursors.text,
              child: GestureDetector(
                onTap: store.focusNode.requestFocus,
                child: child,
              ),
            );

            // Adding arrow icon
            child = IntrinsicHeight(
              child: Row(
                key: store.fieldKey,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: child,
                  ),
                  FieldArrowIcon(
                    duration: duration,
                    menuPosition: menuPosition,
                    strokeColor: _resolveBorderColor(
                      hasFocus,
                      hasError,
                      disabled,
                    ),
                    fillColor: disabled
                        ? decoration.arrowFillDisabledColor
                        : hasError
                            ? decoration.arrowFillErrorColor
                            : decoration.arrowFillColor,
                    borderWidth: decoration.borderWidth,
                    topRightRadius: decoration.borderRadius.topRight,
                    bottomRightRadius: decoration.borderRadius.bottomRight,
                    onPressed: store.focusNode.requestFocus,
                  ),
                ],
              ),
            );

            // Adding error text
            child = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                child,
                if (store.errorText?.isNotEmpty == true)
                  Text(
                    store.errorText!,
                    style: decoration.errorStyle ??
                        TextStyle(
                          color: Colors.red,
                        ),
                  ),
              ],
            );

            return child;
          },
        );
      },
    );
  }

  Color _resolveBorderColor(bool hasFocus, bool hasError, bool isDisabled) =>
      _resolveFocusErrorDisabledColor(
        hasFocus,
        hasError,
        isDisabled,
        decoration.borderColor,
        decoration.borderFocusColor,
        decoration.borderErrorColor,
        decoration.borderErrorFocusColor,
        decoration.borderDisabledColor,
      );

  Color _resolveFocusErrorDisabledColor(
    bool hasFocus,
    bool hasError,
    bool isDisabled,
    Color color,
    Color focusColor,
    Color errorColor,
    Color errorFocusColor,
    Color disabledColor,
  ) {
    if (isDisabled) {
      return disabledColor;
    } else if (hasFocus && hasError) {
      return errorFocusColor;
    } else if (hasFocus) {
      return focusColor;
    } else if (hasError) {
      return errorColor;
    } else {
      return color;
    }
  }
}
