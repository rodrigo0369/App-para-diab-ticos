import 'package:flutter/material.dart';
import '../services/glucose_service.dart';

class GlucoseScreen extends StatefulWidget {
  const GlucoseScreen({Key? key}) : super(key: key);

  @override
  State<GlucoseScreen> createState() => _GlucoseScreenState();
}

class _GlucoseScreenState extends State<GlucoseScreen> {
  final TextEditingController _controller = TextEditingController();
  List<int> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() async {
    final data = await GlucoseService().getGlucoseHistory();
    setState(() {
      history = data;
    });
  }

  void addGlucose() async {
    final value = int.tryParse(_controller.text);
    if (value != null) {
      await GlucoseService().addGlucose(value);
      _controller.clear();
      loadHistory();
    }
  }

  void deleteGlucose(int index) async {
    await GlucoseService().deleteGlucoseAt(index);
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Glucosa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nivel de glucosa (mg/dL)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addGlucose,
              child: const Text('Agregar'),
            ),
            const SizedBox(height: 20),
            const Text('Historial:', style: TextStyle(fontSize: 16)),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final value = history[index];
                  return ListTile(
                    title: Text('$value mg/dL'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteGlucose(index),
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
