// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pixel Flip';

  @override
  String get enterTheme => 'Enter a theme for your game';

  @override
  String get startGame => 'Start Game';

  @override
  String get playOffline => 'Play Offline';

  @override
  String get searchingImages => 'Searching for images...';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get notEnoughImages => 'Not enough images found. Please try a different search term.';

  @override
  String moves(Object moves) {
    return 'Moves: $moves';
  }

  @override
  String get gameOver => 'Game Over!';

  @override
  String youWon(Object moves) {
    return 'You won in $moves moves!';
  }

  @override
  String get playAgain => 'Play Again';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get serverError => 'Server error. Please try again later.';

  @override
  String get rateLimitExceeded => 'Rate limit exceeded. Please try again later.';

  @override
  String get unauthorized => 'Authentication failed. Please check your API key.';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System Default';

  @override
  String get systemThemeDescription => 'Match your device\'s theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get lightThemeDescription => 'Light mode';

  @override
  String get darkTheme => 'Dark';

  @override
  String get darkThemeDescription => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';
}
