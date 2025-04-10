import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendationsScreen extends StatefulWidget {
  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  String? diabetesType;
  String? country;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      diabetesType = prefs.getString('diabetes_type') ?? 'tipo1';
      country = prefs.getString('selected_country') ?? 'argentina';
    });
  }

  List<String> getRecommendations() {
    if (country == null || diabetesType == null) return [];

    if (country == 'argentina') {
      if (diabetesType == 'tipo1') {
        return ['Evitá azúcares simples', 'Consumí frutas con moderación', 'Incluí proteínas magras'];
      } else if (diabetesType == 'tipo2') {
        return ['Preferí cereales integrales', 'Caminatas diarias de 30 min', 'Reducí grasas saturadas'];
      }
    } else if (country == 'mexico') {
      if (diabetesType == 'tipo1') {
        return ['Evita refrescos azucarados', 'Consume tortillas integrales', 'Controla tus porciones'];
      } else if (diabetesType == 'tipo2') {
        return ['Camina después de comer', 'Consume nopales y legumbres', 'Evita frituras'];
      }
    } else if (country == 'espana') {
      if (diabetesType == 'tipo1') {
        return ['Evita bollería industrial', 'Come pescado azul', 'Haz 5 comidas pequeñas'];
      } else if (diabetesType == 'tipo2') {
        return ['Dieta mediterránea balanceada', 'Frutas como manzana y pera', 'Ejercicio regular'];
      }
    }

    return ['Consulta con tu nutricionista', 'Llevá un control diario de glucosa'];
  }

  @override
  Widget build(BuildContext context) {
    final recomendaciones = getRecommendations();

    return Scaffold(
      appBar: AppBar(title: Text('Recomendaciones')),
      body: ListView.builder(
        itemCount: recomendaciones.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text(recomendaciones[index]),
          );
        },
      ),
    );
  }
}
