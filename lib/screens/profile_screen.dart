import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../widgets/custom_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SettingsService _settingsService = SettingsService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();

  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkMode = false;
  double _fontSize = 16.0;
  String _userName = '';
  String _emergencyContact = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsService.getSettings();
    setState(() {
      _soundEnabled = settings['soundEnabled'] ?? true;
      _vibrationEnabled = settings['vibrationEnabled'] ?? true;
      _darkMode = settings['darkMode'] ?? false;
      _fontSize = settings['fontSize'] ?? 16.0;
      _userName = settings['userName'] ?? '';
      _emergencyContact = settings['emergencyContact'] ?? '';

      _nameController.text = _userName;
      _emergencyContactController.text = _emergencyContact;
    });
  }

  Future<void> _saveSettings() async {
    await _settingsService.updateSettings({
      'soundEnabled': _soundEnabled,
      'vibrationEnabled': _vibrationEnabled,
      'darkMode': _darkMode,
      'fontSize': _fontSize,
      'userName': _nameController.text,
      'emergencyContact': _emergencyContactController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración guardada exitosamente'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de información personal
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: const Color(0xFF4CAF50),
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Información Personal',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      style: TextStyle(fontSize: _fontSize),
                      decoration: InputDecoration(
                        labelText: 'Nombre completo',
                        labelStyle: TextStyle(fontSize: _fontSize),
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF4CAF50),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emergencyContactController,
                      style: TextStyle(fontSize: _fontSize),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Contacto de emergencia',
                        labelStyle: TextStyle(fontSize: _fontSize),
                        prefixIcon: const Icon(Icons.emergency),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF4CAF50),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sección de notificaciones
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: const Color(0xFF4CAF50),
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Notificaciones',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SwitchListTile(
                      title: Text(
                        'Sonido',
                        style: TextStyle(
                          fontSize: _fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Reproducir sonido con las notificaciones',
                        style: TextStyle(fontSize: _fontSize - 2),
                      ),
                      value: _soundEnabled,
                      onChanged: (value) {
                        setState(() {
                          _soundEnabled = value;
                        });
                      },
                      activeColor: const Color(0xFF4CAF50),
                      secondary: const Icon(Icons.volume_up),
                    ),
                    SwitchListTile(
                      title: Text(
                        'Vibración',
                        style: TextStyle(
                          fontSize: _fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Vibrar con las notificaciones',
                        style: TextStyle(fontSize: _fontSize - 2),
                      ),
                      value: _vibrationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _vibrationEnabled = value;
                        });
                      },
                      activeColor: const Color(0xFF4CAF50),
                      secondary: const Icon(Icons.vibration),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sección de apariencia
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.palette,
                          color: const Color(0xFF4CAF50),
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Apariencia',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Tamaño de texto',
                      style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Slider(
                      value: _fontSize,
                      min: 14.0,
                      max: 24.0,
                      divisions: 5,
                      label: '${_fontSize.round()}px',
                      onChanged: (value) {
                        setState(() {
                          _fontSize = value;
                        });
                      },
                      activeColor: const Color(0xFF4CAF50),
                    ),
                    Text(
                      'Texto de ejemplo con tamaño ${_fontSize.round()}px',
                      style: TextStyle(fontSize: _fontSize),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(
                        'Modo oscuro',
                        style: TextStyle(
                          fontSize: _fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Cambiar a tema oscuro',
                        style: TextStyle(fontSize: _fontSize - 2),
                      ),
                      value: _darkMode,
                      onChanged: (value) {
                        setState(() {
                          _darkMode = value;
                        });
                      },
                      activeColor: const Color(0xFF4CAF50),
                      secondary: const Icon(Icons.dark_mode),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Botón de guardar
            SizedBox(
              width: double.infinity,
              child: PrimaryActionButton(
                text: 'Guardar Configuración',
                icon: Icons.save,
                onPressed: _saveSettings,
              ),
            ),

            const SizedBox(height: 20),

            // Información de la app
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFF4CAF50),
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Recordatorio de Medicamentos',
                      style: TextStyle(
                        fontSize: _fontSize + 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Versión 1.0.0',
                      style: TextStyle(
                        fontSize: _fontSize - 2,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tu compañero confiable para recordar tus medicamentos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _fontSize - 2,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }
}