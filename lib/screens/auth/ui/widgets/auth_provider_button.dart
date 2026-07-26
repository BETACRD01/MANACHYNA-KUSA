import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';

class AuthProviderButton extends StatelessWidget {
  const AuthProviderButton({
    super.key,
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
