import 'dart:math';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:otp/otp.dart';

/// Verificación en dos pasos con TOTP (RFC 6238), compatible con Google
/// Authenticator, Authy, Microsoft Authenticator, etc. No requiere
/// internet ni backend: el código se genera y se verifica localmente
/// a partir de una clave secreta guardada en el dispositivo.
class TwoFactorService {
  TwoFactorService._();

  static const int _longitudCodigo = 6;
  static const int _intervaloSegundos = 30;

  /// Genera una clave secreta aleatoria en Base32 (160 bits), el formato
  /// estándar que usan las apps autenticadoras.
  static String generarSecreto() {
    final random = Random.secure();
    final bytes = Uint8List.fromList(
      List<int>.generate(20, (_) => random.nextInt(256)),
    );
    return base32.encode(bytes);
  }

  /// URI `otpauth://` para mostrar como código QR y que el usuario lo
  /// escanee con su app autenticadora.
  static String uriOtpAuth(String secreto, String cuenta) {
    final etiqueta = Uri.encodeComponent('Inspector:$cuenta');
    final emisor = Uri.encodeComponent('Inspector');
    return 'otpauth://totp/$etiqueta?secret=$secreto&issuer=$emisor'
        '&algorithm=SHA1&digits=$_longitudCodigo&period=$_intervaloSegundos';
  }

  /// Verifica un código de 6 dígitos contra la clave secreta, tolerando
  /// un paso de tiempo hacia atrás/adelante por desfases de reloj.
  static bool verificarCodigo(String secreto, String codigo) {
    final codigoLimpio = codigo.trim();
    if (codigoLimpio.length != _longitudCodigo) return false;

    final ahora = DateTime.now().millisecondsSinceEpoch;
    for (final pasos in [0, -1, 1]) {
      final tiempo = ahora + pasos * _intervaloSegundos * 1000;
      final esperado = OTP.generateTOTPCodeString(
        secreto,
        tiempo,
        length: _longitudCodigo,
        interval: _intervaloSegundos,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
      if (esperado == codigoLimpio) return true;
    }
    return false;
  }
}
