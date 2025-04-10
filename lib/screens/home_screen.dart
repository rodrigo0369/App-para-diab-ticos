import 'package:flutter/material.dart';
import 'glucose_screen.dart';
import 'habits_screen.dart';
import 'settings_screen.dart';
import 'country_selection_screen.dart';
import 'recommendations_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diabetes Habits App'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GlucoseScreen()),
            ),
            child: Text('Registrar Glucosa'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HabitsScreen()),
            ),
            child: Text('Hábitos Diarios'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsScreen()),
            ),
            child: Text('Configuración'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CountrySelectionScreen()),
            ),
            child: Text('Seleccionar País'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RecommendationsScreen()),
            ),
            child: Text('Ver Recomendaciones'),
          ),
        ],
      ),
    );
  }
}
