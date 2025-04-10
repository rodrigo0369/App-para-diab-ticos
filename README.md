# DiabetesHabitsApp

**DiabetesHabitsApp** es una aplicación Flutter pensada para personas con diabetes tipo 1 y tipo 2, que ayuda a formar hábitos saludables, registrar niveles de glucosa y recibir recordatorios y recomendaciones personalizadas según el país.

## Funciones principales

- Registro de niveles de glucosa con historial y alertas por valores anormales
- Hábitos personalizados con recordatorios diarios
- Notificaciones inteligentes si no se registra glucosa en el día
- Configuración del horario de notificación
- Selección de tipo de diabetes (tipo 1 o tipo 2)
- Recomendaciones de hábitos y comidas según el país (Argentina, México, España)
- Interfaz en español e inglés
- Almacenamiento local con `shared_preferences`
- Notificaciones con `flutter_local_notifications`

## Estructura del proyecto

lib/ ├── main.dart ├── services/ │   └── notification_service.dart ├── screens/ │   ├── home_screen.dart │   ├── glucose_screen.dart │   ├── settings_screen.dart │   ├── diabetes_type_screen.dart │   ├── habits_screen.dart │   ├── country_selection_screen.dart │   └── recommendations_screen.dart

## Instalación manual

1. Cloná este repositorio
2. Ejecutá:

flutter pub get flutter run

## Compilación con Codemagic

El archivo `codemagic.yaml` permite compilar automáticamente el APK:

flutter build apk --release

Codemagic generará el APK en:  
`build/app/outputs/flutter-apk/app-release.apk`

## Créditos

App desarrollada por un usuario con una mamá con diabetes tipo 1, con enfoque en ayudar a otros a través de la tecnología. Código guiado y asistido por ChatGPT con integración completa.


