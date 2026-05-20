import 'dart:io';
import 'package:flutter/foundation.dart';
import '../config/supabase_config.dart';
import 'supabase_service.dart';

class StorageService {
  static Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
    Function(double)? onProgress,
  }) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final objectPath = '$userId/$fileName';
      final fileBytes = await imageFile.readAsBytes();

      onProgress?.call(0.0); // inicio de subida
      await SupabaseService.client.storage
          .from(SupabaseConfig.profileImagesBucket)
          .uploadBinary(objectPath, fileBytes);
      onProgress?.call(1.0); // subida completada

      return SupabaseService.client.storage
          .from(SupabaseConfig.profileImagesBucket)
          .getPublicUrl(objectPath);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al subir imagen a Supabase Storage: $e');
      }
      throw Exception('Error al subir imagen: $e');
    }
  }

  static Future<void> deleteProfileImage(String imageUrl) async {
    try {
      if (imageUrl.isEmpty) return;

      const marker = '/object/public/${SupabaseConfig.profileImagesBucket}/';
      final index = imageUrl.indexOf(marker);
      if (index == -1) return;

      final objectPath = imageUrl.substring(index + marker.length);
      await SupabaseService.client.storage
          .from(SupabaseConfig.profileImagesBucket)
          .remove([objectPath]);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al eliminar imagen de Supabase Storage: $e');
      }
    }
  }

  // Filtra objetos de sistema como .emptyFolderPlaceholder
  static Future<List<String>> getUserProfileImages(String userId) async {
    try {
      final objects = await SupabaseService.client.storage
          .from(SupabaseConfig.profileImagesBucket)
          .list(path: userId);

      return objects
          .where((o) => !o.name.startsWith('.'))
          .map((object) => SupabaseService.client.storage
              .from(SupabaseConfig.profileImagesBucket)
              .getPublicUrl('$userId/${object.name}'))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al obtener imágenes: $e');
      }
      return [];
    }
  }

  // Mantiene solo las 3 imágenes más recientes por usuario
  static Future<void> cleanupOldImages(String userId) async {
    try {
      final objects = await SupabaseService.client.storage
          .from(SupabaseConfig.profileImagesBucket)
          .list(path: userId);

      // Filtra objetos de sistema antes de ordenar
      final filtered = objects.where((o) => !o.name.startsWith('.')).toList();

      if (filtered.length <= 3) return;

      // Ordena por createdAt para no depender del formato del nombre
      final sorted = [...filtered]..sort(
          (a, b) => (a.createdAt ?? '').compareTo(b.createdAt ?? ''),
        );

      final pathsToDelete = sorted
          .take(sorted.length - 3)
          .map((object) => '$userId/${object.name}')
          .toList();

      if (pathsToDelete.isNotEmpty) {
        await SupabaseService.client.storage
            .from(SupabaseConfig.profileImagesBucket)
            .remove(pathsToDelete);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error en limpieza de imágenes: $e');
      }
    }
  }
}
