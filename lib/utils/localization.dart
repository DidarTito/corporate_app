import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

/// Simple in-app localization helper for kz / ru / en.
class AppLocalizations {
  final String _lang;

  AppLocalizations(this._lang);

  factory AppLocalizations.of(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    return AppLocalizations(settings.language);
  }

  bool get _isKz => _lang == 'kz';
  bool get _isRu => _lang == 'ru';

  // General
  String get appName {
    if (_isKz) return 'Корпоративтік қосымша';
    if (_isRu) return 'Корпоративное приложение';
    return 'Corporate App';
  }

  // Auth / login
  String get loginTitle {
    if (_isKz) return 'Қайта оралуыңызбен';
    if (_isRu) return 'С возвращением';
    return 'Welcome Back';
  }

  String get loginSubtitle {
    if (_isKz) return 'Жалғастыру үшін кіріңіз';
    if (_isRu) return 'Войдите, чтобы продолжить';
    return 'Sign in to continue';
  }

  String get loginButton {
    if (_isKz) return 'КІРУ';
    if (_isRu) return 'ВХОД';
    return 'LOGIN';
  }

  String get noAccountRegister {
    if (_isKz) return 'Аккаунт жоқ па? Тіркелу';
    if (_isRu) return 'Нет аккаунта? Зарегистрироваться';
    return 'No account? Register';
  }

  String get registerTitle {
    if (_isKz) return 'Аккаунт құру';
    if (_isRu) return 'Создать аккаунт';
    return 'Create Account';
  }

  String get registerSubtitle {
    if (_isKz) return 'Бастау үшін тіркеліңіз';
    if (_isRu) return 'Зарегистрируйтесь, чтобы начать';
    return 'Sign up to get started';
  }

  String get registerButton {
    if (_isKz) return 'ТІРКЕЛУ';
    if (_isRu) return 'РЕГИСТРАЦИЯ';
    return 'REGISTER';
  }

  String get alreadyHaveAccountLogin {
    if (_isKz) return 'Аккаунт бар ма? Кіру';
    if (_isRu) return 'Уже есть аккаунт? Войти';
    return 'Already have an account? Login';
  }

  // Common field labels
  String get emailLabel {
    if (_isKz) return 'Email';
    if (_isRu) return 'Email';
    return 'Email';
  }

  String get passwordLabel {
    if (_isKz) return 'Құпия сөз';
    if (_isRu) return 'Пароль';
    return 'Password';
  }

  String get fullNameLabel {
    if (_isKz) return 'Толық аты-жөні';
    if (_isRu) return 'Полное имя';
    return 'Full Name';
  }

  String get phoneLabel {
    if (_isKz) return 'Телефон нөмірі';
    if (_isRu) return 'Номер телефона';
    return 'Phone Number';
  }

  String get clothingSizeLabel {
    if (_isKz) return 'Киім өлшемі';
    if (_isRu) return 'Размер одежды';
    return 'Clothing Size';
  }

  String get shoeSizeLabel {
    if (_isKz) return 'Аяқ киім өлшемі';
    if (_isRu) return 'Размер обуви';
    return 'Shoe Size';
  }

  // Home
  String get quickActionsTitle {
    if (_isKz) return 'Жылдам әрекеттер';
    if (_isRu) return 'Быстрые действия';
    return 'Quick Actions';
  }

  String get helpLabel {
    if (_isKz) return 'Көмек';
    if (_isRu) return 'Помощь';
    return 'Help';
  }

  String get contactsLabel {
    if (_isKz) return 'Контакттар';
    if (_isRu) return 'Контакты';
    return 'Contacts';
  }

  String get welcomeHomeTitle {
    if (_isKz) return 'Корпоративтік қосымшаға қош келдіңіз';
    if (_isRu) return 'Добро пожаловать в Corporate App';
    return 'Welcome to Corporate App';
  }

  String get welcomeHomeSubtitle {
    if (_isKz) return 'Барлығы бір жерде';
    if (_isRu) return 'Всё, что нужно, в одном месте';
    return 'Everything you need in one place';
  }

  // Profile
  String get pleaseLoginToViewProfile {
    if (_isKz) return 'Профильді көру үшін жүйеге кіріңіз';
    if (_isRu) return 'Войдите, чтобы просмотреть профиль';
    return 'Please login to view profile';
  }

