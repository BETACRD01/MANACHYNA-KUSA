import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    this.showBackButton = false,
    this.title =
        'Ingresa a DESARROLLO DE APLICACION MOVIL MULTISERVICIO "MANACHYNA KUSA"',
    this.subtitle = 'Usa tu cuenta de Google, Facebook o Microsoft.',
  }) : super(key: key);

  final bool showBackButton;
  final String title;
  final String subtitle;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthProvider? _authProvider;
  bool _didNavigate = false;
  OAuthProvider? _pendingProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _authProvider = context.read<AuthProvider>();
      _authProvider!.addListener(_handleAuthStateChanged);
      _handleAuthStateChanged();
    });
  }

  @override
  void dispose() {
    _authProvider?.removeListener(_handleAuthStateChanged);
    super.dispose();
  }

  void _handleAuthStateChanged() {
    if (!mounted || _authProvider == null) {
      return;
    }

    final authProvider = _authProvider!;

    if (authProvider.errorMessage != null) {
      setState(() {
        _pendingProvider = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
      authProvider.clearError();
    }

    if (authProvider.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.successMessage!),
          backgroundColor: AppColors.info,
        ),
      );
      authProvider.clearSuccess();
    }

    if (authProvider.isAuthenticated && !_didNavigate) {
      setState(() {
        _pendingProvider = null;
      });
      _didNavigate = true;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  Future<void> _signInWithProvider(OAuthProvider provider) async {
    final authProvider = context.read<AuthProvider>();
    _didNavigate = false;
    setState(() {
      _pendingProvider = provider;
    });

    final launched = await authProvider.signInWithProvider(provider);
    if (!launched && mounted) {
      setState(() {
        _pendingProvider = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: widget.showBackButton
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: AppColors.textPrimary,
                )
              : null,
          body: Stack(
            children: [
          // Fondo decorativo - Esquina superior derecha
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          // Fondo decorativo - Esquina inferior izquierda
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final compactWidth = screenWidth < 360;
                final horizontalPadding = compactWidth ? 20.0 : 32.0;
                final buttonHeight = compactWidth ? 56.0 : 60.0;

                return CustomScrollView(
                  physics: const ClampingScrollPhysics(), // Only scrolls if content actually overflows
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(flex: 2),
                          // Ícono central (Maletín)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B8E3F), // Verde de la imagen
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF3B8E3F).withValues(alpha: 0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.business_center,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Título principal de acceso
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Ingresa a\n',
                                  style: TextStyle(color: Color(0xFF1B2E1E)),
                                ),
                                TextSpan(
                                  text:
                                      'DESARROLLO DE APLICACION MOVIL\nMULTISERVICIO "MANACHYNA KUSA"',
                                  style: TextStyle(color: Color(0xFF146A21)),
                                ),
                              ],
                            ),
                          ),
                          
                          // Pequeño divisor verde
                          const SizedBox(height: 16),
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B8E3F),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Subtítulo
                          const Text(
                            'Inicia sesión con tu cuenta de\nGoogle, Facebook o Microsoft.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6B7280),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Botones de Proveedores
                          _AuthProviderButton(
                            label: 'Continuar con Google',
                            assetPath: 'assets/social/google.svg',
                            height: buttonHeight,
                            isLoading:
                                authProvider.isLoading &&
                                _pendingProvider == OAuthProvider.google,
                            onPressed: () =>
                                _signInWithProvider(OAuthProvider.google),
                          ),
                          const SizedBox(height: 16),
                          _AuthProviderButton(
                            label: 'Continuar con Facebook',
                            assetPath: 'assets/social/facebook.svg',
                            height: buttonHeight,
                            isLoading:
                                authProvider.isLoading &&
                                _pendingProvider == OAuthProvider.facebook,
                            onPressed: () =>
                                _signInWithProvider(OAuthProvider.facebook),
                          ),
                          const SizedBox(height: 16),
                          _AuthProviderButton(
                            label: 'Continuar con Microsoft',
                            assetPath: 'assets/social/microsoft.svg',
                            height: buttonHeight,
                            isLoading:
                                authProvider.isLoading &&
                                _pendingProvider == OAuthProvider.azure,
                            onPressed: () =>
                                _signInWithProvider(OAuthProvider.azure),
                          ),
                          
                          const Spacer(flex: 3),
                          
                          // Footer: Privacidad de datos
                          const Column(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: Color(0xFF3B8E3F),
                                size: 28,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tus datos están protegidos\ny siempre serán privados.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
            ],
          ),
        );
      },
    );
  }
}

class _AuthProviderButton extends StatelessWidget {
  const _AuthProviderButton({
    required this.label,
    required this.assetPath,
    required this.height,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final String assetPath;
  final double height;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          side: const BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Row(
                children: [
                  SvgPicture.asset(
                    assetPath,
                    width: 28,
                    height: 28,
                  ),
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
      ),
    );
  }
}
