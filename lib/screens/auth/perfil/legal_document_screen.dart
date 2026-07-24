import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme_colors.dart';

enum LegalDocumentType { privacy, terms }

class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({
    required this.type,
    Key? key,
  }) : super(key: key);

  final LegalDocumentType type;

  bool get _isPrivacy => type == LegalDocumentType.privacy;

  @override
  Widget build(BuildContext context) {
    final title = _isPrivacy ? 'Politica de privacidad' : 'Terminos y condiciones';
    final eyebrow = _isPrivacy ? 'Privacidad y confianza' : 'Acuerdo de uso';
    final intro = _isPrivacy
        ? 'Conoce que datos usamos en MANACHYNA KUSA, para que los necesitamos y como puedes solicitar su eliminacion.'
        : 'Estas condiciones explican las reglas para utilizar MANACHYNA KUSA y los servicios disponibles dentro de la aplicacion.';
    final sections = _isPrivacy ? _privacySections : _termsSections;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: context.appPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _isPrivacy
                      ? 'Tu informacion merece claridad.'
                      : 'Condiciones claras para usar la aplicacion.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  intro,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1.45,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Ultima actualizacion: 24 de julio de 2026',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...sections.map((section) => _LegalSection(section: section)),
          const SizedBox(height: 10),
          Text(
            'MANACHYNA KUSA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.appTextSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalSection extends StatelessWidget {
  const _LegalSection({required this.section});

  final _LegalText section;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appBorder),
        boxShadow: context.appCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(section.icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section.title,
                  style: TextStyle(
                    color: context.appTextPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            section.body,
            style: TextStyle(
              color: context.appTextSecondary,
              height: 1.55,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalText {
  const _LegalText({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

const _privacySections = [
  _LegalText(
    icon: Icons.account_circle_outlined,
    title: '1. Informacion que recopilamos',
    body:
        'Podemos recibir nombre, correo electronico, foto de perfil e identificador de cuenta cuando inicias sesion con Google, Facebook o Microsoft. Tambien podemos recibir datos que agregues a tu perfil, como telefono, ciudad, direccion y preferencias de servicio.',
  ),
  _LegalText(
    icon: Icons.settings_outlined,
    title: '2. Como usamos la informacion',
    body:
        'Usamos estos datos para crear y proteger tu cuenta, mostrar tu perfil, permitir reservas y solicitudes de servicios, enviar notificaciones relacionadas con la aplicacion y mejorar la seguridad de MANACHYNA KUSA.',
  ),
  _LegalText(
    icon: Icons.verified_user_outlined,
    title: '3. Servicios de terceros',
    body:
        'La autenticacion puede realizarse mediante Google, Facebook o Microsoft. Usamos Supabase para autenticacion, almacenamiento y base de datos.',
  ),
  _LegalText(
    icon: Icons.lock_outline_rounded,
    title: '4. Seguridad y conservacion',
    body:
        'Aplicamos controles de acceso y medidas razonables para proteger la informacion. Conservamos los datos mientras mantengas tu cuenta o cuando sea necesario para prestar el servicio y cumplir obligaciones legales.',
  ),
  _LegalText(
    icon: Icons.delete_outline_rounded,
    title: '5. Eliminacion de datos',
    body:
        'Puedes solicitar la eliminacion de tu cuenta y datos escribiendo a willian.cerda@est.itstena.edu.ec. Verificaremos la solicitud y eliminaremos los datos que no debamos conservar por razones legales o de seguridad.',
  ),
];

const _termsSections = [
  _LegalText(
    icon: Icons.check_circle_outline_rounded,
    title: '1. Aceptacion',
    body:
        'Al crear una cuenta o utilizar MANACHYNA KUSA, aceptas estas condiciones. Si no estas de acuerdo, no debes utilizar la aplicacion.',
  ),
  _LegalText(
    icon: Icons.phone_android_rounded,
    title: '2. Uso de la aplicacion',
    body:
        'Debes proporcionar informacion verdadera, mantener segura tu cuenta y utilizar la aplicacion de forma legal y respetuosa. No puedes intentar acceder sin autorizacion a cuentas, sistemas o datos de otros usuarios.',
  ),
  _LegalText(
    icon: Icons.login_rounded,
    title: '3. Cuentas y autenticacion',
    body:
        'Puedes iniciar sesion mediante proveedores externos como Google, Facebook o Microsoft. Eres responsable de la actividad realizada desde tu cuenta y de mantener actualizados tus datos de contacto.',
  ),
  _LegalText(
    icon: Icons.home_repair_service_outlined,
    title: '4. Servicios y reservas',
    body:
        'MANACHYNA KUSA facilita la conexion entre usuarios y proveedores de servicios. La disponibilidad, precios, horarios y condiciones particulares pueden depender del proveedor correspondiente.',
  ),
  _LegalText(
    icon: Icons.report_gmailerrorred_rounded,
    title: '5. Conducta y seguridad',
    body:
        'No publiques contenido falso, ilegal, ofensivo o que infrinja derechos de terceros. Podemos limitar o suspender cuentas que incumplan estas condiciones o comprometan la seguridad de la plataforma.',
  ),
  _LegalText(
    icon: Icons.mail_outline_rounded,
    title: '6. Contacto',
    body:
        'Para preguntas sobre estas condiciones o sobre privacidad, escribe a willian.cerda@est.itstena.edu.ec.',
  ),
];
