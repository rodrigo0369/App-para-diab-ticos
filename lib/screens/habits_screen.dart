import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:diabetes_habits_app/services/notifications_service.dart';

class HabitsScreen extends StatefulWidget {
  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final _habitController = TextEditingController();
  TimeOfDay? _selectedTime;
  List<Map<String, dynamic>> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsData = prefs.getString('habits');
    if (habitsData != null) {
      setState(() {
        _habits = List<Map<String, dynamic>>.from(json.decode(habitsData));
      });
    }
  }

  Future<void> _saveHabitsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('habits', json.encode(_habits));
  }

  Future<void> _saveHabit() async {
    final name = _habitController.text.trim();
    if (name.isEmpty) return;

    final time = _selectedTime ?? TimeOfDay.now();
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    final newHabit = {
      'id': id,
      'name': name,
      'hour': time.hour,
      'minute': time.minute,
    };

    setState(() {
      _habits.add(newHabit);
    });

    await _saveHabitsToStorage();

    if (_selectedTime != null) {
      await NotificationsService.scheduleDailyNotification(
        id: id,
        title: 'Recordatorio de hábito',
        body: 'No olvides completar tu hábito: $name',
        hour: time.hour,
        minute: time.minute,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hábito "$name" guardado.')),
    );

    _habitController.clear();
    setState(() => _selectedTime = null);
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _deleteHabit(int index) async {
    final habit = _habits[index];
    final id = habit['id'];

    await NotificationsService.cancelNotification(id);

    setState(() {
      _habits.removeAt(index);
    });

    await _saveHabitsToStorage();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hábito eliminado.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _selectedTime != null
        ? _selectedTime!.format(context)
        : 'Sin hora';

    return Scaffold(
      appBar: AppBar(title: Text('Hábitos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _habitController,
              decoration: InputDecoration(labelText: 'Nombre del hábito'),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickTime,
                  icon: Icon(Icons.access_time),
                  label: Text('Elegir hora'),
                ),
                SizedBox(width: 10),
                Text('Hora: $formattedTime'),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveHabit,
              child: Text('Guardar hábito'),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _habits.length,
                itemBuilder: (context, index) {
                  final habit = _habits[index];
                  final time = TimeOfDay(hour: habit['hour'], minute: habit['minute']);
                  return ListTile(
                    title: Text(habit['name']),
                    subtitle: Text('Hora: ${time.format(context)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteHabit(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
