// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Пиксельный Флип';

  @override
  String get enterTheme => 'Введите тему для вашей игры';

  @override
  String get startGame => 'Начать игру';

  @override
  String get playOffline => 'Играть офлайн';

  @override
  String get or => 'ИЛИ';

  @override
  String get searchingImages => 'Поиск изображений...';

  @override
  String get noInternet => 'Нет подключения к интернету';

  @override
  String get notEnoughImages => 'Недостаточно изображений. Пожалуйста, попробуйте другой поисковый запрос.';

  @override
  String moves(Object moves) {
    return 'Ходы: $moves';
  }

  @override
  String get gameOver => 'Игра окончена!';

  @override
  String youWon(Object moves) {
    return 'Вы выиграли за $moves ходов!';
  }

  @override
  String get playAgain => 'Играть снова';

  @override
  String get backToHome => 'На главную';

  @override
  String get errorOccurred => 'Произошла ошибка';

  @override
  String get networkError => 'Ошибка сети. Пожалуйста, проверьте подключение.';

  @override
  String get serverError => 'Ошибка сервера. Пожалуйста, попробуйте позже.';

  @override
  String get rateLimitExceeded => 'Превышен лимит запросов. Пожалуйста, повторите позже.';

  @override
  String get unauthorized => 'Ошибка аутентификации. Пожалуйста, проверьте API-ключ.';

  @override
  String get settings => 'Настройки';

  @override
  String get theme => 'Тема';

  @override
  String get systemTheme => 'Как в системе';

  @override
  String get systemThemeDescription => 'Следовать настройкам устройства';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get lightThemeDescription => 'Светлый режим';

  @override
  String get darkTheme => 'Темная';

  @override
  String get darkThemeDescription => 'Темный режим';

  @override
  String get language => 'Язык';

  @override
  String get about => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfService => 'Условия использования';
}
