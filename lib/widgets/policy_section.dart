import 'package:flutter/material.dart';
import '../core/app_colors.dart';

const String kPoliticaTratamientoDatos =
    'Inspector recopila y almacena localmente en tu dispositivo la '
    'información que proporcionas durante el registro (nombre, edad, '
    'correo y alias). Esta información NO es enviada a servidores '
    'externos. Es utilizada únicamente para identificarte dentro de la '
    'aplicación. Puedes solicitar la eliminación de tus datos en '
    'cualquier momento desde la configuración de la app.';

const String kDeclaracionMayoriaEdad =
    'Declaro que soy mayor de 18 años. En caso de ser menor de edad, '
    'entiendo que es mi responsabilidad y la de mi acudiente el uso de '
    'esta aplicación, eximiendo a Inspector de cualquier responsabilidad '
    'al respecto.';

/// Sección de políticas del formulario de registro: acordeón con el
/// texto de tratamiento de datos y los dos checkboxes obligatorios.
class PolicySection extends StatefulWidget {
  final bool aceptoPoliticas;
  final bool declaraMayorEdad;
  final ValueChanged<bool> onAceptoPoliticasChanged;
  final ValueChanged<bool> onDeclaraMayorEdadChanged;

  const PolicySection({
    super.key,
    required this.aceptoPoliticas,
    required this.declaraMayorEdad,
    required this.onAceptoPoliticasChanged,
    required this.onDeclaraMayorEdadChanged,
  });

  @override
  State<PolicySection> createState() => _PolicySectionState();
}

class _PolicySectionState extends State<PolicySection> {
  bool _expandido = false;

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
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: _expandido,
              onExpansionChanged: (v) => setState(() => _expandido = v),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              iconColor: AppColors.accent,
              collapsedIconColor: AppColors.textSecondary,
              title: const Text(
                'Política de Tratamiento de Datos',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    kPoliticaTratamientoDatos,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          _PolicyCheckbox(
            value: widget.aceptoPoliticas,
            onChanged: widget.onAceptoPoliticasChanged,
            label:
                'He leído y acepto la Política de Tratamiento de Datos',
          ),
          _PolicyCheckbox(
            value: widget.declaraMayorEdad,
            onChanged: widget.onDeclaraMayorEdadChanged,
            label: kDeclaracionMayoriaEdad,
          ),
        ],
      ),
    );
  }
}

class _PolicyCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const _PolicyCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
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
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
