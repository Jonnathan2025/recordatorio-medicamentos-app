import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final NotificationService _notificationService = NotificationService();

  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _stockLowNotifications = true;
  bool _reminderNotifications = true;
  int _reminderDelayMinutes = 15;

  final List<int> _reminderOptions = [5, 10, 15, 30, 60];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Cargar configuraciones guardadas
    final enabled = await _notificationService.areNotificationsEnabled();
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  Future<void> _requestPermissions() async {
    final granted = await _notificationService.requestPermissions();

    if (mounted) {
      setState(() {
        _notificationsEnabled = granted;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            granted
                ? '✅ Permisos de notificación concedidos'
                : '❌ Permisos de notificación denegados',
          ),
          backgroundColor: granted ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _testNotification() async {
    await _notificationService.showTestNotification();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔔 Notificación de prueba enviada'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🔔 Configuración de Notificaciones',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado de las notificaciones
            _buildStatusCard(),

            const SizedBox(height: 20),

            // Configuraciones generales
            _buildGeneralSettings(),

            const SizedBox(height: 20),

            // Configuraciones de recordatorios
            _buildReminderSettings(),

            const SizedBox(height: 20),

            // Botones de acción
            _buildActionButtons(),

            const Spacer(),

            // Información adicional
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado de las Notificaciones',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  _notificationsEnabled ? Icons.check_circle : Icons.cancel,
                  color: _notificationsEnabled ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  _notificationsEnabled
                      ? 'Notificaciones habilitadas'
                      : 'Notificaciones deshabilitadas',
                  style: TextStyle(
                    color: _notificationsEnabled ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (!_notificationsEnabled) ...[
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _requestPermissions,
                icon: const Icon(Icons.notifications_active),
                label: const Text('Habilitar Notificaciones'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuración General',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Sonido
            SwitchListTile(
              title: const Text(
                '🔊 Sonido',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: const Text('Reproducir sonido con las notificaciones'),
              value: _soundEnabled,
              onChanged: _notificationsEnabled ? (value) {
                setState(() {
                  _soundEnabled = value;
                });
              } : null,
              activeColor: Theme.of(context).primaryColor,
            ),

            // Vibración
            SwitchListTile(
              title: const Text(
                '📳 Vibración',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: const Text('Vibrar al recibir notificaciones'),
              value: _vibrationEnabled,
              onChanged: _notificationsEnabled ? (value) {
                setState(() {
                  _vibrationEnabled = value;
                });
              } : null,
              activeColor: Theme.of(context).primaryColor,
            ),

            // Notificaciones de stock bajo
            SwitchListTile(
              title: const Text(
                '⚠️ Stock Bajo',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: const Text('Avisar cuando queden pocos medicamentos'),
              value: _stockLowNotifications,
              onChanged: _notificationsEnabled ? (value) {
                setState(() {
                  _stockLowNotifications = value;
                });
              } : null,
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderSettings() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recordatorios',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Habilitar recordatorios
            SwitchListTile(
              title: const Text(
                '🔔 Recordatorios Adicionales',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: const Text('Enviar recordatorio si no marcas como tomado'),
              value: _reminderNotifications,
              onChanged: _notificationsEnabled ? (value) {
                setState(() {
                  _reminderNotifications = value;
                });
              } : null,
              activeColor: Theme.of(context).primaryColor,
            ),

            if (_reminderNotifications) ...[
              const SizedBox(height: 10),
              Text(
                'Tiempo de recordatorio:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _reminderOptions.map((minutes) {
                  final isSelected = _reminderDelayMinutes == minutes;
                  return ChoiceChip(
                    label: Text('$minutes min'),
                    selected: isSelected,
                    onSelected: _notificationsEnabled ? (selected) {
                      if (selected) {
                        setState(() {
                          _reminderDelayMinutes = minutes;
                        });
                      }
                    } : null,
                    selectedColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Botón de prueba
        ElevatedButton.icon(
          onPressed: _notificationsEnabled ? _testNotification : null,
          icon: const Icon(Icons.notifications_active),
          label: const Text('Probar Notificación'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 50),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),

        const SizedBox(height: 10),

        // Botón para cancelar todas
        ElevatedButton.icon(
          onPressed: _notificationsEnabled ? () async {
            await _notificationService.cancelAllNotifications();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🗑️ Todas las notificaciones canceladas'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          } : null,
          icon: const Icon(Icons.clear_all),
          label: const Text('Cancelar Todas las Notificaciones'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 50),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Información',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '• Las notificaciones se repiten automáticamente todos los días\n'
                  '• Puedes personalizar el sonido desde la configuración del sistema\n'
                  '• Los recordatorios solo se envían si no marcas el medicamento como tomado\n'
                  '• Las notificaciones de stock bajo aparecen cuando quedan pocas unidades',
              style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}