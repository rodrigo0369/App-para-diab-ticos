import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiabetesTypeScreen extends StatefulWidget {
  @override
  _DiabetesTypeScreenState createState() => _DiabetesTypeScreenState();
}

class _DiabetesTypeScreenState extends State<DiabetesTypeScreen> {
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _loadType();
  }

  Future<void> _loadType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedType = prefs.getString('diabetes_type');
    });
  }

  Future<void> _saveType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diabetes_type', type);
    setState(() {
      _selectedType = type;
    });
    Navigator.pop(context); // Volver atrás después de guardar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tipo de diabetes')),
      body: Column(
        children: [
          RadioListTile(
            title: Text('Tipo 1'),
            value: 'tipo1',
            groupValue: _selectedType,
            onChanged: (value) => _saveType(value as String),
          ),
          RadioListTile(
            title: Text('Tipo 2'),
            value: 'tipo2',
            groupValue: _selectedType,
            onChanged: (value) => _saveType(value as String),
          ),
          RadioListTile(
            title: Text('Gestacional'),
            value: 'gestacional',
            groupValue: _selectedType,
            onChanged: (value) => _saveType(value as String),
          ),
          RadioListTile(
            title: Text('Otro'),
            value: 'otro',
            groupValue: _selectedType,
            onChanged: (value) => _saveType(value as String),
          ),
        ],
      ),
    );
  }
}
