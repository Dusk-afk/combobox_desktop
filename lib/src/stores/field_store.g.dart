// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FieldStore<T> on _FieldStore<T>, Store {
  late final _$controllerAtom =
      Atom(name: '_FieldStore.controller', context: context);

  @override
  TextEditingController get controller {
    _$controllerAtom.reportRead();
    return super.controller;
  }

  bool _controllerIsInitialized = false;

  @override
  set controller(TextEditingController value) {
    _$controllerAtom.reportWrite(
        value, _controllerIsInitialized ? super.controller : null, () {
      super.controller = value;
      _controllerIsInitialized = true;
    });
  }

  late final _$focusNodeAtom =
      Atom(name: '_FieldStore.focusNode', context: context);

  @override
  FocusNode get focusNode {
    _$focusNodeAtom.reportRead();
    return super.focusNode;
  }

  bool _focusNodeIsInitialized = false;

  @override
  set focusNode(FocusNode value) {
    _$focusNodeAtom.reportWrite(
        value, _focusNodeIsInitialized ? super.focusNode : null, () {
      super.focusNode = value;
      _focusNodeIsInitialized = true;
    });
  }

  late final _$itemAtom = Atom(name: '_FieldStore.item', context: context);

  @override
  T? get item {
    _$itemAtom.reportRead();
    return super.item;
  }

  @override
  set item(T? value) {
    _$itemAtom.reportWrite(value, super.item, () {
      super.item = value;
    });
  }

  late final _$errorTextAtom =
      Atom(name: '_FieldStore.errorText', context: context);

  @override
  String? get errorText {
    _$errorTextAtom.reportRead();
    return super.errorText;
  }

  @override
  set errorText(String? value) {
    _$errorTextAtom.reportWrite(value, super.errorText, () {
      super.errorText = value;
    });
  }

  late final _$fieldKeyAtom =
      Atom(name: '_FieldStore.fieldKey', context: context);

  @override
  GlobalKey<State<StatefulWidget>> get fieldKey {
    _$fieldKeyAtom.reportRead();
    return super.fieldKey;
  }

  @override
  set fieldKey(GlobalKey<State<StatefulWidget>> value) {
    _$fieldKeyAtom.reportWrite(value, super.fieldKey, () {
      super.fieldKey = value;
    });
  }

  @override
  String toString() {
    return '''
controller: ${controller},
focusNode: ${focusNode},
item: ${item},
errorText: ${errorText},
fieldKey: ${fieldKey}
    ''';
  }
}
