import 'package:chime_app/api_service.dart';
import 'package:flutter/foundation.dart';

class LanguageLevelModel with ChangeNotifier {
  String? _languageLevel;

  String? get languageLevel => _languageLevel;

  void setLanguageLevel(String? level) {
    _languageLevel = level;
    ApiService().languageLevel = _languageLevel ?? 'Beginner'; // [1]
    notifyListeners();
  }
}

/**
 * To access _languageLevel later, use Provider class
 * Provider.of<LanguageLevelModel>(context).languageLevel
 */
