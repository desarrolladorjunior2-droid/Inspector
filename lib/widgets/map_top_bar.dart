import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Barra superior flotante usada en las pantallas de mapa (Cliente y
/// Colaborador): alias del usuario a la izquierda, acceso al perfil
/// a la derecha.
class MapTopBar extends StatelessWidget {
  final String alias;
  final VoidCallback onPerfil;

  const MapTopBar({super.key, required this.alias, required this.onPerfil});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    alias,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: onPerfil,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.92),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.person_outline,
                      color: AppColors.textPrimary, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
