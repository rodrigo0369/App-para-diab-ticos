import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/language_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'es';
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'es';
      final hour = prefs.getInt('reminder_hour') ?? 8;
      final minute = prefs.getInt('reminder_minute') ?? 0;
      _reminderTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _selectedLanguage);
    await prefs.setInt('reminder_hour', _reminderTime.hour);
    await prefs.setInt('reminder_minute', _reminderTime.minute);
    Navigator.pop(context);
  }

  Future<void> selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = LanguageConstants.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'es', child: Text('Español')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Idioma',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Hora del recordatorio:'),
                const SizedBox(width: 10),
                Text('${_reminderTime.format(context)}'),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: selectTime,
                  child: const Text('Cambiar'),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: saveSettings,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
