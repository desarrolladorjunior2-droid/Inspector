import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Hashing local de contraseñas: SHA-256 + salt aleatorio por usuario.
/// Las contraseñas nunca se guardan ni se comparan en texto plano.
class PasswordService {
  PasswordService._();

  static String generarSalt({int length = 16}) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  static String hashear(String contrasena, String salt) {
    final bytes = utf8.encode('$salt:$contrasena');
    return sha256.convert(bytes).toString();
  }

  static bool verificar(String contrasena, String salt, String hashGuardado) {
    return hashear(contrasena, salt) == hashGuardado;
  }
}
