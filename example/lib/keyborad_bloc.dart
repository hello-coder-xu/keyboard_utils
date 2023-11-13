import 'dart:async';

import 'package:keyboard_utils_fork/keyboard_utils.dart';
import 'package:keyboard_utils_fork/keyboard_listener.dart'
    as keyboard_listener;

// Sample Bloc
class KeyboardBloc {
  KeyboardUtils _keyboardUtils = KeyboardUtils();
  StreamController<double> _streamController = StreamController<double>();

  Stream<double> get stream => _streamController.stream;

  KeyboardUtils get keyboardUtils => _keyboardUtils;

  int _idKeyboardListener;

  void start() {
    _idKeyboardListener = _keyboardUtils.add(
        listener: keyboard_listener.KeyboardListener(willHideKeyboard: () {
      _streamController.sink.add(_keyboardUtils.keyboardHeight);
    }, willShowKeyboard: (double keyboardHeight) {
      _streamController.sink.add(keyboardHeight);
    }));
  }

  void dispose() {
    _keyboardUtils.unsubscribeListener(subscribingId: _idKeyboardListener);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    }
    _streamController.close();
  }
}
