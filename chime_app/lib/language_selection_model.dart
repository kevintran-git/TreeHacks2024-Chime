import 'package:flutter/foundation.dart';
import 'package:chime_app/api_service.dart';

Map<String, String> languageLocaleMap = {
  'Chinese': 'zh',
  'English': 'en',
  'French': 'fr',
  'German': 'de',
  'Hindi': 'hi',
  'Italian': 'it',
  'Norwegian': 'no',
  'Thai': 'th',
  'Spanish': 'es',
  'Vietnamese': 'vi',
};
// Example usage:

class LanguageSelectionModel with ChangeNotifier {
  String? _nativeLanguage;
  String? _learningLanguage;
  String? _learningLanguageLocale; // ie. English is en
  String? _firstPromptTitle;

  String? get nativeLanguage => _nativeLanguage;
  String? get learningLanguage => _learningLanguage;
  String? get learningLanguageLocale => _learningLanguageLocale;
  String? get firstPromptTitle => _firstPromptTitle;

  void setNativeLanguage(String? newLanguage) {
    _nativeLanguage = newLanguage;
    ApiService().nativeLanguage = _nativeLanguage ?? 'English';
    notifyListeners();
  }

  void setFirstPromptTitle(String? newTitle) {
    _firstPromptTitle = newTitle;
    notifyListeners();
  }

  void setLearningLanguage(String? newLanguage) {
    _learningLanguage = newLanguage;
    _learningLanguageLocale = languageLocaleMap[_learningLanguage]; // 'ja'
    final ApiService apiService = ApiService();
    apiService.initTTS(_learningLanguageLocale);
    apiService.learningLanguage = _learningLanguage ?? 'None';
    notifyListeners();
  }
}
