class Medicamento {
  final int? id;
  final String nombre;
  final String descripcion;
  final String dosis;
  final String frecuencia; // "diaria", "cada_8_horas", "cada_12_horas", etc.
  final List<String> horarios; // ["08:00", "14:00", "20:00"]
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String? notas;
  final bool activo;
  final String? colorHex; // Color personalizado para identificar el medicamento
  final String? tipoMedicamento; // "pastilla", "capsula", "jarabe", "inyeccion"
  final int? stockActual; // Cantidad disponible
  final int? stockMinimo; // Alerta cuando esté por debajo de este número
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;

  Medicamento({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.dosis,
    required this.frecuencia,
    required this.horarios,
    required this.fechaInicio,
    this.fechaFin,
    this.notas,
    this.activo = true,
    this.colorHex,
    this.tipoMedicamento,
    this.stockActual,
    this.stockMinimo,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  // Convertir de Map (base de datos) a objeto Medicamento
  factory Medicamento.fromMap(Map<String, dynamic> map) {
    return Medicamento(
      id: map['id']?.toInt(),
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      dosis: map['dosis'] ?? '',
      frecuencia: map['frecuencia'] ?? '',
      horarios: (map['horarios'] as String).split(',').where((h) => h.isNotEmpty).toList(),
      fechaInicio: DateTime.parse(map['fechaInicio']),
      fechaFin: map['fechaFin'] != null ? DateTime.parse(map['fechaFin']) : null,
      notas: map['notas'],
      activo: map['activo'] == 1,
      colorHex: map['colorHex'],
      tipoMedicamento: map['tipoMedicamento'],
      stockActual: map['stockActual']?.toInt(),
      stockMinimo: map['stockMinimo']?.toInt(),
      fechaCreacion: DateTime.parse(map['fechaCreacion']),
      fechaModificacion: DateTime.parse(map['fechaModificacion']),
    );
  }

  // Convertir de objeto Medicamento a Map (para base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'dosis': dosis,
      'frecuencia': frecuencia,
      'horarios': horarios.join(','),
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin?.toIso8601String(),
      'notas': notas,
      'activo': activo ? 1 : 0,
      'colorHex': colorHex,
      'tipoMedicamento': tipoMedicamento,
      'stockActual': stockActual,
      'stockMinimo': stockMinimo,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'fechaModificacion': fechaModificacion.toIso8601String(),
    };
  }

  // Crear una copia del medicamento con algunos campos modificados
  Medicamento copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    String? dosis,
    String? frecuencia,
    List<String>? horarios,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? notas,
    bool? activo,
    String? colorHex,
    String? tipoMedicamento,
    int? stockActual,
    int? stockMinimo,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  }) {
    return Medicamento(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      dosis: dosis ?? this.dosis,
      frecuencia: frecuencia ?? this.frecuencia,
      horarios: horarios ?? this.horarios,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      notas: notas ?? this.notas,
      activo: activo ?? this.activo,
      colorHex: colorHex ?? this.colorHex,
      tipoMedicamento: tipoMedicamento ?? this.tipoMedicamento,
      stockActual: stockActual ?? this.stockActual,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
    );
  }

  // Convertir a String para debug
  @override
  String toString() {
    return 'Medicamento{id: $id, nombre: $nombre, dosis: $dosis, frecuencia: $frecuencia, horarios: $horarios, activo: $activo}';
  }

  // Obtener el próximo horario de toma
  String? getProximoHorario() {
    if (horarios.isEmpty) return null;

    final now = DateTime.now();
    final currentTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // Buscar el siguiente horario del día
    for (String horario in horarios) {
      if (horario.compareTo(currentTime) > 0) {
        return horario;
      }
    }

    // Si no hay más horarios hoy, devolver el primero del día siguiente
    return "${horarios.first} (mañana)";
  }

  // Verificar si es tiempo de tomar el medicamento (dentro de 15 minutos)
  bool esTiempoDeTomar() {
    if (horarios.isEmpty) return false;

    final now = DateTime.now();
    final currentTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    for (String horario in horarios) {
      final horarioParts = horario.split(':');
      final horarioHour = int.parse(horarioParts[0]);
      final horarioMinute = int.parse(horarioParts[1]);

      final horarioDateTime = DateTime(now.year, now.month, now.day, horarioHour, horarioMinute);
      final diferencia = horarioDateTime.difference(now).inMinutes;

      // Si faltan 15 minutos o menos, es tiempo de tomar
      if (diferencia >= 0 && diferencia <= 15) {
        return true;
      }
    }

    return false;
  }

  // Verificar si el stock está bajo
  bool isStockBajo() {
    if (stockActual == null || stockMinimo == null) return false;
    return stockActual! <= stockMinimo!;
  }
}