  String get editProfileButton {
    if (_isKz) return 'Профильді өңдеу';
    if (_isRu) return 'Редактировать профиль';
    return 'Edit Profile';
  }

  String get settingsButton {
    if (_isKz) return 'Баптаулар';
    if (_isRu) return 'Настройки';
    return 'Settings';
  }

  String get noProfileData {
    if (_isKz) return 'Профиль деректері табылмады';
    if (_isRu) return 'Данные профиля не найдены';
    return 'No profile data found';
  }

  // Settings screen
  String get settingsTitle {
    if (_isKz) return 'Баптаулар';
    if (_isRu) return 'Настройки';
    return 'Settings';
  }

  String get languageTitle {
    if (_isKz) return 'Тіл';
    if (_isRu) return 'Язык';
    return 'Language';
  }

  String get darkModeTitle {
    if (_isKz) return 'Қараңғы режим';
    if (_isRu) return 'Тёмная тема';
    return 'Dark Mode';
  }

  String get appVersionTitle {
    if (_isKz) return 'Қосымша нұсқасы';
    if (_isRu) return 'Версия приложения';
    return 'App Version';
  }

  String get logoutTitle {
    if (_isKz) return 'Шығу';
    if (_isRu) return 'Выход';
    return 'Logout';
  }

  String get logoutQuestion {
    if (_isKz) return 'Шығуды растайсыз ба?';
    if (_isRu) return 'Вы действительно хотите выйти?';
    return 'Are you sure you want to logout?';
  }

  String get cancelButton {
    if (_isKz) return 'БАС ТАРТУ';
    if (_isRu) return 'ОТМЕНА';
    return 'CANCEL';
  }

  String get saveButton {
    if (_isKz) return 'САҚТАУ';
    if (_isRu) return 'СОХРАНИТЬ';
    return 'SAVE';
  }

  // Profile fields
  String get iinLabel {
    if (_isKz) return 'ЖСН';
    if (_isRu) return 'ИИН';
    return 'IIN';
  }

  String get positionLabel {
    if (_isKz) return 'Лауазым';
    if (_isRu) return 'Должность';
    return 'Position';
  }

  // Help screen
  String get helpTitle {
    if (_isKz) return 'КӨМЕК';
    if (_isRu) return 'ПОМОЩЬ';
    return 'HELP';
  }

  String get helpDescription {
    if (_isKz) return 'Қосымшамен байланысты мәселелер немесе сұрақтар болса, қолдау қызметіне хабарласыңыз';
    if (_isRu) return 'Если у вас есть проблемы с приложением или вопросы, свяжитесь со службой поддержки';
    return 'If you have issues with the app or questions, contact support';
  }

  String get supportService {
    if (_isKz) return 'Қолдау қызметі';
    if (_isRu) return 'Служба поддержки';
    return 'Support Service';
  }

  String get supportAvailable {
    if (_isKz) return 'Қолдау 24/7 қолжетімді';
    if (_isRu) return 'Поддержка доступна 24/7';
    return '24/7 Support Available';
  }

  String get callSupport {
    if (_isKz) return 'Қолдауға қоңырау шалу';
    if (_isRu) return 'Позвонить в поддержку';
    return 'Call Support';
  }

  String get emailSupport {
    if (_isKz) return 'Email арқылы қолдау';
    if (_isRu) return 'Поддержка по email';
    return 'Email Support';
  }

  String get responseTime {
    if (_isKz) return 'Жауап беру уақыты: 24 сағат ішінде';
    if (_isRu) return 'Время ответа: в течение 24 часов';
    return 'Response time: within 24 hours';
  }

  String get sendEmail {
    if (_isKz) return 'EMAIL ЖІБЕРУ';
    if (_isRu) return 'ОТПРАВИТЬ EMAIL';
    return 'SEND EMAIL';
  }

  String get cannotCallSupport {
    if (_isKz) return 'Қолдауға қоңырау шалу мүмкін емес';
    if (_isRu) return 'Невозможно позвонить в поддержку';
    return 'Cannot make call to support';
  }

  // Contacts screen
  String get contactsTitle {
    if (_isKz) return 'КОНТАКТТАР';
    if (_isRu) return 'КОНТАКТЫ';
    return 'CONTACTS';
  }

