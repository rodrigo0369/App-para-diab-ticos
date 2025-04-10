import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HabitService {
  final String _habitKey = 'habits';
  final String _lastResetKey = 'last_reset';

  Future<List<Map<String, dynamic>>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsString = prefs.getString(_habitKey);
    if (habitsString == null) return [];

    final List decoded = json.decode(habitsString);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> saveHabits(List<Map<String, dynamic>> habits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_habitKey, json.encode(habits));
  }

  Future<void> toggleHabitCompletion(int index) async {
    final habits = await getHabits();
    habits[index]['completed'] = !(habits[index]['completed'] ?? false);
    await saveHabits(habits);
  }

  Future<int> getCompletedToday() async {
    final habits = await getHabits();
    return habits.where((h) => h['completed'] == true).length;
  }

  Future<void> resetDailyCounterIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final lastReset = prefs.getString(_lastResetKey);

    if (lastReset != null) {
      final lastDate = DateTime.parse(lastReset);
      if (now.difference(lastDate).inDays >= 1) {
        await _resetHabits();
        await prefs.setString(_lastResetKey, now.toIso8601String());
      }
    } else {
      await prefs.setString(_lastResetKey, now.toIso8601String());
    }
  }

  Future<void> _resetHabits() async {
    final habits = await getHabits();
    for (var habit in habits) {
      habit['completed'] = false;
    }
    await saveHabits(habits);
  }
}
