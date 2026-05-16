import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      bool success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(authProvider.errorMessage ?? 'Error al iniciar sesión'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo y título
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.home_repair_service,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        AppStrings.appName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bienvenido de vuelta',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Campos de entrada
                CustomTextField(
                  label: AppStrings.email,
                  controller: _emailController,
                  validator: Validators.validateEmail,
                  isEmail: true,
                  prefixIcon: Icons.email_outlined,
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  label: AppStrings.password,
                  controller: _passwordController,
                  validator: Validators.validatePassword,
                  isPassword: true,
                  prefixIcon: Icons.lock_outlined,
                ),

                const SizedBox(height: 16),

                // Olvidé mi contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showForgotPasswordDialog,
                    child: const Text(
                      AppStrings.forgotPassword,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Botón de login
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: AppStrings.login,
                      onPressed: _handleLogin,
                      isLoading: authProvider.isLoading,
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Divider
                const Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.divider)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'o',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),

                const SizedBox(height: 24),

                // Botón de registro
                CustomButton(
                  text: 'Crear cuenta nueva',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  isOutlined: true,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar Contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: AppStrings.email,
              controller: emailController,
              validator: Validators.validateEmail,
              isEmail: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return TextButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        if (emailController.text.isNotEmpty) {
                          bool success = await authProvider.resetPassword(
                            emailController.text.trim(),
                          );

                          if (!context.mounted) return;

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Email de recuperación enviado'
                                    : 'Error al enviar email',
                              ),
                              backgroundColor:
                                  success ? AppColors.success : AppColors.error,
                            ),
                          );
                        }
                      },
                child: authProvider.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enviar'),
              );
            },
          ),
        ],
      ),
    );
  }
}
