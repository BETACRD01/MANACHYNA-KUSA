import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_theme_colors.dart';
import '../../../../../models/user/user_model.dart';

class PerfilHeader extends StatefulWidget {
  const PerfilHeader({
    required this.user,
    required this.onEditPhoto,
    Key? key,
  }) : super(key: key);

  final UserModel user;
  final VoidCallback onEditPhoto;

  @override
  State<PerfilHeader> createState() => _PerfilHeaderState();
}

class _PerfilHeaderState extends State<PerfilHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerGradient = context.isDarkMode
        ? const [Color(0xFF121714), Color(0xFF17251A), Color(0xFF203321)]
        : const [Color(0xFFFDFDFD), Color(0xFFF4F7F5), Color(0xFFE9F2EC)];
    final nameColor =
        context.isDarkMode ? context.appTextPrimary : const Color(0xFF0C2A18);
    final emailColor =
        context.isDarkMode ? context.appTextSecondary : const Color(0xFF36533D);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        // Animación suave de elevación y rotación
        final breathe = Curves.easeInOutSine.transform(
          progress <= 0.5 ? progress * 2 : (1 - progress) * 2,
        );
        final avatarLift = -6 * breathe;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 54),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: headerGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Animación de rotación lenta fondo 1
              Positioned(
                right: -40,
                top: -10,
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
              ),
              // Animación de rotación lenta fondo 2 (inversa)
              Positioned(
                left: -50,
                bottom: 20,
                child: RotationTransition(
                  turns: Tween(begin: 1.0, end: 0.0).animate(_controller),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -20,
                top: 18,
                child: Transform.translate(
                  offset: Offset(0, avatarLift * -0.7),
                  child: Container(
                    width: 118,
                    height: 118,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(34),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -28,
                bottom: 8,
                child: Container(
                  width: 98,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 36),
                  Transform.translate(
                    offset: Offset(0, avatarLift),
                    child: Transform.scale(
                      scale: 1 + (0.018 * breathe),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 126,
                            height: 126,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.96),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.lerp(
                                  Colors.white,
                                  const Color(0xFFE5F0E7),
                                  breathe,
                                )!,
                                width: 3.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.08 + (0.06 * breathe),
                                  ),
                                  blurRadius: 20 + (8 * breathe),
                                  offset: Offset(0, 8 + (4 * breathe)),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: widget.user.profileImageUrl?.isNotEmpty ==
                                      true
                                  ? Image.network(
                                      widget.user.profileImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          PerfilAvatarFallback(
                                        userName: widget.user.name,
                                      ),
                                    )
                                  : PerfilAvatarFallback(
                                      userName: widget.user.name,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.user.name.isEmpty ? 'Usuario' : widget.user.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: nameColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.user.displayEmail,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: emailColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class PerfilSection extends StatelessWidget {
  const PerfilSection({
    required this.title,
    required this.children,
    Key? key,
  }) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1)
                  Divider(
                    height: 1,
                    indent: 86,
                    endIndent: 20,
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class PerfilMenuItem extends StatelessWidget {
  const PerfilMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconBackground = context.appSoftGreen;
    final titleColor = context.appTextPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 25),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: context.appTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: context.appTextPrimary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PerfilProviderCta extends StatelessWidget {
  const PerfilProviderCta({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradientColors = context.isDarkMode
        ? const [Color(0xFF162419), Color(0xFF1C2E20)]
        : const [Color(0xFFF2F8F1), Color(0xFFEAF3E9)];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.appBorder),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.business_center_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Quieres ser proveedor?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Ofrece tus servicios y consigue más clientes.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: context.appTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: context.appTextPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PerfilLogoutButton extends StatelessWidget {
  const PerfilLogoutButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Cerrar sesión'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error, width: 1.2),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class PerfilAvatarFallback extends StatelessWidget {
  const PerfilAvatarFallback({required this.userName, Key? key})
      : super(key: key);

  final String userName;

  @override
  Widget build(BuildContext context) {
    final letter = userName.trim().isEmpty ? 'U' : userName.trim()[0];
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEBF3EA), Color(0xFFBFD8BE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        letter.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 44,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
