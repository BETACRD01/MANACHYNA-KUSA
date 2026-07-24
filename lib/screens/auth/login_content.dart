import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/helpers.dart';
import '../../providers/auth_provider.dart';

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
  AuthProvider? _authProvider;
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
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
    if (!mounted || _authProvider == null) return;

    final authProvider = _authProvider!;

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

    if (authProvider.isAuthenticated && !_didNavigate) {
      _didNavigate = true;
      widget.onAuthenticated?.call();
    }
  }

  Future<void> _signInWithProvider(OAuthProvider provider) async {
    final authProvider = context.read<AuthProvider>();
    _didNavigate = false;

    await authProvider.signInWithProvider(provider);
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
                      style: TextStyle(color: compact ? AppColors.textPrimary : const Color(0xFF1B2E1E)),
                    ),
                    TextSpan(
                      text: 'MANACHYNA KUSA',
                      style: TextStyle(color: compact ? AppColors.primary : const Color(0xFF146A21)),
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
              _AuthProviderButton(
                label: 'Continuar con Google',
                assetPath: 'assets/social/google.svg',
                height: buttonHeight,
                isLoading: false,
                isDisabled: authProvider.isLoading,
                onPressed: () => _signInWithProvider(OAuthProvider.google),
              ),
              const SizedBox(height: 12),
              _AuthProviderButton(
                label: 'Continuar con Facebook',
                assetPath: 'assets/social/facebook.svg',
                height: buttonHeight,
                isLoading: false,
                isDisabled: authProvider.isLoading,
                onPressed: () => _signInWithProvider(OAuthProvider.facebook),
              ),
              const SizedBox(height: 12),
              _AuthProviderButton(
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

class _AuthProviderButton extends StatelessWidget {
  const _AuthProviderButton({
    required this.label,
    required this.assetPath,
    required this.height,
    required this.isLoading,
    required this.isDisabled,
    required this.onPressed,
  });

  final String label;
  final String assetPath;
  final double height;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          side: BorderSide(
            color: isDisabled && !isLoading
                ? const Color(0xFFE5E7EB).withAlpha((0.5 * 255).round())
                : const Color(0xFFE5E7EB),
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
                  Opacity(
                    opacity: isDisabled && !isLoading ? 0.4 : 1.0,
                    child: SvgPicture.asset(
                      assetPath,
                      width: 28,
                      height: 28,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDisabled && !isLoading
                            ? const Color(0xFF111827)
                                .withAlpha((0.4 * 255).round())
                            : const Color(0xFF111827),
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
