import '../core/bogota_localidades.dart';
import '../data/database_helper.dart';
import '../models/solicitud.dart';

class SolicitudService {
  SolicitudService._();

  static final DatabaseHelper _db = DatabaseHelper.instance;

  static Future<Solicitud> crearSolicitud({
    required int clienteId,
    required TipoSolicitud tipo,
    required String descripcion,
    required String localidad,
  }) async {
    final centro = kLocalidadesBogota[localidad] ?? kBogotaCenter;
    final ahora = DateTime.now().toIso8601String();

    final nueva = Solicitud(
      clienteId: clienteId,
      tipo: tipo,
      descripcion: descripcion.trim(),
      localidad: localidad,
      latitud: centro.latitude,
      longitud: centro.longitude,
      estado: EstadoSolicitud.pendiente,
      fechaCreacion: ahora,
      fechaActualizacion: ahora,
    );

    final id = await _db.insertSolicitud(nueva);
    return nueva.copyWith(id: id);
  }

  static Future<Solicitud?> solicitudActivaDeCliente(int clienteId) {
    return _db.getSolicitudActivaCliente(clienteId);
  }

  static Future<List<Solicitud>> solicitudesPendientes() {
    return _db.getSolicitudesPendientes();
  }

  static Future<List<Solicitud>> solicitudesEnCursoDeColaborador(
    int colaboradorId,
  ) {
    return _db.getSolicitudesAceptadasPorColaborador(colaboradorId);
  }

  static Future<void> aceptarSolicitud({
    required int solicitudId,
    required int colaboradorId,
  }) {
    return _db.actualizarEstadoSolicitud(
      solicitudId,
      estado: EstadoSolicitud.aceptada,
      colaboradorId: colaboradorId,
    );
  }

  static Future<void> completarSolicitud(int solicitudId) {
    return _db.actualizarEstadoSolicitud(
      solicitudId,
      estado: EstadoSolicitud.completada,
    );
  }

  static Future<void> cancelarSolicitud(int solicitudId) {
    return _db.actualizarEstadoSolicitud(
      solicitudId,
      estado: EstadoSolicitud.cancelada,
    );
  }
}
