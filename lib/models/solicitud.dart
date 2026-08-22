enum TipoSolicitud { texto, imagen }

extension TipoSolicitudX on TipoSolicitud {
  String get valor => name;
  String get etiqueta => this == TipoSolicitud.texto ? 'Texto' : 'Imagen';

  static TipoSolicitud fromValor(String valor) {
    return TipoSolicitud.values.firstWhere((t) => t.valor == valor);
  }
}

enum EstadoSolicitud { pendiente, aceptada, completada, cancelada }

extension EstadoSolicitudX on EstadoSolicitud {
  String get valor => name;

  String get etiqueta {
    switch (this) {
      case EstadoSolicitud.pendiente:
        return 'Buscando colaborador';
      case EstadoSolicitud.aceptada:
        return 'Colaborador en camino';
      case EstadoSolicitud.completada:
        return 'Completada';
      case EstadoSolicitud.cancelada:
        return 'Cancelada';
    }
  }

  static EstadoSolicitud fromValor(String valor) {
    return EstadoSolicitud.values.firstWhere((e) => e.valor == valor);
  }
}

class Solicitud {
  final int? id;
  final int clienteId;
  final int? colaboradorId;
  final TipoSolicitud tipo;
  final String descripcion;
  final String localidad;
  final double latitud;
  final double longitud;
  final EstadoSolicitud estado;
  final String fechaCreacion;
  final String fechaActualizacion;

  const Solicitud({
    this.id,
    required this.clienteId,
    this.colaboradorId,
    required this.tipo,
    required this.descripcion,
    required this.localidad,
    required this.latitud,
    required this.longitud,
    required this.estado,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  Solicitud copyWith({
    int? id,
    int? colaboradorId,
    EstadoSolicitud? estado,
    String? fechaActualizacion,
  }) {
    return Solicitud(
      id: id ?? this.id,
      clienteId: clienteId,
      colaboradorId: colaboradorId ?? this.colaboradorId,
      tipo: tipo,
      descripcion: descripcion,
      localidad: localidad,
      latitud: latitud,
      longitud: longitud,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'cliente_id': clienteId,
      'colaborador_id': colaboradorId,
      'tipo': tipo.valor,
      'descripcion': descripcion,
      'localidad': localidad,
      'latitud': latitud,
      'longitud': longitud,
      'estado': estado.valor,
      'fecha_creacion': fechaCreacion,
      'fecha_actualizacion': fechaActualizacion,
    };
  }

  factory Solicitud.fromMap(Map<String, Object?> map) {
    return Solicitud(
      id: map['id'] as int?,
      clienteId: map['cliente_id'] as int,
      colaboradorId: map['colaborador_id'] as int?,
      tipo: TipoSolicitudX.fromValor(map['tipo'] as String),
      descripcion: map['descripcion'] as String,
      localidad: map['localidad'] as String,
      latitud: (map['latitud'] as num).toDouble(),
      longitud: (map['longitud'] as num).toDouble(),
      estado: EstadoSolicitudX.fromValor(map['estado'] as String),
      fechaCreacion: map['fecha_creacion'] as String,
      fechaActualizacion: map['fecha_actualizacion'] as String,
    );
  }
}
