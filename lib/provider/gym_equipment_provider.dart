import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GymEquipmentsProvider extends ChangeNotifier {
  static const String _lastFetchKey = 'lastFetchTime';
  static const String _equipmentsDataKey = 'equipmentsData';
  final SupabaseClient supabase;

  GymEquipmentsProvider(this.supabase);

  Future<void> saveLastFetchTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastFetchKey, DateTime.now().toIso8601String());
  }

  Future<DateTime?> getLastFetchTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastFetchTime = prefs.getString(_lastFetchKey);
    if (lastFetchTime != null) {
      return DateTime.parse(lastFetchTime);
    }
    return null;
  }

  Future<void> saveEquipmentsData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_equipmentsDataKey, data);
  }

  Future<void> fetchAndSaveEquipmentsData(int locationId) async {
    final response = await supabase.from('equipments').select('*');
    final data = jsonEncode(response);
    await saveEquipmentsData(data);
    await saveLastFetchTime();
  }

  Future<List<dynamic>> getEquipmentsData(int locationId) async {
    // final lastFetchTime = await getLastFetchTime();
    // final now = DateTime.now();

    // if (lastFetchTime == null || now.difference(lastFetchTime).inDays >= 1) {
    await fetchAndSaveEquipmentsData(locationId);
    // }

    final prefs = await SharedPreferences.getInstance();
    final equipmentsData = prefs.getString(_equipmentsDataKey);
    if (equipmentsData != null) {
      return jsonDecode(equipmentsData);
    }

    return [];
  }
}
