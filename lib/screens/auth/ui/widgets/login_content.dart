import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../providers/auth_provider.dart';
import '../../controllers/login_controller.dart';
import 'auth_provider_button.dart';

class LoginContent extends StatefulWidget {
  const LoginContent({
    super.key,
    this.onAuthenticated,
    this.compact = false,
    this.title = 'Ingresa a MANACHYNA KUSA',
    this.subtitle = 'Usa tu cuenta de Google, Facebook o Microsoft.',
  });

  final VoidCallback? onAuthenticated;
  final bool compact;
  final String title;
  final String subtitle;

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  LoginController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      _controller = LoginController(auth);
      auth.addListener(_handleAuthStateChanged);
      _handleAuthStateChanged();
    });
  }

  @override
  void dispose() {
    context.read<AuthProvider>().removeListener(_handleAuthStateChanged);
    _controller?.dispose();
    super.dispose();
  }

  void _handleAuthStateChanged() {
    if (!mounted || _controller == null) return;

    final authProvider = _controller!.authProvider;

    if (authProvider.errorMessage != null) {
      Helpers.showCustomSnackBar(
        context,
        message: authProvider.errorMessage!,
        isError: true,
      );
      authProvider.clearError();
    }

    if (authProvider.successMessage != null) {
      Helpers.showCustomSnackBar(
        context,
        message: authProvider.successMessage!,
        isError: false,
      );
      authProvider.clearSuccess();
    }

    if (_controller!.checkNavigationAndReset()) {
      widget.onAuthenticated?.call();
    }
  }

  Future<void> _signInWithProvider(OAuthProvider provider) async {
    if (_controller != null) {
      await _controller!.signInWithProvider(provider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final compact = widget.compact;
        final logoSize = compact ? 80.0 : 100.0;
        final titleSize = compact ? 24.0 : 28.0;
        final subtitleSize = compact ? 14.0 : 15.0;
        final buttonHeight = compact ? 52.0 : 60.0;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 0 : 32,
            vertical: compact ? 0 : 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!compact) ...[
                Image.asset(
                  'assets/branding/manachyna_kusa_logo_transparent.png',
                  width: logoSize,
                  height: logoSize,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 28),
              ],
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(
                      text: 'Ingresa a\n',
                      style: TextStyle(
                          color: compact
                              ? AppColors.textPrimary
                              : const Color(0xFF1B2E1E)),
                    ),
                    TextSpan(
                      text: 'MANACHYNA KUSA',
                      style: TextStyle(
                          color: compact
                              ? AppColors.primary
                              : const Color(0xFF146A21)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B8E3F),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Inicia sesión con tu cuenta de\nGoogle, Facebook o Microsoft.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              AuthProviderButton(
                label: 'Continuar con Google',
                assetPath: 'assets/social/google.svg',
                height: buttonHeight,
                isLoading: false,
                isDisabled: authProvider.isLoading,
                onPressed: () => _signInWithProvider(OAuthProvider.google),
              ),
              const SizedBox(height: 12),
              AuthProviderButton(
                label: 'Continuar con Facebook',
                assetPath: 'assets/social/facebook.svg',
                height: buttonHeight,
                isLoading: false,
                isDisabled: authProvider.isLoading,
                onPressed: () => _signInWithProvider(OAuthProvider.facebook),
              ),
              const SizedBox(height: 12),
              AuthProviderButton(
                label: 'Continuar con Microsoft',
                assetPath: 'assets/social/microsoft.svg',
                height: buttonHeight,
                isLoading: false,
                isDisabled: authProvider.isLoading,
                onPressed: () => _signInWithProvider(OAuthProvider.azure),
              ),
              if (!compact) ...[
                const SizedBox(height: 28),
                const Column(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: Color(0xFF3B8E3F),
                      size: 24,
                    ),
                    SizedBox(height: 6),
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
            ],
          ),
        );
      },
    );
  }
}
