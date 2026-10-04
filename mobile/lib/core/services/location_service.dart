import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Verifica permisos y estado del GPS en un solo paso.
  /// Retorna true solo si el GPS está activo y el permiso concedido.
  static Future<bool> requestLocationPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kDebugMode) {
          debugPrint('LocationService: GPS desactivado');
        }
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            debugPrint('LocationService: permiso denegado');
          }
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          debugPrint('LocationService: permiso denegado permanentemente');
        }
        return false;
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al solicitar permiso de ubicación: $e');
      }
      return false;
    }
  }

  /// Obtiene la posición actual con timeout de 10 segundos.
  /// Retorna null si el GPS está desactivado, sin permiso o hay error.
  static Future<Position?> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kDebugMode) {
          debugPrint('LocationService: GPS desactivado');
        }
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            if (kDebugMode) {
              debugPrint('LocationService: permiso denegado');
            }
            return null;
          }
        }

      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          debugPrint('LocationService: permiso denegado permanentemente');
        }
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al obtener ubicación: $e');
      }
      return null;
    }
  }

  /// Calcula la distancia en metros entre dos coordenadas.
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// Formatea una distancia en metros a texto legible.
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }
}
