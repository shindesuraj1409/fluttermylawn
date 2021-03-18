import 'package:flutter/widgets.dart';

/// Creation and automatic disposal of focus nodes and text editing controllers.
mixin TextEditingMixin<T extends StatefulWidget> on State<T> {
  final Map<String, TextEditingController> _textEditingControllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void dispose() {
    _textEditingControllers.values.forEach((tec) => tec.dispose());
    _textEditingControllers.clear();
    _focusNodes.values.forEach((fn) => fn.dispose());
    _focusNodes.clear();

    super.dispose();
  }

  /// Returns a [TextEditingController] by name, creating it if necessary.
  /// The text editing controller will be automatically disposed of.
  TextEditingController getTextEditingController(String name) =>
      _textEditingControllers.putIfAbsent(name, () => TextEditingController());

  /// Returns a [FocusNode] by name, creating it if necessary.
  /// The focus node will be automatically disposed of.
  FocusNode getFocusNode(String name) =>
      _focusNodes.putIfAbsent(name, () => FocusNode());
}
