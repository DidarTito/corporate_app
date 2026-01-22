import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  // Language settings
  String _language = 'ru';
  String get language => _language;
  
  // Theme settings
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  
  // Login email (будет сохранен из логина)
  String _loginEmail = '';
  String get loginEmail => _loginEmail;
  
  // User data
  final Map<String, String> _userData = {
    'phoneNumber': '+7 777 123 4567',
    'email': 'john.doe@company.com', // Дефолтный email
    'clothingSize': 'M',
    'shoeSize': '42',
  };
  
  Map<String, String> get userData => _userData;
  
  // Change language
  void changeLanguage(String newLanguage) {
    _language = newLanguage;
    notifyListeners();
  }
  
  // Toggle dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  // Save login email
  void saveLoginEmail(String email) {
    _loginEmail = email;
    notifyListeners();
  }
  
  // Update user data
  void updateUserData(String key, String value) {
    _userData[key] = value;
    
    // Если обновляем email, обновляем и loginEmail
    if (key == 'email') {
      _loginEmail = value;
    }
    
    notifyListeners();
  }
  
  // Get available languages
  List<String> get availableLanguages => ['kz', 'ru', 'en'];
  
  // Get language display name
  String getLanguageDisplayName(String code) {
    switch (code) {
      case 'kz':
        return 'Қазақша';
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      default:
        return 'Русский';
    }
  }
  
  // Logout
  void logout() {
    // In real app, this would clear tokens and reset state
    _language = 'ru';
    _isDarkMode = false;
    _loginEmail = '';
    notifyListeners();
  }
}