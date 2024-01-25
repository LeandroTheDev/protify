import 'package:flutter/material.dart';

class ProtifySystem with ChangeNotifier {
  late FocusNode _keyboardFocus;
  get keyboardFocus => _keyboardFocus;
  void declareKeyboardFocus(FocusNode focusNode) {
    _keyboardFocus = focusNode;
  }
}
