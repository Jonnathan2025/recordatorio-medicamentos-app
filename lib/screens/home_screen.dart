import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import '../models/medication.dart';
import '../services/medication_service.dart';
import '../services/notification_service.dart';
import 'add_medication_screen.dart';
import 'medication_list_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MedicationService _medicationService = MedicationService();
  final NotificationService _notificationService = NotificationService();
  List<Medication> _todayMedications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayMedications();
  }

  Future<void> _loadTodayMedications() async {
    try {
      final medications = await _medicationService.getTodayMedications();
      setState(() {
        _todayMedications = medications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error al cargar medicamentos: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _markMedicationAsTaken(Medication medication) async {
    try {
      await _medicationService.markAsTaken(medication.id, DateTime.now());
      await _loadTodayMedications(); // Recargar la lista

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${medication.name} marcado como tomado'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      _showErrorDialog('Error al marcar medicamento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Recordatorio de Medicamentos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTodayMedications,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saludo y fecha
              _buildWelcomeSection(),
              const SizedBox(height: 24),

              // Botones de acción principales
              _buildActionButtons(),
              const SizedBox(height: 24),

              // Medicamentos de hoy
              _buildTodayMedicationsSection(),
              const SizedBox(height: 24),

              // Estadísticas rápidas
              _buildQuickStats(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMedicationScreen()),
          ).then((_) => _loadTodayMedications());
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add, size: 24),
        label: const Text(
          'Agregar',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final now = DateTime.now();
    final greeting = _getGreeting();
    final dateString = _formatDate(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getGreetingIcon(),
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            dateString,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: PrimaryActionButton(
            text: 'Ver Todos',
            icon: Icons.list_alt,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MedicationListScreen()),
              ).then((_) => _loadTodayMedications());
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryActionButton(
            text: 'Agregar',
            icon: Icons.add_circle,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddMedicationScreen()),
              ).then((_) => _loadTodayMedications());
            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayMedicationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.today,
              size: 28,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            const Text(
              'Medicamentos de Hoy',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_todayMedications.isEmpty)
          _buildEmptyState()
        else
          ..._todayMedications.map((medication) =>
              _buildMedicationCard(medication),
          ).toList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.medication_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes medicamentos programados para hoy',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Toca "Agregar" para añadir tu primer medicamento',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(Medication medication) {
    final nextDose = _getNextDose(medication);
    final isOverdue = nextDose != null && nextDose.isBefore(DateTime.now());
    final wasTaken = _wasTakenToday(medication);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: wasTaken
              ? Colors.green.withOpacity(0.3)
              : isOverdue
              ? Colors.red.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: wasTaken
                        ? Colors.green.withOpacity(0.1)
                        : isOverdue
                        ? Colors.red.withOpacity(0.1)
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    wasTaken
                        ? Icons.check_circle
                        : isOverdue
                        ? Icons.warning
                        : Icons.medication,
                    color: wasTaken
                        ? Colors.green
                        : isOverdue
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${medication.dosage} ${medication.unit}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (nextDose != null && !wasTaken) ...[
              Row(
                children: [
                  Icon(
                    isOverdue ? Icons.schedule : Icons.access_time,
                    size: 16,
                    color: isOverdue ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isOverdue
                        ? 'Atrasado desde ${_formatTime(nextDose)}'
                        : 'Próxima dosis: ${_formatTime(nextDose)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isOverdue ? Colors.red : Colors.grey[600],
                      fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            if (wasTaken)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Tomado hoy',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _markMedicationAsTaken(medication),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOverdue ? Colors.red : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 20),
                  label: Text(
                    isOverdue ? 'Marcar como Tomado (Atrasado)' : 'Marcar como Tomado',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final totalMedications = _todayMedications.length;
    final takenMedications = _todayMedications.where(_wasTakenToday).length;
    final overdueMedications = _todayMedications.where((med) {
      final nextDose = _getNextDose(med);
      return nextDose != null &&
          nextDose.isBefore(DateTime.now()) &&
          !_wasTakenToday(med);
    }).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                size: 24,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              const Text(
                'Resumen de Hoy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  totalMedications.toString(),
                  Icons.medication,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Tomados',
                  takenMedications.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Atrasados',
                  overdueMedications.toString(),
                  Icons.warning,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 18) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny;
    if (hour < 18) return Icons.wb_sunny_outlined;
    return Icons.nightlight_round;
  }

  String _formatDate(DateTime date) {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    final weekdays = [
      'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'
    ];

    return '${weekdays[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  DateTime? _getNextDose(Medication medication) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final timeString in medication.schedule) {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final doseTime = today.add(Duration(hours: hour, minutes: minute));

      if (doseTime.isAfter(now)) {
        return doseTime;
      }
    }
    return null;
  }

  bool _wasTakenToday(Medication medication) {
    final today = DateTime.now();
    return medication.takenDates.any((date) =>
    date.year == today.year &&
        date.month == today.month &&
        date.day == today.day
    );
  }
}