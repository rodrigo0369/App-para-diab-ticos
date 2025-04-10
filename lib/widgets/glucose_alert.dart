import 'package:flutter/material.dart';
import '../services/glucose_service.dart';

class GlucoseAlert extends StatefulWidget {
  @override
  State<GlucoseAlert> createState() => _GlucoseAlertState();
}

class _GlucoseAlertState extends State<GlucoseAlert> {
  String? alertMessage;

  @override
  void initState() {
    super.initState();
    checkGlucose();
  }

  void checkGlucose() async {
    final latest = await GlucoseService().getLatestGlucose();
    if (latest != null) {
      if (latest < 70) {
        setState(() {
          alertMessage = '¡Alerta! Glucosa baja: $latest mg/dL';
        });
      } else if (latest > 180) {
        setState(() {
          alertMessage = '¡Alerta! Glucosa alta: $latest mg/dL';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (alertMessage == null) return SizedBox.shrink();

    return Container(
      color: Colors.red.shade100,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              alertMessage!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                alertMessage = null;
              });
            },
          )
        ],
      ),
    );
  }
}
