import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  String _currentLocation = '';
  int _currentLocationId = 0;

  String get currentLocation => _currentLocation;
  int get currentLocationId => _currentLocationId;

  final List<Map<String, dynamic>> _gymLocations = [
    {'id': 1, 'name': 'Jab Training 교대점'},
    {'id': 2, 'name': 'Jab Training 역삼점'},
    {'id': 3, 'name': 'Jab Training 선릉점'},
  ];

  Future<void> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentLocation =
        prefs.getString('centerName') ?? _gymLocations[0]['name'];
    _currentLocationId = _gymLocations
            .firstWhere((loc) => loc['name'] == _currentLocation)['id'] ??
        1;
    notifyListeners();
  }

  void updateCurrentLocation(String location) {
    _currentLocation = location;
    _currentLocationId =
        _gymLocations.firstWhere((loc) => loc['name'] == location)['id'];
    notifyListeners();
  }
}
