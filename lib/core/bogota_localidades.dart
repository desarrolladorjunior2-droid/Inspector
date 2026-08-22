import 'package:latlong2/latlong.dart';

/// Centro del mapa por defecto: Bogotá.
const LatLng kBogotaCenter = LatLng(4.7110, -74.0721);

/// Coordenadas aproximadas del centro de cada localidad de Bogotá,
/// usadas para ubicar el marcador de una solicitud en el mapa.
const Map<String, LatLng> kLocalidadesBogota = {
  'Usaquén': LatLng(4.7030, -74.0350),
  'Chapinero': LatLng(4.6459, -74.0631),
  'Santa Fe': LatLng(4.6097, -74.0817),
  'San Cristóbal': LatLng(4.5573, -74.0817),
  'Usme': LatLng(4.4793, -74.1258),
  'Tunjuelito': LatLng(4.5766, -74.1330),
  'Bosa': LatLng(4.6183, -74.1766),
  'Kennedy': LatLng(4.6280, -74.1560),
  'Fontibón': LatLng(4.6740, -74.1460),
  'Engativá': LatLng(4.7100, -74.1130),
  'Suba': LatLng(4.7550, -74.0930),
  'Barrios Unidos': LatLng(4.6680, -74.0840),
  'Teusaquillo': LatLng(4.6360, -74.0930),
  'Los Mártires': LatLng(4.6040, -74.0910),
  'Antonio Nariño': LatLng(4.5890, -74.0990),
  'Puente Aranda': LatLng(4.6150, -74.1150),
  'La Candelaria': LatLng(4.5960, -74.0750),
  'Rafael Uribe Uribe': LatLng(4.5580, -74.1130),
  'Ciudad Bolívar': LatLng(4.5000, -74.1600),
  'Sumapaz': LatLng(4.2500, -74.3500),
};
