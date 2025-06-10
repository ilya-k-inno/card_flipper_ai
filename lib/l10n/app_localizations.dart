import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ru')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Pixel Flip'**
  String get appTitle;

  /// Hint text for theme input field
  ///
  /// In en, this message translates to:
  /// **'Enter a theme for your game'**
  String get enterTheme;

  /// Button to start the game with online images
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// Button to start the game in offline mode
  ///
  /// In en, this message translates to:
  /// **'Play Offline'**
  String get playOffline;

  /// Text shown between buttons
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Loading message when searching for images
  ///
  /// In en, this message translates to:
  /// **'Searching for images...'**
  String get searchingImages;

  /// Message shown when there's no internet connection
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// Error message when not enough images are found for the search term
  ///
  /// In en, this message translates to:
  /// **'Not enough images found. Please try a different search term.'**
  String get notEnoughImages;

  /// Label showing number of moves made
  ///
  /// In en, this message translates to:
  /// **'Moves: {moves}'**
  String moves(Object moves);

  /// Title for the game over dialog
  ///
  /// In en, this message translates to:
  /// **'Game Over!'**
  String get gameOver;

  /// Message shown when player wins the game
  ///
  /// In en, this message translates to:
  /// **'You won in {moves} moves!'**
  String youWon(Object moves);

  /// Button to play the game again
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// Button to go back to home screen
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// Message shown when a network error occurs
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// Message shown when a server error occurs
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// Message shown when API rate limit is exceeded
  ///
  /// In en, this message translates to:
  /// **'Rate limit exceeded. Please try again later.'**
  String get rateLimitExceeded;

  /// Message shown when API authentication fails
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please check your API key.'**
  String get unauthorized;

  /// Title for settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for theme settings
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Option for system default theme
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemTheme;

  /// Description for system theme option
  ///
  /// In en, this message translates to:
  /// **'Match your device\'s theme'**
  String get systemThemeDescription;

  /// Option for light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Description for light theme option
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightThemeDescription;

  /// Option for dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// Description for dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkThemeDescription;

  /// Label for language settings
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label for about section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Label for app version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Label for privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Label for terms of service
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
