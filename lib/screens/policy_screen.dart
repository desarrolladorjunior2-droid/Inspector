import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/policy_section.dart';

/// Pantalla con el texto completo de la Política de Tratamiento de
/// Datos, accesible desde el link en el checkbox de registro.
class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Política de Tratamiento de Datos')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            Text(
              kPoliticaTratamientoDatos,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.5,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
