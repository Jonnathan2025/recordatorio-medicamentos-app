import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import '../models/medicamento.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  // Configuración de notificaciones
  static const AndroidNotificationDetails _androidDetails =
  AndroidNotificationDetails(
    'medicamentos_channel',
    'Recordatorios de Medicamentos',
    channelDescription: 'Notificaciones para recordar tomar medicamentos',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    showWhen: true,
    icon: '@mipmap/ic_launcher',
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    color: Color(0xFF4CAF50),
    ledColor: Color(0xFF4CAF50),
    ledOnMs: 1000,
    ledOffMs: 500,
    enableLights: true,
    styleInformation: BigTextStyleInformation(''),
  );

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidDetails,
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      badgeNumber: 1,
    ),
  );

  /// Inicializa el servicio de notificaciones
  Future<bool> initialize() async {
    try {
      // Inicializar timezone
      tz.initializeTimeZones();

      // Configuración de Android
      const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuración de iOS
      const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final bool? initialized = await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      return initialized ?? false;
    } catch (e) {
      debugPrint('Error inicializando notificaciones: $e');
      return false;
    }
  }

  /// Maneja cuando se toca una notificación
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notificación tocada: ${response.payload}');

    // Aquí puedes navegar a una pantalla específica
    // Por ejemplo, mostrar detalles del medicamento
    if (response.payload != null) {
      final medicamentoId = int.tryParse(response.payload!);
      if (medicamentoId != null) {
        // Navegar a la pantalla del medicamento
        _navigateToMedicamento(medicamentoId);
      }
    }
  }

  /// Navega a la pantalla del medicamento (implementar según tu navegación)
  void _navigateToMedicamento(int medicamentoId) {
    // TODO: Implementar navegación
    debugPrint('Navegando al medicamento: $medicamentoId');
  }

  /// Solicita permisos de notificación
  Future<bool> requestPermissions() async {
    try {
      final bool? granted = await _notifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();

      return granted ?? false;
    } catch (e) {
      debugPrint('Error solicitando permisos: $e');
      return false;
    }
  }

  /// Programa una notificación inmediata para testing
  Future<void> showTestNotification() async {
    try {
      await _notifications.show(
        999,
        '💊 Recordatorio de Medicamento',
        'Esta es una notificación de prueba para verificar que funciona correctamente',
        _notificationDetails,
        payload: 'test',
      );
    } catch (e) {
      debugPrint('Error mostrando notificación de prueba: $e');
    }
  }

  /// Programa notificaciones para un medicamento
  Future<void> scheduleNotificationsForMedicamento(Medicamento medicamento) async {
    try {
      // Cancelar notificaciones existentes para este medicamento
      await cancelNotificationsForMedicamento(medicamento.id!);

      final now = DateTime.now();

      for (int i = 0; i < medicamento.horarios.length; i++) {
        final horario = medicamento.horarios[i];
        final hora = _parseHorario(horario);

        if (hora != null) {
          var fechaNotificacion = DateTime(
            now.year,
            now.month,
            now.day,
            hora.hour,
            hora.minute,
          );

          // Si la hora ya pasó hoy, programar para mañana
          if (fechaNotificacion.isBefore(now)) {
            fechaNotificacion = fechaNotificacion.add(const Duration(days: 1));
          }

          // Programar notificación diaria
          await _scheduleRepeatingNotification(
            medicamento.id! * 100 + i, // ID único por medicamento y horario
            medicamento,
            fechaNotificacion,
            horario,
          );
        }
      }
    } catch (e) {
      debugPrint('Error programando notificaciones: $e');
    }
  }

  /// Programa una notificación repetitiva
  Future<void> _scheduleRepeatingNotification(
      int notificationId,
      Medicamento medicamento,
      DateTime fechaHora,
      String horario,
      ) async {
    try {
      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        fechaHora,
        tz.local,
      );

      final String titulo = '💊 Hora de tu medicamento';
      final String cuerpo = _buildNotificationBody(medicamento, horario);

      await _notifications.zonedSchedule(
        notificationId,
        titulo,
        cuerpo,
        scheduledDate,
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Repetir diariamente
        payload: medicamento.id.toString(),
      );

      debugPrint('Notificación programada para ${medicamento.nombre} a las $horario');
    } catch (e) {
      debugPrint('Error programando notificación individual: $e');
    }
  }

  /// Construye el cuerpo de la notificación
  String _buildNotificationBody(Medicamento medicamento, String horario) {
    final StringBuffer body = StringBuffer();

    body.write('${medicamento.nombre}');

    if (medicamento.dosis.isNotEmpty) {
      body.write(' - ${medicamento.dosis}');
    }

    body.write(' a las $horario');

    if (medicamento.descripcion.isNotEmpty) {
      body.write('\n${medicamento.descripcion}');
    }

    return body.toString();
  }

  /// Cancela todas las notificaciones de un medicamento
  Future<void> cancelNotificationsForMedicamento(int medicamentoId) async {
    try {
      // Cancelar hasta 10 notificaciones por medicamento (horarios múltiples)
      for (int i = 0; i < 10; i++) {
        await _notifications.cancel(medicamentoId * 100 + i);
      }

      debugPrint('Notificaciones canceladas para medicamento $medicamentoId');
    } catch (e) {
      debugPrint('Error cancelando notificaciones: $e');
    }
  }

  /// Cancela todas las notificaciones
  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      debugPrint('Todas las notificaciones canceladas');
    } catch (e) {
      debugPrint('Error cancelando todas las notificaciones: $e');
    }
  }

  /// Obtiene las notificaciones pendientes
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      debugPrint('Error obteniendo notificaciones pendientes: $e');
      return [];
    }
  }

  /// Programa una notificación de recordatorio (si no se ha tomado)
  Future<void> scheduleReminderNotification(
      Medicamento medicamento,
      String horario,
      int minutosDeRetraso,
      ) async {
    try {
      final now = DateTime.now();
      final fechaRecordatorio = now.add(Duration(minutes: minutosDeRetraso));

      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        fechaRecordatorio,
        tz.local,
      );

      final int reminderId = medicamento.id! * 1000 + minutosDeRetraso;

      await _notifications.zonedSchedule(
        reminderId,
        '⚠️ Recordatorio: Medicamento pendiente',
        '${medicamento.nombre} - ¿Ya tomaste tu medicamento de las $horario?',
        scheduledDate,
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        payload: medicamento.id.toString(),
      );

      debugPrint('Recordatorio programado para ${medicamento.nombre} en $minutosDeRetraso minutos');
    } catch (e) {
      debugPrint('Error programando recordatorio: $e');
    }
  }

  /// Convierte string de horario a TimeOfDay
  TimeOfDay? _parseHorario(String horario) {
    try {
      final parts = horario.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      debugPrint('Error parseando horario $horario: $e');
    }
    return null;
  }

  /// Verifica si las notificaciones están habilitadas
  Future<bool> areNotificationsEnabled() async {
    try {
      final bool? enabled = await _notifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();

      return enabled ?? false;
    } catch (e) {
      debugPrint('Error verificando estado de notificaciones: $e');
      return false;
    }
  }

  /// Programa notificación de stock bajo
  Future<void> scheduleStockLowNotification(Medicamento medicamento) async {
    try {
      if (medicamento.cantidadActual <= medicamento.stockMinimo) {
        await _notifications.show(
          medicamento.id! * 10000, // ID único para stock bajo
          '⚠️ Stock bajo de medicamento',
          '${medicamento.nombre}: Solo quedan ${medicamento.cantidadActual} ${medicamento.unidadMedida}. Es hora de comprar más.',
          _notificationDetails,
          payload: 'stock_bajo_${medicamento.id}',
        );
      }
    } catch (e) {
      debugPrint('Error programando notificación de stock bajo: $e');
    }
  }
}