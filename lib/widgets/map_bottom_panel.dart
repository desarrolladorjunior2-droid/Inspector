import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Panel inferior con esquinas redondeadas usado sobre el mapa en las
/// pantallas de Cliente y Colaborador (formulario, seguimiento o listas).
class MapBottomPanel extends StatelessWidget {
  final Widget child;
  final double maxHeightFraction;

  const MapBottomPanel({
    super.key,
    required this.child,
    this.maxHeightFraction = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * maxHeightFraction,
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 4),
        ],
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
