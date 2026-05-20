import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language_code';
  String _currentLanguageCode = 'es';

  LanguageProvider() {
    _loadLanguageCode();
  }

  String get currentLanguageCode => _currentLanguageCode;

  String get currentLanguageName {
    switch (_currentLanguageCode) {
      case 'en':
        return 'English';
      case 'qu':
        return 'Kichwa (Runashimi)';
      case 'es':
      default:
        return 'Español';
    }
  }

  Future<void> _loadLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? langCode = prefs.getString(_languageKey);

    if (langCode != null) {
      _currentLanguageCode = langCode;
      notifyListeners();
    }
  }

  Future<void> setLanguage(String code) async {
    if (_currentLanguageCode == code) return;

    _currentLanguageCode = code;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, code);
  }
}