  String get selectDepartmentToCall {
    if (_isKz) return 'Қоңырау шалу үшін бөлімді таңдаңыз';
    if (_isRu) return 'Выберите отдел для звонка';
    return 'Select a department to call';
  }

  String get emergencyContacts {
    if (_isKz) return 'Төтенше жағдайлар үшін контакттар';
    if (_isRu) return 'Экстренные контакты';
    return 'Emergency Contacts';
  }

  String get emergencyServices {
    if (_isKz) return 'Төтенше қызметтер';
    if (_isRu) return 'Экстренные службы';
    return 'Emergency Services';
  }

  String get generalEmergency {
    if (_isKz) return '112 - Жалпы төтенше жағдай';
    if (_isRu) return '112 - Общая экстренная служба';
    return '112 - General Emergency';
  }

  String get ambulance {
    if (_isKz) return '103 - Жедел жәрдем';
    if (_isRu) return '103 - Скорая помощь';
    return '103 - Ambulance';
  }

  String get emergencyCall {
    if (_isKz) return 'ТӨТЕНШЕ ҚОҢЫРАУ';
    if (_isRu) return 'ЭКСТРЕННЫЙ ВЫЗОВ';
    return 'EMERGENCY CALL';
  }

  String cannotCall(String phoneNumber) {
    if (_isKz) return '$phoneNumber-ға қоңырау шалу мүмкін емес';
    if (_isRu) return 'Невозможно позвонить на $phoneNumber';
    return 'Cannot make call to $phoneNumber';
  }

  // Notifications
  String get notificationsTitle {
    if (_isKz) return 'ХАБАРЛАМАЛАР';
    if (_isRu) return 'УВЕДОМЛЕНИЯ';
    return 'NOTIFICATIONS';
  }

  String get noNotifications {
    if (_isKz) return 'Хабарламалар жоқ';
    if (_isRu) return 'Нет уведомлений';
    return 'No notifications';
  }

  // Profile Edit
  String get editProfileTitle {
    if (_isKz) return 'Профильді өңдеу';
    if (_isRu) return 'Редактировать профиль';
    return 'Edit Profile';
  }

  String get saveChanges {
    if (_isKz) return 'ӨЗГЕРІСТЕРДІ САҚТАУ';
    if (_isRu) return 'СОХРАНИТЬ ИЗМЕНЕНИЯ';
    return 'SAVE CHANGES';
  }

  String get saveChangesQuestion {
    if (_isKz) return 'Өзгерістерді сақтауды растайсыз ба?';
    if (_isRu) return 'Вы действительно хотите сохранить изменения?';
    return 'Are you sure you want to save the changes?';
  }

  String get profileUpdatedSuccessfully {
    if (_isKz) return 'Профиль сәтті жаңартылды';
    if (_isRu) return 'Профиль успешно обновлен';
    return 'Profile updated successfully';
  }

  String get hrManagedFieldsNote {
    if (_isKz) return 'Ескерту: ЖСН, Толық аты-жөні және Лауазым HR бөлімімен басқарылады және мұнда өзгертуге болмайды.';
    if (_isRu) return 'Примечание: ИИН, Полное имя и Должность управляются отделом HR и не могут быть изменены здесь.';
    return 'Note: IIN, Full Name, and Position are managed by HR department and cannot be changed here.';
  }

  String get emailLoginNote {
    if (_isKz) return 'Email өңдеуге болады, бірақ ол болашақ кірулер үшін пайдаланылады.';
    if (_isRu) return 'Email можно редактировать, но он будет использоваться для будущих входов.';
    return 'Email can be edited but will be used for future logins.';
  }

  // Settings dialogs
  String get selectLanguage {
    if (_isKz) return 'Тілді таңдау';
    if (_isRu) return 'Выбрать язык';
    return 'Select Language';
  }

  String get loggedInAs {
    if (_isKz) return 'Кіру:';
    if (_isRu) return 'Вход выполнен как:';
    return 'Logged in as:';
  }

  String get welcomeText {
    if (_isKz) return 'Қош келдіңіз,';
    if (_isRu) return 'Добро пожаловать,';
    return 'Welcome,';
  }
}

