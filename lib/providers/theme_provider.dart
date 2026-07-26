import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  // ---------------------------------------------------------------------------
  // CARGA INICIAL
  // ---------------------------------------------------------------------------

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? themeStr = prefs.getString(_themeKey);

      if (themeStr == null) return;

      // Intenta parsear con el formato nuevo (.name → "dark", "light", "system").
      // Si byName falla (ArgumentError), intenta el formato antiguo
      // ("ThemeMode.dark") para compatibilidad con datos guardados antes de
      // esta versión, antes de caer al valor por defecto.
      ThemeMode resolved;
      try {
        resolved = ThemeMode.values.byName(themeStr);
      } on ArgumentError {
        // Compatibilidad hacia atrás: el formato viejo era "ThemeMode.<name>"
        final legacyName = themeStr.startsWith('ThemeMode.')
            ? themeStr.substring('ThemeMode.'.length)
            : null;

        if (legacyName != null) {
          try {
            resolved = ThemeMode.values.byName(legacyName);
          } on ArgumentError {
            debugPrint('[ThemeProvider._loadThemeMode] valor desconocido: '
                '"$themeStr" — usando ThemeMode.system.');
            resolved = ThemeMode.system;
          }
        } else {
          debugPrint('[ThemeProvider._loadThemeMode] valor desconocido: '
              '"$themeStr" — usando ThemeMode.system.');
          resolved = ThemeMode.system;
        }
      }

      _themeMode = resolved;
      notifyListeners();
    } catch (e) {
      // SharedPreferences no disponible o fallo de I/O.
      // Se deja _themeMode en ThemeMode.system sin interrumpir el arranque.
      debugPrint('[ThemeProvider._loadThemeMode] error al leer preferencias: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // ACTUALIZACIÓN
  // ---------------------------------------------------------------------------

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    // Actualización optimista: la UI responde de inmediato.
    final previous = _themeMode;
    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      // Guarda con el formato nuevo (.name → "dark", "light", "system").
      await prefs.setString(_themeKey, mode.name);
    } catch (e) {
      // La persistencia falló. Se revierte al valor anterior para que la UI
      // sea coherente con lo que se guardará en el próximo inicio de la app.
      debugPrint('[ThemeProvider.setThemeMode] error al guardar preferencias: $e');
      _themeMode = previous;
      notifyListeners();
    }
  }
}
