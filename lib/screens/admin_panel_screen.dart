import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../models/solicitud.dart';
import '../models/usuario.dart';
import '../services/admin_service.dart';
import '../services/session_service.dart';
import 'splash_screen.dart';

/// Panel de administrador: solo lectura por ahora. Muestra todos los
/// usuarios registrados y todas las solicitudes creadas en la app,
/// leídos directamente de la base de datos local.
class AdminPanelScreen extends StatefulWidget {
  final Usuario usuario;
  const AdminPanelScreen({super.key, required this.usuario});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  List<Usuario> _usuarios = [];
  List<Solicitud> _solicitudes = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    final usuarios = await AdminService.todosLosUsuarios();
    final solicitudes = await AdminService.todasLasSolicitudes();
    if (!mounted) return;
    setState(() {
      _usuarios = usuarios;
      _solicitudes = solicitudes;
      _cargando = false;
    });
  }

  void _cerrarSesion() {
    SessionService.instance.cerrarSesion();
    Navigator.of(context).pushAndRemoveUntil(
      AppRoutes.fade(const SplashScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final aliasPorId = {for (final u in _usuarios) u.id: u.alias};

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Panel de administrador'),
          actions: [
            IconButton(
              onPressed: _cargarDatos,
              icon: const Icon(Icons.refresh),
              tooltip: 'Actualizar',
            ),
            IconButton(
              onPressed: _cerrarSesion,
              icon: const Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.accent,
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'Usuarios (${_usuarios.length})'),
              Tab(text: 'Solicitudes (${_solicitudes.length})'),
            ],
          ),
        ),
        body: _cargando
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.accent))
            : TabBarView(
                children: [
                  _ListaUsuarios(usuarios: _usuarios),
                  _ListaSolicitudes(
                    solicitudes: _solicitudes,
                    aliasPorId: aliasPorId,
                  ),
                ],
              ),
      ),
    );
  }
}

class _ListaUsuarios extends StatelessWidget {
  final List<Usuario> usuarios;
  const _ListaUsuarios({required this.usuarios});

  @override
  Widget build(BuildContext context) {
    if (usuarios.isEmpty) {
      return const Center(
        child: Text('Sin usuarios registrados',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: usuarios.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final u = usuarios[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      u.alias,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  _Badge(texto: _rolLabel(u.rol)),
                ],
              ),
              const SizedBox(height: 6),
              Text('${u.nombre} · ${u.edad} años',
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 13)),
              Text(u.correo,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12.5)),
              if (u.ocupacion != null || u.localidadTrabajo != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    [
                      if (u.ocupacion != null) u.ocupacion,
                      if (u.localidadTrabajo != null) u.localidadTrabajo,
                    ].join(' · '),
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _rolLabel(RolUsuario? rol) {
    switch (rol) {
      case RolUsuario.colaborador:
        return 'Colaborador';
      case RolUsuario.cliente:
        return 'Cliente';
      case RolUsuario.administrador:
        return 'Admin';
      case null:
        return 'Sin rol';
    }
  }
}

class _ListaSolicitudes extends StatelessWidget {
  final List<Solicitud> solicitudes;
  final Map<int?, String> aliasPorId;
  const _ListaSolicitudes({required this.solicitudes, required this.aliasPorId});

  @override
  Widget build(BuildContext context) {
    if (solicitudes.isEmpty) {
      return const Center(
        child: Text('Sin solicitudes creadas',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: solicitudes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final s = solicitudes[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${s.tipo.etiqueta} · ${s.localidad}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  _Badge(texto: s.estado.etiqueta),
                ],
              ),
              const SizedBox(height: 6),
              Text(s.descripcion,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12.5)),
              const SizedBox(height: 6),
              Text(
                'Cliente: ${aliasPorId[s.clienteId] ?? s.clienteId}'
                '${s.colaboradorId != null ? ' · Colaborador: ${aliasPorId[s.colaboradorId] ?? s.colaboradorId}' : ''}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  final String texto;
  const _Badge({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto.toUpperCase(),
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
