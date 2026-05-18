import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme_colors.dart';
import '../../../models/user_model.dart';

class PerfilProviderRegistrationView extends StatefulWidget {
  const PerfilProviderRegistrationView({
    required this.user,
    required this.onBack,
    required this.onSubmitted,
    Key? key,
  }) : super(key: key);

  final UserModel user;
  final VoidCallback onBack;
  final VoidCallback onSubmitted;

  @override
  State<PerfilProviderRegistrationView> createState() =>
      _PerfilProviderRegistrationViewState();
}

class _PerfilProviderRegistrationViewState
    extends State<PerfilProviderRegistrationView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cedulaController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _whatsappController;
  late final TextEditingController _addressController;
  late final TextEditingController _referenceController;
  late final TextEditingController _experienceController;
  late final TextEditingController _bioController;

  String _city = 'Tena';
  double _radiusKm = 10;
  bool _acceptsReview = false;
  final Set<String> _selectedServices = <String>{};
  final Set<String> _documents = <String>{};

  static const _cities = [
    'Tena',
    'Archidona',
    'Carlos Julio Arosemena Tola',
    'El Chaco',
    'Quijos',
  ];

  static const _services = [
    'Limpieza',
    'Plomería',
    'Electricidad',
    'Carpintería',
    'Pintura',
    'Jardinería',
    'Mantenimiento',
    'Tecnología',
  ];

  static const _requiredDocuments = [
    'Cédula frontal',
    'Cédula posterior',
    'Foto de perfil',
    'Evidencia de experiencia',
  ];

  @override
  void initState() {
    super.initState();
    _cedulaController = TextEditingController();
    _fullNameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _whatsappController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _referenceController = TextEditingController();
    _experienceController = TextEditingController();
    _bioController = TextEditingController(text: widget.user.description ?? '');
    if (_cities.contains(widget.user.city)) {
      _city = widget.user.city;
    }
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _referenceController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RegistrationHeader(onBack: widget.onBack),
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                const _ProviderRegistrationIntro(),
                const SizedBox(height: 18),
                _RegistrationSection(
                  title: 'Identidad',
                  subtitle: 'Datos legales para verificar al proveedor.',
                  children: [
                    _ProviderTextField(
                      controller: _cedulaController,
                      label: 'Cédula',
                      hint: 'Ej. 1501234567',
                      icon: Icons.badge_outlined,
                      keyboardType: TextInputType.number,
                      validator: _validateCedula,
                    ),
                    const SizedBox(height: 14),
                    _ProviderTextField(
                      controller: _fullNameController,
                      label: 'Nombres completos',
                      hint: 'Como aparece en la cédula',
                      icon: Icons.person_outline_rounded,
                      textCapitalization: TextCapitalization.words,
                      validator: _requiredValidator,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _RegistrationSection(
                  title: 'Contacto y cobertura',
                  subtitle: 'Cómo te contactarán y dónde puedes atender.',
                  children: [
                    _ProviderTextField(
                      controller: _phoneController,
                      label: 'Teléfono',
                      hint: 'Número principal',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: _phoneValidator,
                    ),
                    const SizedBox(height: 14),
                    _ProviderTextField(
                      controller: _whatsappController,
                      label: 'WhatsApp',
                      hint: 'Número para coordinar reservas',
                      icon: Icons.chat_outlined,
                      keyboardType: TextInputType.phone,
                      validator: _phoneValidator,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _city,
                      dropdownColor: context.appSurface,
                      decoration: _inputDecoration(
                        context,
                        label: 'Ciudad base',
                        icon: Icons.location_city_outlined,
                      ),
                      items: _cities
                          .map(
                            (city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _city = value);
                      },
                    ),
                    const SizedBox(height: 14),
                    _ProviderTextField(
                      controller: _addressController,
                      label: 'Dirección',
                      hint: 'Barrio, calle o comunidad',
                      icon: Icons.home_outlined,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: 14),
                    _ProviderTextField(
                      controller: _referenceController,
                      label: 'Referencia',
                      hint: 'Cerca de...',
                      icon: Icons.place_outlined,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: 18),
                    _RadiusSelector(
                      value: _radiusKm,
                      onChanged: (value) => setState(() => _radiusKm = value),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _RegistrationSection(
                  title: 'Servicios',
                  subtitle:
                      'Elige lo que sabes hacer y cuéntanos tu experiencia.',
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _services.map((service) {
                        final selected = _selectedServices.contains(service);
                        return FilterChip(
                          selected: selected,
                          label: Text(service),
                          selectedColor: AppColors.primary.withValues(
                            alpha: context.isDarkMode ? 0.28 : 0.16,
                          ),
                          checkmarkColor: AppColors.primary,
                          backgroundColor: context.appMutedSurface,
                          side: BorderSide(
                            color: selected
                                ? AppColors.primary
                                : context.appBorder,
                          ),
                          labelStyle: TextStyle(
                            color: selected
                                ? AppColors.primary
                                : context.appTextPrimary,
                            fontWeight:
                                selected ? FontWeight.w800 : FontWeight.w600,
                          ),
                          onSelected: (_) {
                            setState(() {
                              selected
                                  ? _selectedServices.remove(service)
                                  : _selectedServices.add(service);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    _ProviderTextField(
                      controller: _experienceController,
                      label: 'Años de experiencia',
                      hint: 'Ej. 3',
                      icon: Icons.workspace_premium_outlined,
                      keyboardType: TextInputType.number,
                      validator: _experienceValidator,
                    ),
                    const SizedBox(height: 14),
                    _ProviderTextField(
                      controller: _bioController,
                      label: 'Descripción del servicio',
                      hint:
                          'Describe tu forma de trabajo, horarios y fortalezas',
                      icon: Icons.description_outlined,
                      minLines: 4,
                      maxLines: 6,
                      validator: _requiredValidator,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _RegistrationSection(
                  title: 'Documentos',
                  subtitle:
                      'Estos archivos se subirán a Supabase Storage cuando se conecte el backend.',
                  children: [
                    for (final document in _requiredDocuments)
                      _DocumentRequirementTile(
                        title: document,
                        isSelected: _documents.contains(document),
                        onChanged: () {
                          setState(() {
                            _documents.contains(document)
                                ? _documents.remove(document)
                                : _documents.add(document);
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                const _RegistrationChecklistCard(
                  items: [
                    'Cédula válida y visible por ambos lados.',
                    'Datos de contacto reales para confirmar reservas.',
                    'Al menos un servicio seleccionado.',
                    'Descripción clara para que el cliente confíe.',
                  ],
                ),
                const SizedBox(height: 18),
                CheckboxListTile(
                  value: _acceptsReview,
                  onChanged: (value) =>
                      setState(() => _acceptsReview = value ?? false),
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    'Confirmo que mis datos son reales y acepto la revisión del perfil.',
                    style: TextStyle(
                      color: context.appTextPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _RegistrationFooter(onSubmit: _submit),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este dato es obligatorio';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    final text = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (text.length < 9 || text.length > 10) {
      return 'Ingresa un teléfono válido';
    }
    return null;
  }

  String? _experienceValidator(String? value) {
    final years = int.tryParse(value?.trim() ?? '');
    if (years == null || years < 0 || years > 60) {
      return 'Ingresa años válidos';
    }
    return null;
  }

  String? _validateCedula(String? value) {
    final cedula = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (cedula.length != 10) {
      return 'La cédula debe tener 10 dígitos';
    }

    final province = int.tryParse(cedula.substring(0, 2)) ?? 0;
    if (province < 1 || province > 24) {
      return 'Provincia de cédula inválida';
    }

    final thirdDigit = int.tryParse(cedula[2]) ?? 10;
    if (thirdDigit > 5) {
      return 'Cédula inválida';
    }

    var total = 0;
    for (var i = 0; i < 9; i++) {
      var digit = int.parse(cedula[i]);
      if (i.isEven) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      total += digit;
    }

    final expected = total % 10 == 0 ? 0 : 10 - (total % 10);
    final verifier = int.parse(cedula[9]);
    if (expected != verifier) {
      return 'Dígito verificador incorrecto';
    }

    return null;
  }

  void _submit() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      return;
    }
    if (_selectedServices.isEmpty) {
      _showError('Selecciona al menos un servicio.');
      return;
    }
    if (_documents.length < _requiredDocuments.length) {
      _showError('Marca todos los documentos requeridos.');
      return;
    }
    if (!_acceptsReview) {
      _showError('Debes aceptar la revisión del perfil.');
      return;
    }

    widget.onSubmitted();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}

class _RegistrationHeader extends StatelessWidget {
  const _RegistrationHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 20, 8),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registro de proveedor',
                    style: TextStyle(
                      color: context.appTextPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Completa tu solicitud para ofrecer servicios',
                    style: TextStyle(
                      color: context.appTextSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProviderRegistrationIntro extends StatelessWidget {
  const _ProviderRegistrationIntro();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.isDarkMode
              ? const [Color(0xFF162419), Color(0xFF1E3322)]
              : const [Color(0xFFEFF8EE), Color(0xFFF8FCF7)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verificación segura',
                  style: TextStyle(
                    color: context.appTextPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pedimos cédula y datos de servicio para proteger a clientes y proveedores.',
                  style: TextStyle(
                    color: context.appTextSecondary,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrationSection extends StatelessWidget {
  const _RegistrationSection({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.appBorder),
        boxShadow: context.appCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: context.appTextSecondary,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _ProviderTextField extends StatelessWidget {
  const _ProviderTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.minLines = 1,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int minLines;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: context.appTextPrimary),
      decoration: _inputDecoration(
        context,
        label: label,
        hint: hint,
        icon: icon,
      ),
    );
  }
}

class _RadiusSelector extends StatelessWidget {
  const _RadiusSelector({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.radar_outlined,
              color: AppColors.primary,
              size: 21,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Radio de atención',
                style: TextStyle(
                  color: context.appTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${value.round()} km',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 2,
          max: 50,
          divisions: 24,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _DocumentRequirementTile extends StatelessWidget {
  const _DocumentRequirementTile({
    required this.title,
    required this.isSelected,
    required this.onChanged,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onChanged,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? context.appSoftGreen : context.appMutedSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : context.appBorder,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.upload_file_outlined,
                color:
                    isSelected ? AppColors.primary : context.appTextSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: context.appTextPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                isSelected ? 'Listo' : 'Pendiente',
                style: TextStyle(
                  color:
                      isSelected ? AppColors.primary : context.appTextSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegistrationChecklistCard extends StatelessWidget {
  const _RegistrationChecklistCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.appMutedSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos que debe pedir el registro',
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: context.appTextSecondary,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RegistrationFooter extends StatelessWidget {
  const _RegistrationFooter({required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: BoxDecoration(
          color: context.appSurface,
          border: Border(top: BorderSide(color: context.appBorder)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.send_rounded),
            label: const Text('Enviar solicitud'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(
  BuildContext context, {
  required String label,
  String? hint,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: Icon(icon, color: AppColors.primary),
    filled: true,
    fillColor: context.appMutedSurface,
    labelStyle: TextStyle(color: context.appTextSecondary),
    hintStyle: TextStyle(color: context.appTextSecondary),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: context.appBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error, width: 1.4),
    ),
  );
}
