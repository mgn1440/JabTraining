import 'package:flutter/material.dart';

class CalendarProvider with ChangeNotifier {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDate => _selectedDate;

  void updateFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void updateSelectedDate(DateTime? day) {
    _selectedDate = day;
    notifyListeners();
  }
}
