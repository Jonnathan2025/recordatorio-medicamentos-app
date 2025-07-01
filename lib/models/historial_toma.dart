class HistorialToma {
  final int? id;
  final int medicamentoId;
  final DateTime fechaHoraProgramada;
  final DateTime? fechaHoraReal;
  final bool tomado;
  final String? notas;
  final String? motivoNoTomado; // "olvido", "efectos_secundarios", "no_disponible", etc.
  final DateTime fechaCreacion;

  HistorialToma({
    this.id,
    required this.medicamentoId,
    required this.fechaHoraProgramada,
    this.fechaHoraReal,
    this.tomado = false,
    this.notas,
    this.motivoNoTomado,
    required this.fechaCreacion,
  });

  // Convertir de Map (base de datos) a objeto HistorialToma
  factory HistorialToma.fromMap(Map<String, dynamic> map) {
    return HistorialToma(
      id: map['id']?.toInt(),
      medicamentoId: map['medicamentoId']?.toInt() ?? 0,
      fechaHoraProgramada: DateTime.parse(map['fechaHoraProgramada']),
      fechaHoraReal: map['fechaHoraReal'] != null ? DateTime.parse(map['fechaHoraReal']) : null,
      tomado: map['tomado'] == 1,
      notas: map['notas'],
      motivoNoTomado: map['motivoNoTomado'],
      fechaCreacion: DateTime.parse(map['fechaCreacion']),
    );
  }

  // Convertir de objeto HistorialToma a Map (para base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicamentoId': medicamentoId,
      'fechaHoraProgramada': fechaHoraProgramada.toIso8601String(),
      'fechaHoraReal': fechaHoraReal?.toIso8601String(),
      'tomado': tomado ? 1 : 0,
      'notas': notas,
      'motivoNoTomado': motivoNoTomado,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  // Crear una copia con algunos campos modificados
  HistorialToma copyWith({
    int? id,
    int? medicamentoId,
    DateTime? fechaHoraProgramada,
    DateTime? fechaHoraReal,
    bool? tomado,
    String? notas,
    String? motivoNoTomado,
    DateTime? fechaCreacion,
  }) {
    return HistorialToma(
      id: id ?? this.id,
      medicamentoId: medicamentoId ?? this.medicamentoId,
      fechaHoraProgramada: fechaHoraProgramada ?? this.fechaHoraProgramada,
      fechaHoraReal: fechaHoraReal ?? this.fechaHoraReal,
      tomado: tomado ?? this.tomado,
      notas: notas ?? this.notas,
      motivoNoTomado: motivoNoTomado ?? this.motivoNoTomado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return 'HistorialToma{id: $id, medicamentoId: $medicamentoId, fechaHoraProgramada: $fechaHoraProgramada, tomado: $tomado}';
  }

  // Verificar si la toma está atrasada
  bool isAtrasada() {
    if (tomado) return false;
    return DateTime.now().isAfter(fechaHoraProgramada.add(const Duration(minutes: 30)));
  }

  // Obtener el tiempo de retraso en minutos
  int getMinutosRetraso() {
    if (tomado || !isAtrasada()) return 0;
    return DateTime.now().difference(fechaHoraProgramada).inMinutes;
  }

  // Formatear la fecha para mostrar
  String getFechaFormateada() {
    final fecha = fechaHoraReal ?? fechaHoraProgramada;
    return "${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}";
  }

  // Formatear la hora para mostrar
  String getHoraFormateada() {
    final fecha = fechaHoraReal ?? fechaHoraProgramada;
    return "${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}";
  }

  // Obtener estado de la toma
  String getEstado() {
    if (tomado) {
      if (fechaHoraReal != null && fechaHoraReal!.isAfter(fechaHoraProgramada.add(const Duration(minutes: 15)))) {
        return "Tomado (Tarde)";
      }
      return "Tomado";
    }

    if (isAtrasada()) {
      return "Atrasado";
    }

    return "Pendiente";
  }

  // Obtener color según el estado
  String getColorEstado() {
    if (tomado) {
      return "#4CAF50"; // Verde
    }

    if (isAtrasada()) {
      return "#F44336"; // Rojo
    }

    return "#FF9800"; // Naranja
  }
}