import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountrySelectionScreen extends StatefulWidget {
  @override
  _CountrySelectionScreenState createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _loadCountry();
  }

  Future<void> _loadCountry() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCountry = prefs.getString('selected_country');
    });
  }

  Future<void> _saveCountry(String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_country', country);
    setState(() {
      _selectedCountry = country;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seleccionar país')),
      body: ListView(
        children: [
          RadioListTile(
            title: Text('Argentina'),
            value: 'argentina',
            groupValue: _selectedCountry,
            onChanged: (value) => _saveCountry(value as String),
          ),
          RadioListTile(
            title: Text('México'),
            value: 'mexico',
            groupValue: _selectedCountry,
            onChanged: (value) => _saveCountry(value as String),
          ),
          RadioListTile(
            title: Text('España'),
            value: 'espana',
            groupValue: _selectedCountry,
            onChanged: (value) => _saveCountry(value as String),
          ),
          RadioListTile(
            title: Text('Otro'),
            value: 'otro',
            groupValue: _selectedCountry,
            onChanged: (value) => _saveCountry(value as String),
          ),
        ],
      ),
    );
  }
}
