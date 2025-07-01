💊 Medication Reminder App
Aplicación móvil desarrollada en Flutter para ayudar a adultos mayores a recordar sus medicamentos mediante notificaciones programadas, una interfaz accesible y funcionalidades básicas de seguimiento.

📌 Enlaces del Proyecto

Repositorio GitHub: https://github.com/tu-usuario/medication-reminder-app


⚙️ Requisitos del Sistema
HerramientaVersión mínimaFlutter3.16.0Dart3.2.0AndroidAPI 21 (5.0)iOSiOS 12.0

🧰 Dependencias Principales
yamldependencies:
flutter:
sdk: flutter
cupertino_icons: ^1.0.2
flutter_local_notifications: ^16.3.0
sqflite: ^2.3.0
shared_preferences: ^2.2.2
intl: ^0.18.1
timezone: ^0.9.2
flutter_launcher_icons: ^0.13.1
path: ^1.8.3
permission_handler: ^11.2.0

🚀 Instrucciones para Levantar el Proyecto
1. Clonar el repositorio
   bashgit clone 
   cd medication-reminder-app
2. Instalar las dependencias
   bashflutter pub get
3. Configurar los íconos
   bashflutter pub run flutter_launcher_icons:main
4. Ejecutar la aplicación
   bashflutter run

📁 Estructura del Proyecto
bashlib/
├── main.dart                      # Punto de entrada
├── models/                        # Modelos de datos (medicamento, historial)
├── screens/                       # Pantallas principales
├── services/                      # Lógica de negocio y notificaciones
├── widgets/                       # Widgets reutilizables
├── utils/                         # Tema, accesibilidad, constantes

🎯 Funcionalidades

📋 Agregar Medicamento: Nombre, dosis, horario
🔔 Notificación: Recordatorio automático hasta confirmar toma
📅 Historial: Registro de tomas y medicamentos olvidados
🧓 Accesibilidad: Texto grande, botones visibles, flujo simple


🧪 Testing
bashflutter test
Pruebas básicas con flutter_test.

📞 Soporte

Email: jonnathancastillochalan@gmail.com
Issues: GitHub Issues


📄 Licencia
Este proyecto está licenciado bajo la Licencia MIT.

👥 Autor
Jonnathan Fabricio Castillo Chalan – Desarrollador Principal
Proyecto de tesis para Universidad Internacional SEK