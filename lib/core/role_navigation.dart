import 'package:flutter/widgets.dart';
import '../models/usuario.dart';
import '../screens/admin_panel_screen.dart';
import '../screens/cliente_home_screen.dart';
import '../screens/colaborador_home_screen.dart';

/// Pantalla principal según el rol del usuario. Se asume que
/// `usuario.rol` ya no es nulo (llamar solo después de RoleSelectionScreen
/// o cuando el login confirma que el usuario ya tiene rol asignado).
Widget pantallaPrincipalParaRol(Usuario usuario) {
  switch (usuario.rol!) {
    case RolUsuario.cliente:
      return ClienteHomeScreen(usuario: usuario);
    case RolUsuario.colaborador:
      return ColaboradorHomeScreen(usuario: usuario);
    case RolUsuario.administrador:
      return AdminPanelScreen(usuario: usuario);
  }
}
