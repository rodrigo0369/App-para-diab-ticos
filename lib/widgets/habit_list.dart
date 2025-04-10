import 'package:flutter/material.dart';
import '../services/habit_service.dart';
import '../services/notification_service.dart';

class HabitList extends StatefulWidget {
  final VoidCallback onUpdate;

  const HabitList({required this.onUpdate});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  List<Map<String, dynamic>> habits = [];

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  void loadHabits() async {
    var list = await HabitService().getHabits();
    setState(() {
      habits = list;
    });
  }

  void toggleHabit(int index) async {
    await HabitService().toggleHabitCompletion(index);
    widget.onUpdate();
    loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return ListTile(
          leading: Icon(
            habit['completed'] ? Icons.check_circle : Icons.radio_button_unchecked,
            color: habit['completed'] ? Colors.green : null,
          ),
          title: Text(habit['title']),
          subtitle: habit['hasReminder']
              ? Row(
                  children: const [
                    Icon(Icons.alarm, size: 16),
                    SizedBox(width: 4),
                    Text("Recordatorio activado"),
                  ],
                )
              : null,
          trailing: Switch(
            value: habit['completed'],
            onChanged: (_) => toggleHabit(index),
          ),
        );
      },
    );
  }
}
