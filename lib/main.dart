import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:diabetes_habits_app/screens/home_screen.dart';
import 'package:diabetes_habits_app/screens/glucose_screen.dart';
import 'package:diabetes_habits_app/screens/habits_screen.dart';
import 'package:diabetes_habits_app/screens/settings_screen.dart';
import 'package:diabetes_habits_app/screens/country_selection_screen.dart';
import 'package:diabetes_habits_app/screens/diabetes_type_screen.dart';
import 'package:diabetes_habits_app/screens/recommendations_screen.dart';
import 'package:diabetes_habits_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // Inicializar notificaciones
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
int? hour = prefs.getInt('notification_hour');
int? minute = prefs.getInt('notification_minute');

if (hour != null && minute != null) {
  await scheduleDailyReminder(
    TimeOfDay(hour: hour, minute: minute),
    'No olvides registrar tu nivel de glucosa hoy.',
  );
}
  runApp(const DiabetesHabitsApp());
}

class DiabetesHabitsApp extends StatelessWidget {
  const DiabetesHabitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes Habits App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/glucose': (context) => const GlucoseScreen(),
        '/habits': (context) => const HabitsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/country': (context) => const CountrySelectionScreen(),
        '/diabetes': (context) => const DiabetesTypeScreen(),
        '/recommendations': (context) => const RecommendationsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
