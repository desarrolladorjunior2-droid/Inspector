import '../models/usuario.dart';

/// Mantiene en memoria al usuario con sesión activa mientras la app
/// está abierta. No hay tokens ni servidores: la sesión vive solo
/// mientras el proceso de la app está en ejecución.
class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;

  void iniciarSesion(Usuario usuario) {
    _usuarioActual = usuario;
  }

  void cerrarSesion() {
    _usuarioActual = null;
  }
}
