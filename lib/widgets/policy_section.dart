import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

const String kPoliticaTratamientoDatos =
    'Inspector recopila y almacena localmente en tu dispositivo la '
    'información que proporcionas durante el registro (nombre, edad, '
    'correo y alias). Esta información NO es enviada a servidores '
    'externos. Es utilizada únicamente para identificarte dentro de la '
    'aplicación. Puedes solicitar la eliminación de tus datos en '
    'cualquier momento desde la configuración de la app.';

const String kDeclaracionMayoriaEdad = 'Declaro que soy mayor de 18 años.';

/// Sección de políticas del formulario de registro: los dos checkboxes
/// obligatorios. El primero incluye un link para leer la política
/// completa en una pantalla aparte.
class PolicySection extends StatelessWidget {
  final bool aceptoPoliticas;
  final bool declaraMayorEdad;
  final ValueChanged<bool> onAceptoPoliticasChanged;
  final ValueChanged<bool> onDeclaraMayorEdadChanged;
  final VoidCallback onVerPolitica;

  const PolicySection({
    super.key,
    required this.aceptoPoliticas,
    required this.declaraMayorEdad,
    required this.onAceptoPoliticasChanged,
    required this.onDeclaraMayorEdadChanged,
    required this.onVerPolitica,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sin InkWell envolvente: el texto incluye un link tapable
          // propio (la política), así que solo el checkbox alterna el
          // valor para no competir por el mismo gesto con el link.
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 16, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: aceptoPoliticas,
                  onChanged: (v) => onAceptoPoliticasChanged(v ?? false),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: 'He leído y acepto la '),
                          TextSpan(
                            text: 'Política de Tratamiento de Datos',
                            style: const TextStyle(
                              color: AppColors.accent,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = onVerPolitica,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          _PolicyCheckbox(
            value: declaraMayorEdad,
            onChanged: onDeclaraMayorEdadChanged,
            child: const Text(
              kDeclaracionMayoriaEdad,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget child;

  const _PolicyCheckbox({
    required this.value,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 16, 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
