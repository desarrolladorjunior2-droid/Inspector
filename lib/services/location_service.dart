import 'package:geolocator/geolocator.dart';

/// Envuelve el flujo de permiso de ubicación de Android/iOS.
/// La app no depende de la ubicación para funcionar (todo sigue siendo
/// local), pero se solicita de entrada para poder centrar el mapa y,
/// más adelante, ubicar solicitudes cercanas.
class LocationService {
  LocationService._();

  static Future<LocationPermission> solicitarPermiso() async {
    final servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      return LocationPermission.denied;
    }

    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    return permiso;
  }

  static Future<bool> tienePermisoConcedido() async {
    final permiso = await Geolocator.checkPermission();
    return permiso == LocationPermission.always ||
        permiso == LocationPermission.whileInUse;
  }
}
