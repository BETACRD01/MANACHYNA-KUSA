import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../models/user/user_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../providers/language_provider.dart';
import '../../../auth/ui/widgets/login_content.dart';
import 'views/provider_registration_view.dart';
import 'views/provider_view.dart';
import 'widgets/profile_widgets.dart';

const String _privacyPolicyUrl =
    'https://betacrd01.github.io/MANACHYNA-KUSA/legal/privacy.html';
const String _termsOfServiceUrl =
    'https://betacrd01.github.io/MANACHYNA-KUSA/legal/terms.html';

Future<void> _openExternalUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

  if (!opened && context.mounted) {
    Helpers.showCustomSnackBar(
      context,
      message: 'No se pudo abrir el enlace.',
      isError: true,
    );
  }
}

void _showThemeSelector(BuildContext context, ThemeProvider themeProvider) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Elige un tema',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            _ThemeOption(
              icon: Icons.phone_android_rounded,
              title: 'Sistema',
              isSelected: themeProvider.themeMode == ThemeMode.system,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              icon: Icons.light_mode_outlined,
              title: 'Claro',
              isSelected: themeProvider.themeMode == ThemeMode.light,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              icon: Icons.dark_mode_outlined,
              title: 'Oscuro',
              isSelected: themeProvider.themeMode == ThemeMode.dark,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(
        icon,
        color:
            isSelected ? AppColors.primary : Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? AppColors.primary
              : Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
          : null,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showProviderView = false;
  bool _showProviderRegistration = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        top: false,
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (!authProvider.isInitialized || authProvider.isLoading) {
              return const Center(
                child: LoadingWidget(message: 'Cargando perfil...'),
              );
            }

            final user = authProvider.currentUser;
            if (user == null) {
              return _PerfilLoginView(
                onAuthenticated: () {
                  setState(() {});
                },
              );
            }

            if (_showProviderView) {
              if (_showProviderRegistration) {
                return PerfilProviderRegistrationView(
                  user: user,
                  onBack: () {
                    setState(() => _showProviderRegistration = false);
                  },
                  onSubmitted: _showProviderSubmitted,
                );
              }

              return PerfilProviderView(
                onBack: () {
                  setState(() {
                    _showProviderView = false;
                    _showProviderRegistration = false;
                  });
                },
                onApply: () {
                  setState(() => _showProviderRegistration = true);
                },
              );
            }

            return _PerfilMainView(
              user: user,
              onEditPhoto: () {
                Navigator.pushNamed(context, AppRoutes.editProfile);
              },
              onEditProfile: () {
                Navigator.pushNamed(context, AppRoutes.editProfile);
              },
              onOpenProviderView: () {
                setState(() => _showProviderView = true);
              },
              onMenuTap: _showComingSoon,
              onLogout: () => _logout(authProvider),
            );
          },
        ),
      ),
    );
  }


  void _showComingSoon() {
    Helpers.showCustomSnackBar(
      context,
      message: 'Esta opción estará disponible pronto.',
    );
  }

  void _showProviderSubmitted() {
    setState(() {
      _showProviderView = false;
      _showProviderRegistration = false;
    });
    Helpers.showCustomSnackBar(
      context,
      message: 'Solicitud creada. Luego se guardará en Supabase para revisión.',
    );
  }

  Future<void> _logout(AuthProvider authProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: context.appSurface,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEECEB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '¿Estás seguro de que deseas salir de tu cuenta? Tendrás que ingresar tus credenciales la próxima vez.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: context.appTextSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(
                          color: context.appBorder,
                          width: 1.5,
                        ),
                        foregroundColor: context.appTextPrimary,
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Salir',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) {
      return;
    }

    try {
      await authProvider.signOut();
      if (!mounted) return;
      setState(() {
        _showProviderView = false;
        _showProviderRegistration = false;
      });
    } catch (e) {
      if (!mounted) return;
      Helpers.showCustomSnackBar(
        context,
        message: 'Error al cerrar sesión: $e',
        isError: true,
      );
    }
  }
}

class _PerfilMainView extends StatelessWidget {
  const _PerfilMainView({
    required this.user,
    required this.onEditPhoto,
    required this.onEditProfile,
    required this.onOpenProviderView,
    required this.onMenuTap,
    required this.onLogout,
  });

