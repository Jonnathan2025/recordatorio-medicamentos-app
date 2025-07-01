import 'package:flutter/material.dart';

void main() {
  runApp(const RecordatorioMedicamentosApp());
}

class RecordatorioMedicamentosApp extends StatelessWidget {
  const RecordatorioMedicamentosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recordatorio de Medicamentos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos días';
    } else if (hour < 18) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Medicamentos'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo personalizado
            Text(
              _getGreeting(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Es hora de cuidar tu salud',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Tarjetas de resumen
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Medicamentos',
                    '5',
                    Icons.medication,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Hoy',
                    '3',
                    Icons.today,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Tomados',
                    '1',
                    Icons.check_circle,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Sección de próximos medicamentos
            Text(
              'Próximos Medicamentos',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            // Lista de próximos medicamentos (placeholder)
            _buildMedicationCard(
              context,
              'Aspirina',
              '100mg',
              '2:00 PM',
              Colors.red[100]!,
            ),
            const SizedBox(height: 12),
            _buildMedicationCard(
              context,
              'Vitamina D',
              '1000 UI',
              '6:00 PM',
              Colors.yellow[100]!,
            ),
            const SizedBox(height: 32),

            // Botones de acción rápida
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Ver Todos',
                    Icons.list,
                        () => _navigateToAllMedications(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Historial',
                    Icons.history,
                        () => _navigateToHistory(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Configurar',
                    Icons.settings,
                        () => _navigateToSettings(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddMedication(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar Medicamento'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationCard(
      BuildContext context,
      String name,
      String dose,
      String time,
      Color backgroundColor,
      ) {
    return Card(
      color: backgroundColor,
      child: ListTile(
        leading: const Icon(Icons.medication, size: 32),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text('$dose • $time'),
        trailing: IconButton(
          icon: const Icon(Icons.check_circle_outline),
          onPressed: () {
            // Marcar como tomado
          },
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context,
      String label,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _navigateToAllMedications(BuildContext context) {
    // Navegación a la pantalla de todos los medicamentos
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando a todos los medicamentos...')),
    );
  }

  void _navigateToHistory(BuildContext context) {
    // Navegación al historial
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando al historial...')),
    );
  }

  void _navigateToSettings(BuildContext context) {
    // Navegación a configuración
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando a configuración...')),
    );
  }

  void _navigateToAddMedication(BuildContext context) {
    // Navegación para agregar medicamento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agregando nuevo medicamento...')),
    );
  }
}