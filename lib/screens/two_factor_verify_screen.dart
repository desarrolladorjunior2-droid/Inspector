import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../core/role_navigation.dart';
import '../models/usuario.dart';
import '../services/session_service.dart';
import '../services/two_factor_service.dart';
import '../widgets/app_buttons.dart';
import 'role_selection_screen.dart';

/// Segundo paso del login cuando el usuario tiene la verificación en dos
/// pasos activada: pide el código de 6 dígitos de su app autenticadora.
/// La contraseña ya fue validada antes de llegar aquí.
class TwoFactorVerifyScreen extends StatefulWidget {
  final Usuario usuario;
  const TwoFactorVerifyScreen({super.key, required this.usuario});

  @override
  State<TwoFactorVerifyScreen> createState() => _TwoFactorVerifyScreenState();
}

class _TwoFactorVerifyScreenState extends State<TwoFactorVerifyScreen> {
  final _codigoCtrl = TextEditingController();
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _codigoCtrl.dispose();
    super.dispose();
  }

  Future<void> _verificar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    final valido = TwoFactorService.verificarCodigo(
      widget.usuario.totpSecret!,
      _codigoCtrl.text,
    );

    if (!valido) {
      setState(() {
        _cargando = false;
        _error = 'Código incorrecto. Inténtalo de nuevo.';
      });
      return;
    }

    SessionService.instance.iniciarSesion(widget.usuario);
    if (!mounted) return;

    if (widget.usuario.rol == null) {
      Navigator.of(context).pushReplacement(
        AppRoutes.fade(RoleSelectionScreen(usuario: widget.usuario)),
      );
    } else {
      Navigator.of(context).pushReplacement(
        AppRoutes.fade(pantallaPrincipalParaRol(widget.usuario)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificación en dos pasos')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Abre tu app autenticadora e ingresa el código de 6 '
                'dígitos de Inspector.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _codigoCtrl,
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  letterSpacing: 8,
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: '000000',
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!,
                    style: const TextStyle(color: AppColors.error, fontSize: 13)),
              ],
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'VERIFICAR',
                isLoading: _cargando,
                onPressed: _verificar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
