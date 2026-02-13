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

  // Release 2 - Profile extensions
  String get photoLabel {
    if (_isKz) return 'Фото';
    if (_isRu) return 'Фото';
    return 'Photo';
  }

  String get ratingLabel {
    if (_isKz) return 'Рейтинг';
    if (_isRu) return 'Рейтинг';
    return 'Rating';
  }

  String get awardsLabel {
    if (_isKz) return 'Марапаттар';
    if (_isRu) return 'Награды';
    return 'Awards';
  }

  String get childrenLabel {
    if (_isKz) return 'Балалар туралы ақпарат';
    if (_isRu) return 'Сведения о детях';
    return 'Children Information';
  }

  String get uploadPhoto {
    if (_isKz) return 'Фото жүктеу';
    if (_isRu) return 'Загрузить фото';
    return 'Upload Photo';
  }

  String get changePhoto {
    if (_isKz) return 'Фотоны өзгерту';
    if (_isRu) return 'Изменить фото';
    return 'Change Photo';
  }

  // Release 2 - Status
  String get statusLabel {
    if (_isKz) return 'Ағымдағы мәртебе';
    if (_isRu) return 'Текущий статус';
    return 'Current Status';
  }

  String get statusActive {
    if (_isKz) return 'Белсенді';
    if (_isRu) return 'Активен';
    return 'Active';
  }

  String get statusVacation {
    if (_isKz) return 'Демалыс';
    if (_isRu) return 'Отпуск';
    return 'Vacation';
  }

  String get statusTransfer {
    if (_isKz) return 'Ауыстыру';
    if (_isRu) return 'Перевод';
    return 'Transfer';
  }

  // Release 2 - Home additions
  String get bonusLabel {
    if (_isKz) return 'Бонус';
    if (_isRu) return 'Бонус';
    return 'Bonus';
  }

  String get bonusPoints {
    if (_isKz) return 'Баллдар';
    if (_isRu) return 'Баллы';
    return 'Points';
  }

  String get balanceLabel {
    if (_isKz) return 'Баланс';
    if (_isRu) return 'Баланс';
    return 'Balance';
  }

  String get shiftsWorkedLabel {
    if (_isKz) return 'Орындалған ауысымдар';
    if (_isRu) return 'Отработано смен';
    return 'Shifts Worked';
  }

  String get newsLabel {
    if (_isKz) return 'Жаңалықтар';
    if (_isRu) return 'Новости';
    return 'News';
  }

  String get referralProgram {
    if (_isKz) return 'Рефералдық бағдарлама';
    if (_isRu) return 'Реферальная программа';
    return 'Referral Program';
  }

  String get referralCode {
    if (_isKz) return 'Рефералдық код';
    if (_isRu) return 'Реферальный код';
    return 'Referral Code';
  }

  String get referralLink {
    if (_isKz) return 'Рефералдық сілтеме';
    if (_isRu) return 'Реферальная ссылка';
    return 'Referral Link';
  }

  String get copyLink {
    if (_isKz) return 'Сілтемені көшіру';
    if (_isRu) return 'Копировать ссылку';
    return 'Copy Link';
  }

  String get linkCopied {
    if (_isKz) return 'Сілтеме көшірілді';
    if (_isRu) return 'Ссылка скопирована';
    return 'Link Copied';
  }

  // Release 2 - Finance
  String get financeTitle {
    if (_isKz) return 'Қаржы';
    if (_isRu) return 'Финансы';
    return 'Finance';
  }

  String get currentObject {
    if (_isKz) return 'Ағымдағы объект';
    if (_isRu) return 'Текущий объект';
    return 'Current Object';
  }

  String get historyLabel {
    if (_isKz) return 'Тарих';
    if (_isRu) return 'История';
    return 'History';
  }

  String get totalShifts {
    if (_isKz) return 'Жалпы ауысымдар';
    if (_isRu) return 'Всего смен';
    return 'Total Shifts';
  }

  String get trainingDeductions {
    if (_isKz) return 'Оқу орталығы үшін удержания';
    if (_isRu) return 'Удержания за УЦ';
    return 'Training Deductions';
  }

  String get totalBalance {
    if (_isKz) return 'Жалпы баланс';
    if (_isRu) return 'Общий баланс';
    return 'Total Balance';
  }

  String get completedVolume {
    if (_isKz) return 'Орындалған көлем';
    if (_isRu) return 'Выполненный объём';
    return 'Completed Volume';
  }

  String get paymentLabel {
    if (_isKz) return 'Төлем';
    if (_isRu) return 'Выплата';
    return 'Payment';
  }

  // Release 2 - Company
  String get companyTitle {
    if (_isKz) return 'Компания';
    if (_isRu) return 'Компания';
    return 'Company';
  }

  String get companyNews {
    if (_isKz) return 'Компания жаңалықтары';
    if (_isRu) return 'Новости компании';
    return 'Company News';
  }

  String get projectRecruitment {
    if (_isKz) return 'Жобаға қабылдау';
    if (_isRu) return 'Набор на проекты';
    return 'Project Recruitment';
  }

  String get trainingMaterials {
    if (_isKz) return 'Оқу материалдары';
    if (_isRu) return 'Учебные материалы';
    return 'Training Materials';
  }

  String get memosLabel {
    if (_isKz) return 'Ескертпелер';
    if (_isRu) return 'Памятки';
    return 'Memos';
  }

  // Release 2 - Search
  String get searchHint {
    if (_isKz) return 'Іздеу...';
    if (_isRu) return 'Поиск...';
    return 'Search...';
  }

  String get noResults {
    if (_isKz) return 'Нәтижелер табылмады';
    if (_isRu) return 'Результаты не найдены';
    return 'No results found';
  }

  // Release 2 - Chat
  String get chatLabel {
    if (_isKz) return 'Чат';
    if (_isRu) return 'Чат';
    return 'Chat';
  }

  String get onlineChat {
    if (_isKz) return 'Онлайн чат';
    if (_isRu) return 'Онлайн чат';
    return 'Online Chat';
  }

  String get typeMessage {
    if (_isKz) return 'Хабарлама енгізіңіз...';
    if (_isRu) return 'Введите сообщение...';
    return 'Type a message...';
  }

  String get sendMessage {
    if (_isKz) return 'Жіберу';
    if (_isRu) return 'Отправить';
    return 'Send';
  }

  // Release 2 - FAQ
  String get faqTitle {
    if (_isKz) return 'Жиі қойылатын сұрақтар';
    if (_isRu) return 'Часто задаваемые вопросы';
    return 'FAQ';
  }

  String get frequentlyAskedQuestions {
    if (_isKz) return 'Жиі қойылатын сұрақтар';
    if (_isRu) return 'Часто задаваемые вопросы';
    return 'Frequently Asked Questions';
  }

  // Release 2 - Profile Photo & Enhancements
  String get uploadPhotoLabel {
    if (_isKz) return 'Фото жүктеу';
    if (_isRu) return 'Загрузить фото';
    return 'Upload Photo';
  }

  String get noAwards {
    if (_isKz) return 'Әлі ешбір сыйлықтар жоқ';
    if (_isRu) return 'Пока нет наград';
    return 'No awards yet';
  }

  String get addAward {
    if (_isKz) return 'Сыйлық қосу';
    if (_isRu) return 'Добавить награду';
    return 'Add Award';
  }

  String get awardName {
    if (_isKz) return 'Сыйлықтың атауы';
    if (_isRu) return 'Название награды';
    return 'Award name';
  }

  String get noChildren {
    if (_isKz) return 'Әлі балалар жоқ';
    if (_isRu) return 'Пока нет детей';
    return 'No children yet';
  }

  String get addChild {
    if (_isKz) return 'Балаларды қосу';
    if (_isRu) return 'Добавить ребенка';
    return 'Add Child';
  }

  String get childName {
    if (_isKz) return 'Ребенок атауы';
    if (_isRu) return 'Имя ребенка';
    return 'Child name';
  }

  String get certificateNumber {
    if (_isKz) return 'Сертификат номері';
    if (_isRu) return 'Номер сертификата';
    return 'Certificate number';
  }

  String get addButton {
    if (_isKz) return 'Қосу';
    if (_isRu) return 'Добавить';
    return 'Add';
  }

  String get photoUploadFailed {
    if (_isKz) return 'Фото жүктеу сәтсіз аяқталды';
    if (_isRu) return 'Не удалось загрузить фото';
    return 'Photo upload failed';
  }

  // Contact Card & Department
  String get callButton {
    if (_isKz) return 'ҚОҢЫРАУ';
    if (_isRu) return 'ЗВОНОК';
    return 'CALL';
  }

  String get hrDepartment {
    if (_isKz) return 'HR бөлімі';
    if (_isRu) return 'Отдел HR';
    return 'HR Department';
  }

  String get itSupport {
    if (_isKz) return 'IT қолдау';
    if (_isRu) return 'IT поддержка';
    return 'IT Support';
  }

  String get financeDepartment {
    if (_isKz) return 'Қаржы бөлімі';
    if (_isRu) return 'Финансовый отдел';
    return 'Finance Department';
  }

  String get securityDepartment {
    if (_isKz) return 'Қауіпсіздік бөлімі';
    if (_isRu) return 'Отдел безопасности';
    return 'Security Department';
  }

  String get facilityManagement {
    if (_isKz) return 'Объект басқармасы';
    if (_isRu) return 'Управление имуществом';
    return 'Facility Management';
  }

  String get legalDepartment {
    if (_isKz) return 'Құқық бөлімі';
    if (_isRu) return 'Юридический отдел';
    return 'Legal Department';
  }

  // Additional Localization
  String get birthDateLabel {
    if (_isKz) return 'Туған күні';
    if (_isRu) return 'Дата рождения';
    return 'Birth Date';
  }

  String get deleteButton {
    if (_isKz) return 'Өшіру';
    if (_isRu) return 'Удалить';
    return 'Delete';
  }

  String get onlineChatSubtitle {
    if (_isKz) return 'Қызмет көрсету тағдырын қамтамасыз ету';
    if (_isRu) return 'Связь со службой обеспечения сотрудников';
    return 'Connect with employee support service';
  }

  String get hrRecruitment {
    if (_isKz) return 'HR, жалдау, қызметтік қарым-қатынас';
    if (_isRu) return 'HR, рекрутмент, отношения с сотрудниками';
    return 'Human Resources, recruitment, employee relations';
  }

  String get itIssues {
    if (_isKz) return 'Техникалық мәселелер, бағдарлама, аппараттық қолдау';
    if (_isRu) return 'Технические проблемы, программное обеспечение, поддержка оборудования';
    return 'Technical issues, software, hardware support';
  }

  String get payrollFinance {
    if (_isKz) return 'Ай жалақы, ақшалау, қаржылық сұрақтар';
    if (_isRu) return 'Зарплата, счета, финансовые вопросы';
    return 'Payroll, invoices, financial queries';
  }

  String get buildingAccess {
    if (_isKz) return 'Құрылым қолжетімсіздігі, қауіпсіздік, төтенше жағдайлар';
    if (_isRu) return 'Доступ к зданию, безопасность, чрезвычайные ситуации';
    return 'Building access, safety, emergencies';
  }

  String get maintenanceRepairs {
    if (_isKz) return 'Техническое обслуживание, ремонт, офисные расходники';
    if (_isRu) return 'Обслуживание, ремонт, офисные принадлежности';
    return 'Maintenance, repairs, office supplies';
  }

  String get legalAdvice {
    if (_isKz) return 'Құқықтық кеңес, келісім, сәйкестік';
    if (_isRu) return 'Юридическая консультация, контракты, соответствие';
    return 'Legal advice, contracts, compliance';
  }

  // Notification Details Localization
  String get notificationTitle {
    if (_isKz) return 'Ескертпе';
    if (_isRu) return 'Уведомление';
    return 'Notification';
  }

  String get dateLabel {
    if (_isKz) return 'Күні';
    if (_isRu) return 'Дата';
    return 'Date';
  }

  String get timeLabel {
    if (_isKz) return 'Уақыты';
    if (_isRu) return 'Время';
    return 'Time';
  }

  String get fromLabel {
    if (_isKz) return 'Бастап';
    if (_isRu) return 'От';
    return 'From';
  }

  String get titleLabel {
    if (_isKz) return 'Атауы';
    if (_isRu) return 'Название';
    return 'Title';
  }

  String get descriptionLabel {
    if (_isKz) return 'Сипаттамасы';
    if (_isRu) return 'Описание';
    return 'Description';
  }

  String get typeLabel {
    if (_isKz) return 'Түрі';
    if (_isRu) return 'Тип';
    return 'Type';
  }

  // Company Screen Localization
  String get applyNow {
    if (_isKz) return 'Өтінім беру';
    if (_isRu) return 'Подать заявку';
    return 'Apply Now';
  }

  String get applyForThisVacancy {
    if (_isKz) return 'Бұл бағыттамаға өтінім беру';
    if (_isRu) return 'Подать заявку на эту вакансию';
    return 'Apply for this vacancy';
  }

  String get memo {
    if (_isKz) return 'Есептілік';
    if (_isRu) return 'Памятка';
    return 'Memo';
  }

  String get trainingMaterial {
    if (_isKz) return 'Оқу материалы';
    if (_isRu) return 'Учебный материал';
    return 'Training Material';
  }

  String get openingMessage {
    if (_isKz) return 'Ашусысына өтінім беру';
    if (_isRu) return 'Открытие';
    return 'Opening';
  }

  String get viewMemo {
    if (_isKz) return 'Есептіліктің көрулуі';
    if (_isRu) return 'Просмотреть памятку';
    return 'View Memo';
  }

  String get downloadMaterial {
    if (_isKz) return 'Материалды жүктеп алу';
    if (_isRu) return 'Скачать материал';
    return 'Download Material';
  }

  // Additional Message Localization
  String get registrationSuccessful {
    if (_isKz) return 'Тіркеу сәтті аяқталды!';
    if (_isRu) return 'Регистрация успешна!';
    return 'Registration successful!';
  }

  String get errorSavingToFirebase {
    if (_isKz) return 'Firebase\'ке сохранение қатесі';
    if (_isRu) return 'Ошибка сохранения в Firebase';
    return 'Error saving to Firebase';
  }

  String get failedToSendMessage {
    if (_isKz) return 'Хабарлама жіберу сәтсіз';
    if (_isRu) return 'Не удалось отправить сообщение';
    return 'Failed to send message';
  }

  String get testFirebase {
    if (_isKz) return 'Firebase сынау';
    if (_isRu) return 'Тест Firebase';
    return 'Test Firebase';
  }
}

