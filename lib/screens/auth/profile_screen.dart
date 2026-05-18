import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_theme_colors.dart';
import '../../core/utils/helpers.dart';
import '../../core/widgets/loading_widget.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import 'perfil/perfil_provider_view.dart';
import 'perfil/perfil_widgets.dart';

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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              });

              return const Center(
                child: LoadingWidget(message: 'Volviendo al inicio...'),
              );
            }

            if (_showProviderView) {
              return PerfilProviderView(
                onBack: () => setState(() => _showProviderView = false),
                onApply: _showProviderInfo,
              );
            }

            return _PerfilMainView(
              user: user,
              onEditPhoto: _showEditPhotoMessage,
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

  void _showEditPhotoMessage() {
    Helpers.showCustomSnackBar(
      context,
      message: 'Pronto podrás cambiar tu foto de perfil.',
    );
  }

  void _showComingSoon() {
    Helpers.showCustomSnackBar(
      context,
      message: 'Esta opción estará disponible pronto.',
    );
  }

  void _showProviderInfo() {
    Helpers.showCustomSnackBar(
      context,
      message: 'El registro de proveedor se conectará con Supabase.',
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
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
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
    required this.onOpenProviderView,
    required this.onMenuTap,
    required this.onLogout,
  });

  final UserModel user;
  final VoidCallback onEditPhoto;
  final VoidCallback onOpenProviderView;
  final VoidCallback onMenuTap;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

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
                        onTap: onMenuTap,
                      ),
                      PerfilMenuItem(
                        icon: Icons.lock_outline_rounded,
                        title: 'Cambiar contraseña',
                        subtitle: 'Mantén tu cuenta segura',
                        onTap: onMenuTap,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  PerfilSection(
                    title: 'Preferencias',
                    children: [
                      PerfilMenuItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notificaciones',
                        subtitle: 'Gestiona tus notificaciones',
                        onTap: onMenuTap,
                      ),
                      PerfilMenuItem(
                        icon: Icons.language_rounded,
                        title: 'Idioma',
                        subtitle: 'Español',
                        onTap: onMenuTap,
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
                        onTap: onMenuTap,
                      ),
                      PerfilMenuItem(
                        icon: Icons.mail_outline_rounded,
                        title: 'Contáctanos',
                        subtitle: 'Estamos para ayudarte',
                        onTap: onMenuTap,
                      ),
                    ],
                  ),
                  if (user.userType != UserType.provider) ...[
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
