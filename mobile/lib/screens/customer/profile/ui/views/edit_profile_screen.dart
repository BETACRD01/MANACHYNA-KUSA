import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_theme_colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/services/image_picker_service.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../../../models/user/user_model.dart';
import '../../../../../providers/auth_provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _bioController;

  bool _isSaving = false;
  bool _isUploadingImage = false;
  File? _localImageFile;
  String? _uploadedImageUrl;
  String _completePhoneNumber = '';

  String _extractNationalNumber(String phone) {
    if (phone.isEmpty) return '';
    if (phone.startsWith('+')) {
      if (phone.startsWith('+593')) return phone.substring(4).trim();
      if (phone.startsWith('+57')) return phone.substring(3).trim();
      if (phone.startsWith('+51')) return phone.substring(3).trim();
      if (phone.startsWith('+1')) return phone.substring(2).trim();
      if (phone.startsWith('+34')) return phone.substring(3).trim();
      
      final parts = phone.split(' ');
      if (parts.length > 1) {
        return parts.sublist(1).join('').trim();
      }
      if (phone.length > 4) {
        return phone.substring(4).trim();
      }
    }
    return phone;
  }

  String _determineInitialCountryCode(String phone) {
    if (phone.isEmpty) return 'EC';
    if (phone.startsWith('+')) {
      if (phone.startsWith('+593')) return 'EC';
      if (phone.startsWith('+57')) return 'CO';
      if (phone.startsWith('+51')) return 'PE';
      if (phone.startsWith('+1')) return 'US';
      if (phone.startsWith('+34')) return 'ES';
    }
    return 'EC';
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    
    final rawPhone = user?.phone ?? '';
    _completePhoneNumber = rawPhone;

    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: _extractNationalNumber(rawPhone));
    _addressController = TextEditingController(text: user?.address ?? '');
    _cityController = TextEditingController(text: user?.city ?? '');
    _bioController = TextEditingController(text: user?.description ?? '');
    _uploadedImageUrl = user?.profileImageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage(UserModel user, AuthProvider authProvider) async {
    try {
      final file = await ImagePickerService.showImageSourceSelection(context);
      if (file == null) return;

      setState(() {
        _localImageFile = file;
        _isUploadingImage = true;
      });

      // 1. Subir la imagen a Supabase Storage
      final imageUrl = await StorageService.uploadProfileImage(
        userId: user.id,
        imageFile: file,
      );

      // 2. Limpiar imágenes antiguas en segundo plano (para ahorrar espacio)
      try {
        await StorageService.cleanupOldImages(user.id);
      } catch (e) {
        debugPrint('Error limpiando imágenes antiguas: $e');
      }

      // 3. Actualizar la URL de imagen en la tabla de base de datos
      final success = await authProvider.updateProfileImageUrl(imageUrl);

      if (success) {
        setState(() {
          _uploadedImageUrl = imageUrl;
        });
        if (mounted) {
          Helpers.showCustomSnackBar(
            context,
            message: 'Foto de perfil actualizada correctamente.',
          );
        }
      } else {
        throw Exception('No se pudo guardar la URL de la imagen en la base de datos.');
      }
    } catch (e) {
      if (mounted) {
        Helpers.showCustomSnackBar(
          context,
          message: 'Error al cambiar foto de perfil: ${e.toString().replaceAll('Exception:', '')}',
          isError: true,
        );
      }
      setState(() {
        _localImageFile = null; // Revertir miniatura local si falló
      });
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  Future<void> _saveProfile(UserModel user, AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final updatedUser = user.copyWith(
        name: _nameController.text.trim(),
        phone: _completePhoneNumber.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        description: user.hasProviderAccess ? _bioController.text.trim() : null,
      );

      final success = await authProvider.updateProfile(updatedUser);

      if (success) {
        if (mounted) {
          Helpers.showCustomSnackBar(
            context,
            message: 'Perfil guardado con éxito.',
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception('Error al actualizar registro en base de datos.');
      }
    } catch (e) {
      if (mounted) {
        Helpers.showCustomSnackBar(
          context,
          message: 'No se pudo guardar el perfil: ${e.toString().replaceAll('Exception:', '')}',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  bool _hasUnsavedChanges(UserModel user) {
    return _nameController.text.trim() != user.name ||
        _completePhoneNumber.trim() != user.phone ||
        _addressController.text.trim() != user.address ||
        _cityController.text.trim() != user.city ||
        (user.hasProviderAccess && _bioController.text.trim() != (user.description ?? '')) ||
        _localImageFile != null;
  }

  Future<bool> _onWillPop(UserModel user) async {
    if (!_hasUnsavedChanges(user)) return true;

    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.appSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '¿Descartar cambios?',
          style: TextStyle(
            color: context.appTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Tienes cambios sin guardar en tu perfil. ¿Estás seguro de que deseas salir?',
          style: TextStyle(color: context.appTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Seguir editando', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Descartar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuario no disponible')),
      );
    }

    return PopScope(
      canPop: !_hasUnsavedChanges(user) || _isSaving,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final shouldPop = await _onWillPop(user);
        if (shouldPop) {
          navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: context.appBackground,
        appBar: AppBar(
          backgroundColor: context.appBackground,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: context.appTextPrimary),
            onPressed: () async {
              final navigator = Navigator.of(context);
              if (await _onWillPop(user)) {
                navigator.pop();
              }
            },
          ),
          title: Text(
            'Editar Perfil',
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          actions: [
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
              )
            else
              TextButton(
                onPressed: () => _saveProfile(user, authProvider),
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAvatarSection(user, authProvider),
                  const SizedBox(height: 36),
                  _buildFormFields(user),
                  const SizedBox(height: 40),
                  _buildSaveButton(user, authProvider),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(UserModel user, AuthProvider authProvider) {
    ImageProvider? imageProvider;
    if (_localImageFile != null) {
      imageProvider = FileImage(_localImageFile!);
    } else if (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(_uploadedImageUrl!);
    }

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: context.appCardShadow,
              border: Border.all(color: context.appBorder, width: 3),
            ),
            child: CircleAvatar(
              radius: 64,
              backgroundColor: context.appMutedSurface,
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? Icon(
                      Icons.person_rounded,
                      size: 64,
                      color: context.appTextSecondary.withValues(alpha: 0.5),
                    )
                  : null,
            ),
          ),
          if (_isUploadingImage)
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 4,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isUploadingImage ? null : () => _pickAndUploadImage(user, authProvider),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(UserModel user) {
    final inputDecorationTheme = InputDecoration(
      filled: true,
      fillColor: context.appSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: TextStyle(color: context.appTextSecondary, fontSize: 14),
      floatingLabelStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: context.appBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INFORMACIÓN PERSONAL',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: context.appTextSecondary,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          style: TextStyle(color: context.appTextPrimary, fontWeight: FontWeight.w600),
          decoration: inputDecorationTheme.copyWith(
            labelText: 'Nombre Completo',
            prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor ingresa tu nombre completo';
            }
            if (value.trim().length < 3) {
              return 'El nombre debe tener al menos 3 caracteres';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          initialValue: user.displayEmail,
          enabled: false,
          style: TextStyle(color: context.appTextSecondary, fontWeight: FontWeight.w600),
          decoration: inputDecorationTheme.copyWith(
            labelText: 'Correo Electrónico (No editable)',
            fillColor: context.appMutedSurface,
            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textHint),
          ),
        ),
        const SizedBox(height: 20),
        IntlPhoneField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: TextStyle(color: context.appTextPrimary, fontWeight: FontWeight.w600),
          dropdownTextStyle: TextStyle(color: context.appTextPrimary, fontWeight: FontWeight.w600),
          dropdownIcon: Icon(Icons.arrow_drop_down, color: context.appTextSecondary),
          flagsButtonPadding: const EdgeInsets.only(left: 12),
          showCountryFlag: true,
          languageCode: 'es',
          initialCountryCode: _determineInitialCountryCode(user.phone),
          decoration: inputDecorationTheme.copyWith(
            labelText: 'Teléfono',
            hintText: 'Número de celular',
            prefixIcon: null,
          ),
          onChanged: (phone) {
            _completePhoneNumber = phone.completeNumber;
          },
          validator: (phone) {
            if (phone == null || phone.number.trim().isEmpty) {
              return 'Por favor ingresa tu número telefónico';
            }
            return null;
          },
        ),
        const SizedBox(height: 32),
        Text(
          'UBICACIÓN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: context.appTextSecondary,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cityController,
          style: TextStyle(color: context.appTextPrimary, fontWeight: FontWeight.w600),
          decoration: inputDecorationTheme.copyWith(
            labelText: 'Ciudad',
            prefixIcon: const Icon(Icons.location_city_outlined, color: AppColors.primary),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor ingresa tu ciudad';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _addressController,
          style: TextStyle(color: context.appTextPrimary, fontWeight: FontWeight.w600),
          decoration: inputDecorationTheme.copyWith(
            labelText: 'Dirección',
            prefixIcon: const Icon(Icons.map_outlined, color: AppColors.primary),
          ),
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor ingresa tu dirección';
            }
            return null;
          },
        ),
        if (user.hasProviderAccess) ...[
          const SizedBox(height: 32),
          Text(
            'PERFIL DE PROVEEDOR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: context.appTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _bioController,
            maxLines: 4,
            style: TextStyle(color: context.appTextPrimary, fontWeight: FontWeight.w500),
            decoration: inputDecorationTheme.copyWith(
              labelText: 'Biografía / Descripción del servicio',
              alignLabelWithHint: true,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Icon(Icons.edit_note_rounded, color: AppColors.primary),
              ),
            ),
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor describe los servicios que ofreces';
              }
              if (value.trim().length < 15) {
                return 'La descripción debe tener al menos 15 caracteres';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSaveButton(UserModel user, AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSaving ? null : () => _saveProfile(user, authProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Guardar Cambios',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
