import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../widgets/app_buttons.dart';

/// Recuperación de contraseña 100% local: se identifica al usuario por
/// su alias o nombre completo (no hay envío de correos ni backend).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _busquedaCtrl = TextEditingController();
  final _nuevaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();

  Usuario? _usuarioEncontrado;
  bool _cargando = false;
  String? _errorBusqueda;

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    _nuevaCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  Future<void> _buscarUsuario() async {
    if (_busquedaCtrl.text.trim().isEmpty) return;
    setState(() {
      _cargando = true;
      _errorBusqueda = null;
    });
    try {
      final usuario =
          await AuthService.buscarParaRecuperacion(_busquedaCtrl.text);
      setState(() => _usuarioEncontrado = usuario);
    } on AuthException catch (e) {
      setState(() => _errorBusqueda = e.mensaje);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _restablecer() async {
    if (_nuevaCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener mínimo 6 caracteres')),
      );
      return;
    }
    if (_nuevaCtrl.text != _confirmarCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => _cargando = true);
    try {
      await AuthService.restablecerContrasena(
        usuarioId: _usuarioEncontrado!.id!,
        nuevaContrasena: _nuevaCtrl.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada. Ya puedes iniciar sesión.')),
      );
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: _usuarioEncontrado == null
              ? _buildBusqueda()
              : _buildRestablecer(),
        ),
      ),
    );
  }

  List<Widget> _buildBusqueda() {
    return [
      const Text(
        'Ingresa tu alias o tu nombre completo para verificar tu identidad.',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _busquedaCtrl,
        decoration: const InputDecoration(
          labelText: 'Alias o nombre completo',
          hintText: 'Ej: Inspector_7K2QXR9L',
        ),
      ),
      if (_errorBusqueda != null) ...[
        const SizedBox(height: 8),
        Text(_errorBusqueda!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
      ],
      const SizedBox(height: 20),
      PrimaryButton(
        label: 'BUSCAR CUENTA',
        isLoading: _cargando,
        onPressed: _buscarUsuario,
      ),
    ];
  }

  List<Widget> _buildRestablecer() {
    return [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user_outlined, color: AppColors.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Cuenta encontrada: ${_usuarioEncontrado!.alias}',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _nuevaCtrl,
        obscureText: true,
        decoration: const InputDecoration(labelText: 'Nueva contraseña'),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _confirmarCtrl,
        obscureText: true,
        decoration: const InputDecoration(labelText: 'Confirmar nueva contraseña'),
      ),
      const SizedBox(height: 20),
      PrimaryButton(
        label: 'RESTABLECER CONTRASEÑA',
        isLoading: _cargando,
        onPressed: _restablecer,
      ),
    ];
  }
}
