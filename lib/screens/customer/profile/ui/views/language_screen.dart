// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_theme_colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../providers/language_provider.dart';

class _LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String subtitle;
  final String flagEmoji;
  final IconData icon;
  final Color color;

  const _LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.subtitle,
    required this.flagEmoji,
    required this.icon,
    required this.color,
  });
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String _selectedLanguageCode;

  final List<_LanguageOption> _options = const [
    _LanguageOption(
      code: 'es',
      name: 'Español',
      nativeName: 'Español',
      subtitle: 'Idioma oficial por defecto',
      flagEmoji: '🇪🇨',
      icon: Icons.translate_rounded,
      color: AppColors.primary,
    ),
    _LanguageOption(
      code: 'qu',
      name: 'Kichwa',
      nativeName: 'Kichwa (Runashimi)',
      subtitle: 'Runa shimi - Napo marka',
      flagEmoji: '🌄',
      icon: Icons.wb_sunny_rounded,
      color: Colors.amber,
    ),
    _LanguageOption(
      code: 'en',
      name: 'Inglés',
      nativeName: 'English',
      subtitle: 'For international visitors',
      flagEmoji: '🇺🇸',
      icon: Icons.language_rounded,
      color: Colors.blue,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Obtener el idioma actual desde el provider
    _selectedLanguageCode = context.read<LanguageProvider>().currentLanguageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        backgroundColor: context.appBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: context.appTextPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Idioma de la App',
          style: TextStyle(
            color: context.appTextPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabecera Premium de la pantalla de idiomas
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.08),
                            AppColors.secondary.withOpacity(0.04),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.12),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.g_translate_rounded,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Elige tu idioma preferido',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: context.appTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Personaliza tu experiencia de servicio. Valoramos la riqueza cultural e identitaria de Napo al ofrecer soporte para la lengua nativa.',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: context.appTextSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'IDIOMAS DISPONIBLES',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: context.appTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Lista animada de opciones de idiomas
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _options.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final option = _options[index];
                        final isSelected = _selectedLanguageCode == option.code;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? option.color.withOpacity(0.04)
                                : context.appSurface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? option.color
                                  : context.appBorder.withOpacity(0.6),
                              width: isSelected ? 2 : 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: option.color.withOpacity(0.12),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [],
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedLanguageCode = option.code;
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Row(
                                children: [
                                  // Leading círculo con bandera/icono
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: option.color.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        option.flagEmoji,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Info de Idioma
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          option.nativeName,
                                          style: TextStyle(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w800,
                                            color: context.appTextPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          option.subtitle,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: context.appTextSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Trailing checkmark/indicador
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? option.color
                                            : context.appBorder,
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? option.color
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? const Center(
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Botón inferior para Guardar cambios
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.24),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _saveLanguage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveLanguage() {
    final languageProvider = context.read<LanguageProvider>();
    languageProvider.setLanguage(_selectedLanguageCode).then((_) {
      if (!mounted) return;
      
      final selectedOption = _options.firstWhere((o) => o.code == _selectedLanguageCode);
      Helpers.showCustomSnackBar(
        context,
        message: 'Idioma cambiado a ${selectedOption.nativeName}',
      );
      Navigator.pop(context);
    }).catchError((e) {
      if (!mounted) return;
      Helpers.showCustomSnackBar(
        context,
        message: 'Error al cambiar idioma: $e',
        isError: true,
      );
    });
  }
}
