import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GlucoseService {
  final String _glucoseKey = 'glucose_records';

  Future<List<int>> getGlucoseHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_glucoseKey);
    if (data == null) return [];
    final List<dynamic> list = json.decode(data);
    return list.cast<int>();
  }

  Future<void> addGlucose(int value) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getGlucoseHistory();
    history.add(value);
    await prefs.setString(_glucoseKey, json.encode(history));
  }

  Future<void> deleteGlucoseAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getGlucoseHistory();
    history.removeAt(index);
    await prefs.setString(_glucoseKey, json.encode(history));
  }

  Future<int?> getLatestGlucose() async {
    final history = await getGlucoseHistory();
    if (history.isNotEmpty) {
      return history.last;
    }
    return null;
  }
}
