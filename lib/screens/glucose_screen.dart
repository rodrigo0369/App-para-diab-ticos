import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GlucoseScreen extends StatefulWidget {
  @override
  _GlucoseScreenState createState() => _GlucoseScreenState();
}

class _GlucoseScreenState extends State<GlucoseScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _glucoseHistory = [];
  String? _alertMessage;

  @override
  void initState() {
    super.initState();
    _loadGlucoseHistory();
  }

  void _loadGlucoseHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('glucose_history');
    if (data != null) {
      setState(() {
        _glucoseHistory = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  void _saveGlucoseHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('glucose_history', json.encode(_glucoseHistory));
  }

  void _addGlucoseReading() {
    final String text = _controller.text;
    if (text.isNotEmpty) {
      final int value = int.tryParse(text) ?? 0;
      final reading = {
        'value': value,
        'timestamp': DateTime.now().toIso8601String(),
      };
      setState(() {
        _glucoseHistory.insert(0, reading);
        _controller.clear();
        _checkAlert(value);
      });
      _saveGlucoseHistory();
    }
  }

  void _checkAlert(int value) {
    if (value < 70) {
      _alertMessage = '¡Glucosa muy baja!';
    } else if (value > 180) {
      _alertMessage = '¡Glucosa muy alta!';
    } else {
      _alertMessage = null;
    }
  }

  void _removeReading(int index) {
    setState(() {
      _glucoseHistory.removeAt(index);
    });
    _saveGlucoseHistory();
  }

  void _dismissAlert() {
    setState(() {
      _alertMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Glucosa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_alertMessage != null)
              Container(
                color: Colors.red[100],
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(_alertMessage!, style: TextStyle(color: Colors.red))),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: _dismissAlert,
                    ),
                  ],
                ),
              ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nivel de glucosa (mg/dL)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addGlucoseReading,
              child: Text('Guardar'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _glucoseHistory.length,
                itemBuilder: (context, index) {
                  final reading = _glucoseHistory[index];
                  final value = reading['value'];
                  final timestamp = DateTime.parse(reading['timestamp']);
                  return ListTile(
                    title: Text('Glucosa: $value mg/dL'),
                    subtitle: Text('Registrado: ${timestamp.toLocal()}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeReading(index),
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
