import 'package:flutter/material.dart';
import '../widgets/habit_list.dart';
import '../widgets/glucose_alert.dart';
import '../services/habit_service.dart';
import '../services/glucose_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int completedToday = 0;

  @override
  void initState() {
    super.initState();
    HabitService().resetDailyCounterIfNeeded();
    updateCompletedHabits();
  }

  void updateCompletedHabits() async {
    int count = await HabitService().getCompletedToday();
    setState(() {
      completedToday = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DiabetesHabitsApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings').then((_) {
                setState(() {});
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          GlucoseAlert(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Hábitos completados hoy: $completedToday',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: HabitList(onUpdate: updateCompletedHabits),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/glucose');
        },
        child: const Icon(Icons.add),
        tooltip: 'Registrar glucosa',
      ),
    );
  }
}
