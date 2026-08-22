import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Fila de ícono + texto usada para mostrar datos de una solicitud
/// (tipo, localidad, descripción) en los paneles de Cliente y Colaborador.
class SolicitudInfoRow extends StatelessWidget {
  final IconData icono;
  final String texto;
  const SolicitudInfoRow({super.key, required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
