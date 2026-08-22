import 'dart:math';

import '../data/database_helper.dart';

/// Genera alias únicos y completamente aleatorios (formato
/// `Inspector_XXXXXXXX`). El sufijo no se deriva del nombre, correo ni
/// ningún otro dato del usuario: son 8 caracteres alfanuméricos al azar,
/// para que el alias no revele ninguna información personal.
class AliasService {
  AliasService._();

  static const String _prefijo = 'Inspector_';
  static const String _caracteres = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const int _longitudSufijo = 8;

  static Future<String> generarAliasUnico() async {
    final db = DatabaseHelper.instance;
    final random = Random.secure();

    String alias;
    int intentos = 0;
    do {
      alias = '$_prefijo${_sufijoAleatorio(random)}';
      intentos++;
      // Salvaguarda ante colisiones muy improbables y repetidas.
    } while (await db.existeAlias(alias) && intentos < 50);

    return alias;
  }

  static String _sufijoAleatorio(Random random) {
    return List.generate(
      _longitudSufijo,
      (_) => _caracteres[random.nextInt(_caracteres.length)],
    ).join();
  }
}
