import 'package:flutter/material.dart';
import 'package:jab_training/main.dart';

class SessionProvider with ChangeNotifier {
  bool _hasSession = supabase.auth.currentSession != null;

  bool get hasSession => _hasSession;

  void setSession(bool hasSession) {
    _hasSession = hasSession;
    notifyListeners();
  }
}
