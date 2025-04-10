import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0); // Por defecto 09:00

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('notification_hour') ?? 9;
    final minute = prefs.getInt('notification_minute') ?? 0;
    setState(() {
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_hour', _selectedTime.hour);
    await prefs.setInt('notification_minute', _selectedTime.minute);

    final message = 'No olvides registrar tu nivel de glucosa hoy';
    await NotificationService().scheduleDailyReminder(_selectedTime, message);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuración guardada')),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _selectedTime.format(context);

    return Scaffold(
      appBar: AppBar(title: Text('Configuración')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Hora de notificación inteligente'),
              subtitle: Text(formattedTime),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
