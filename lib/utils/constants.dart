import 'package:flutter/material.dart';

class AppColors {
  // Фиолетовые цвета
  static const purplePrimary = Color(0xFF6A1B9A); // Основной фиолетовый
  static const purpleDark = Color(0xFF4A148C);     // Темный фиолетовый
  static const purpleLight = Color(0xFF9C4DFF);    // Светлый фиолетовый
  static const purpleAccent = Color(0xFFE1BEE7);   // Акцентный фиолетовый
  
  // Белые и серые
  static const white = Color(0xFFFFFFFF);
  static const backgroundLight = Color(0xFFF5F5F5); // Светлый фон
  static const cardLight = Color(0xFFFFFFFF);      // Карточки светлые
  static const textLight = Color(0xFF333333);      // Текст светлый
  static const textLightSecondary = Color(0xFF666666); // Вторичный текст
  
  // Черные для темной темы
  static const black = Color(0xFF000000);
  static const backgroundDark = Color(0xFF121212); // Темный фон
  static const cardDark = Color(0xFF1E1E1E);       // Карточки темные
  static const textDark = Color(0xFFE0E0E0);       // Текст темный
  static const textDarkSecondary = Color(0xFFB0B0B0); // Вторичный текст темный
  
  // Статусные цвета
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFF44336);
  static const info = Color(0xFF2196F3);
  
  // Дополнительные
  static const grey = Color(0xFF9E9E9E);
  static const greyDark = Color(0xFF616161);
}

class AppSpacing {
  // Основные отступы
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
  
  // Стандартные отступы для контента
  static const screenPadding = lg;
  static const cardPadding = lg;
  static const itemSpacing = md;
}

class AppBorderRadius {
  // Стандартные радиусы скругления
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const circle = 50.0;
  
  // Предустановленные BorderRadius
  static const allMd = BorderRadius.all(Radius.circular(md));
  static const allLg = BorderRadius.all(Radius.circular(lg));
}

class AppTypography {
  // Заголовки
  static const titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
  
  static const titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  
  static const titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  // Основной текст
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  
  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  
  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  
  // Ярлыки и подписи
  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  
  static const labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}

class AppStrings {
  static const appName = 'Corporate App';
}