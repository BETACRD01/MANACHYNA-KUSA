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
    this.title = 'Ingresa a Mañachiy kan Kusata',
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
      _didNavigate = true;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  Future<void> _signInWithProvider(OAuthProvider provider) async {
    final authProvider = context.read<AuthProvider>();
    _didNavigate = false;
    await authProvider.signInWithProvider(provider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showBackButton
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: AppColors.textPrimary,
            )
          : null,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final compactWidth = screenWidth < 360;
            final compactHeight = screenHeight < 700;
            final horizontalPadding = compactWidth ? 16.0 : 24.0;
            final topSpacing = compactHeight ? 24.0 : 52.0;
            final logoSize = compactWidth ? 76.0 : 88.0;
            final logoIconSize = compactWidth ? 36.0 : 42.0;
            final titleSize = compactWidth ? 22.0 : 26.0;
            final subtitleSize = compactWidth ? 15.0 : 16.0;
            final buttonHeight = compactWidth ? 58.0 : 64.0;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: topSpacing),
                      Center(
                        child: Container(
                          width: logoSize,
                          height: logoSize,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(
                              compactWidth ? 22 : 24,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary.withValues(alpha: 0.18),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.home_repair_service,
                            size: logoIconSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: compactWidth ? 22 : 28),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                      SizedBox(height: compactHeight ? 28 : 36),
                      _AuthProviderButton(
                        label: 'Continuar con Google',
                        assetPath: 'assets/social/google.svg',
                        height: buttonHeight,
                        onPressed: () =>
                            _signInWithProvider(OAuthProvider.google),
                      ),
                      const SizedBox(height: 16),
                      _AuthProviderButton(
                        label: 'Continuar con Facebook',
                        assetPath: 'assets/social/facebook.svg',
                        height: buttonHeight,
                        onPressed: () =>
                            _signInWithProvider(OAuthProvider.facebook),
                      ),
                      const SizedBox(height: 16),
                      _AuthProviderButton(
                        label: 'Continuar con Microsoft',
                        assetPath: 'assets/social/microsoft.svg',
                        height: buttonHeight,
                        onPressed: () =>
                            _signInWithProvider(OAuthProvider.azure),
                      ),
                      SizedBox(height: compactHeight ? 24 : 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthProviderButton extends StatelessWidget {
  const _AuthProviderButton({
    required this.label,
    required this.assetPath,
    required this.height,
    required this.onPressed,
  });

  final String label;
  final String assetPath;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SizedBox(
          height: height,
          child: OutlinedButton(
            onPressed: authProvider.isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(
                color: AppColors.divider,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: authProvider.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        assetPath,
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
