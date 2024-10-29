import 'package:flutter/material.dart';

class SessionProvider with ChangeNotifier {
  bool _hasSession = false;

  bool get hasSession => _hasSession;

  void setSession(bool hasSession) {
    _hasSession = hasSession;
    notifyListeners();
  }
}
