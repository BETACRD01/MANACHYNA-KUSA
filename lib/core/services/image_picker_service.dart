// lib/core/services/image_picker_service.dart

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FIX 3 · Función top-level para compute()
// compute() exige una función top-level (o static) serializable.
// Recibe los bytes originales y devuelve los bytes procesados,
// todo dentro de un isolate separado → la UI no se bloquea.
// ─────────────────────────────────────────────────────────────────────────────
Uint8List _processImageBytes(Uint8List imageBytes) {
  final img.Image? decoded = img.decodeImage(imageBytes);
  if (decoded == null) throw Exception('No se pudo decodificar la imagen');

  // Redimensionar solo si supera el límite
  final img.Image resized = (decoded.width > ImagePickerService.maxDimension ||
          decoded.height > ImagePickerService.maxDimension)
      ? img.copyResize(
          decoded,
          width: ImagePickerService.maxDimension,
          height: ImagePickerService.maxDimension,
          interpolation: img.Interpolation.linear,
        )
      : decoded;

  return Uint8List.fromList(
    img.encodeJpg(resized, quality: ImagePickerService.jpegQuality),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Servicio principal
// ─────────────────────────────────────────────────────────────────────────────
class ImagePickerService {
  ImagePickerService._(); // clase no instanciable

  static final ImagePicker _picker = ImagePicker();

  // Constantes expuestas para que _processImageBytes (top-level) las use.
  static const int maxDimension = 800;
  static const int jpegQuality = 85;
  static const double maxFileSizeMB = 15.0;

  // ── UI ──────────────────────────────────────────────────────────────────

  /// Muestra el bottom sheet de selección de fuente.
  /// Retorna el [File] procesado o `null` si el usuario cancela.
  static Future<File?> showImageSourceSelection(BuildContext context) {
    return showModalBottomSheet<File?>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Handle visual
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Seleccionar imagen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSourceOption(
                          sheetContext,
                          icon: Icons.camera_alt,
                          label: 'Cámara',
                          onTap: () async {
                            // FIX 1 · Un solo Navigator.pop devuelve el archivo
                            // y cierra el sheet simultáneamente.
                            // El sheet permanece en background mientras la cámara
                            // está activa, lo cual es el comportamiento correcto.
                            final File? file = await pickImageFromCamera();
                            if (sheetContext.mounted) {
                              Navigator.pop(sheetContext, file);
                            }
                          },
                        ),
                        _buildSourceOption(
                          sheetContext,
                          icon: Icons.photo_library,
                          label: 'Galería',
                          onTap: () async {
                            final File? file = await pickImageFromGallery();
                            if (sheetContext.mounted) {
                              Navigator.pop(sheetContext, file);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSourceOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Selección ────────────────────────────────────────────────────────────

  /// Captura una imagen desde la cámara.
  static Future<File?> pickImageFromCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        throw Exception('Permisos de cámara denegados');
      }

      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (picked == null) return null;
      return _processImage(File(picked.path));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('pickImageFromCamera: $e');
      }
      rethrow;
    }
  }

  /// Selecciona una imagen desde la galería.
  static Future<File?> pickImageFromGallery() async {
    try {
      if (!await _requestGalleryPermission()) {
        throw Exception('Permisos de galería denegados');
      }

      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (picked == null) return null;
      return _processImage(File(picked.path));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('pickImageFromGallery: $e');
      }
      rethrow;
    }
  }

  // ── Procesamiento ────────────────────────────────────────────────────────

  /// Valida, redimensiona y comprime la imagen.
  static Future<File> _processImage(File imageFile) async {
    // FIX 4 · Validar tamaño ANTES de leer los bytes completos en memoria
    final double sizeMB = await getFileSizeInMB(imageFile);
    if (sizeMB > maxFileSizeMB) {
      throw Exception(
        'La imagen supera el límite permitido de ${maxFileSizeMB.toInt()} MB',
      );
    }

    final Uint8List originalBytes = await imageFile.readAsBytes();

    // FIX 3 · compute() delega el trabajo al isolate → UI libre durante
    // la decodificación/compresión (especialmente notable en gama baja)
    final Uint8List processedBytes =
        await compute(_processImageBytes, originalBytes);

    // FIX 5 · Nombre con prefijo reconocible para facilitar la limpieza
    final Directory tempDir = await getTemporaryDirectory();
    final String fileName =
        'mk_img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File output = File(path.join(tempDir.path, fileName));
    await output.writeAsBytes(processedBytes);

    if (kDebugMode) {
      final double originalKB = originalBytes.length / 1024;
      final double compressedKB = processedBytes.length / 1024;
      final double reduction = (originalKB - compressedKB) / originalKB * 100;
      debugPrint(
        '✅ Imagen procesada | '
        '${originalKB.toStringAsFixed(0)} KB → '
        '${compressedKB.toStringAsFixed(0)} KB | '
        '${reduction.toStringAsFixed(1)}% reducción',
      );
    }

    return output;
  }

  // ── Limpieza de temporales ───────────────────────────────────────────────

  /// FIX 5 · Elimina los archivos temporales generados por este servicio.
  ///
  /// Llamar al cerrar sesión, al salir de la pantalla de perfil,
  /// o al confirmar que la imagen ya fue subida a Supabase Storage.
  static Future<void> clearTemporaryFiles() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      int deleted = 0;

      for (final entity in tempDir.listSync()) {
        if (entity is File &&
            path.basename(entity.path).startsWith('mk_img_') &&
            entity.path.endsWith('.jpg')) {
          await entity.delete();
          deleted++;
        }
      }

      if (kDebugMode && deleted > 0) {
        debugPrint('🗑 clearTemporaryFiles: $deleted archivo(s) eliminados');
      }
    } catch (e) {
      // No relanzar — la limpieza es no crítica
      if (kDebugMode) {
        debugPrint('clearTemporaryFiles: $e');
      }
    }
  }

  // ── Permisos ─────────────────────────────────────────────────────────────

  static Future<bool> _requestCameraPermission() async {
    try {
      return await Permission.camera.request() == PermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('_requestCameraPermission: $e');
      }
      return false;
    }
  }

  static Future<bool> _requestGalleryPermission() async {
    try {
      if (Platform.isAndroid) {
        // FIX 2 · Usa device_info_plus para detectar la versión real del SDK
        final bool isAndroid13 = await _isAndroid13OrHigher();
        final PermissionStatus status = isAndroid13
            ? await Permission.photos.request() // API 33+ → READ_MEDIA_IMAGES
            : await Permission.storage
                .request(); // API ≤32 → READ_EXTERNAL_STORAGE
        return status == PermissionStatus.granted;
      }

      // iOS: image_picker usa PHPickerViewController desde iOS 14,
      // que no requiere permisos de usuario explícitos.
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('_requestGalleryPermission: $e');
      }
      return false;
    }
  }

  /// FIX 2 · Detecta Android 13 (API 33) correctamente con device_info_plus.
  static Future<bool> _isAndroid13OrHigher() async {
    if (!Platform.isAndroid) return false;
    try {
      final AndroidDeviceInfo info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt >= 33;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('_isAndroid13OrHigher: $e');
      }
      // Fallback conservador: usar Permission.storage (compatible con API ≤32)
      return false;
    }
  }

  // ── Utilidades públicas ──────────────────────────────────────────────────

  /// Verifica si el archivo es una imagen válida decodificable.
  static Future<bool> isValidImage(File imageFile) async {
    try {
      final Uint8List bytes = await imageFile.readAsBytes();
      return img.decodeImage(bytes) != null;
    } catch (_) {
      return false;
    }
  }

  /// Tamaño del archivo en MB.
  static Future<double> getFileSizeInMB(File file) async {
    try {
      return await file.length() / (1024 * 1024);
    } catch (_) {
      return 0.0;
    }
  }
}