  final UserModel user;
  final VoidCallback onEditPhoto;
  final VoidCallback onEditProfile;
  final VoidCallback onOpenProviderView;
  final VoidCallback onMenuTap;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    String themeName = 'Sistema';
    if (themeProvider.themeMode == ThemeMode.light) themeName = 'Claro';
    if (themeProvider.themeMode == ThemeMode.dark) themeName = 'Oscuro';

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: PerfilHeader(
            user: user,
            onEditPhoto: onEditPhoto,
          ),
        ),
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -26),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 36, 16, 28),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  PerfilSection(
                    title: 'Cuenta',
                    children: [
                      PerfilMenuItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Editar perfil',
                        subtitle: 'Actualiza tu información personal',
                        onTap: onEditProfile,
                      ),
                      if (user.hasAdminAccess)
                        PerfilMenuItem(
                          icon: Icons.admin_panel_settings_outlined,
                          title: 'Panel de admin',
                          subtitle: 'Gestiona proveedores y actividad',
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.adminDashboard);
                          },
                        ),
                      if (user.hasProviderAccess)
                        PerfilMenuItem(
                          icon: Icons.dashboard_customize_outlined,
                          title: 'Panel de proveedor',
                          subtitle: 'Gestiona servicios y reservas',
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.providerDashboard);
                          },
                        ),
                      if (user.userType == UserType.client && !user.hasProviderAccess)
                        PerfilMenuItem(
                          icon: Icons.assignment_outlined,
                          title: 'Mis tareas en casa',
                          subtitle: 'Ver solicitudes y ofertas de proveedores',
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.clientCustomTasks);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  PerfilSection(
                    title: 'Preferencias',
                    children: [
                      PerfilMenuItem(
                        icon: Icons.language_rounded,
                        title: 'Idioma',
                        subtitle: languageProvider.currentLanguageName,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.language);
                        },
                      ),
                      PerfilMenuItem(
                        icon: Icons.dark_mode_outlined,
                        title: 'Tema',
                        subtitle: themeName,
                        onTap: () {
                          _showThemeSelector(context, themeProvider);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  PerfilSection(
                    title: 'Ayuda y soporte',
                    children: [
                      PerfilMenuItem(
                        icon: Icons.help_outline_rounded,
                        title: 'Centro de ayuda',
                        subtitle: 'Preguntas frecuentes y más',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.helpCenter);
                        },
                      ),
                      PerfilMenuItem(
                        icon: Icons.mail_outline_rounded,
                        title: 'Contáctanos',
                        subtitle: 'Estamos para ayudarte',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.contactUs);
                        },
                      ),
                      PerfilMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Política de privacidad',
                        subtitle: 'Cómo protegemos tus datos',
                        onTap: () {
                          _openExternalUrl(context, _privacyPolicyUrl);
                        },
                      ),
                      PerfilMenuItem(
                        icon: Icons.description_outlined,
                        title: 'Términos y condiciones',
                        subtitle: 'Condiciones de uso de la app',
                        onTap: () {
                          _openExternalUrl(context, _termsOfServiceUrl);
                        },
                      ),
                    ],
                  ),
                  if (!user.hasProviderAccess) ...[
                    const SizedBox(height: 30),
                    PerfilProviderCta(onTap: onOpenProviderView),
                  ],
                  const SizedBox(height: 28),
                  PerfilLogoutButton(onTap: onLogout),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PerfilLoginView extends StatelessWidget {
  const _PerfilLoginView({required this.onAuthenticated});

  final VoidCallback onAuthenticated;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 36),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              gradient: LinearGradient(
                colors: context.isDarkMode
                    ? const [Color(0xFF121714), Color(0xFF17251A)]
                    : const [Color(0xFFFDFDFD), Color(0xFFF4F7F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 8),
                Icon(
                  Icons.person_outline_rounded,
                  size: 72,
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: context.isDarkMode
                        ? context.appTextPrimary
                        : const Color(0xFF0C2A18),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Inicia sesión para ver\ny gestionar tu perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: context.isDarkMode
                        ? context.appTextSecondary
                        : const Color(0xFF36533D),
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -26),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: LoginContent(
                compact: true,
                onAuthenticated: onAuthenticated,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
