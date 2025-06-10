// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Pixabay Flip';

  @override
  String get enterTheme => 'ゲームのテーマを入力してください';

  @override
  String get startGame => 'ゲームを開始';

  @override
  String get playOffline => 'オフラインでプレイ';

  @override
  String get playLast => '最後にプレイしたゲーム:';

  @override
  String get or => 'または';

  @override
  String get searchingImages => '画像を検索中...';

  @override
  String get noInternet => 'インターネット接続がありません';

  @override
  String get notEnoughImages => '十分な画像が見つかりませんでした。別の検索ワードをお試しください。';

  @override
  String moves(Object moves) {
    return '移動回数: $moves回';
  }

  @override
  String get gameOver => 'ゲームオーバー！';

  @override
  String youWon(Object moves) {
    return '$moves回でクリアしました！';
  }

  @override
  String get playAgain => 'もう一度遊ぶ';

  @override
  String get backToHome => 'ホームに戻る';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String get networkError => 'ネットワークエラー。接続を確認してください。';

  @override
  String get serverError => 'サーバーエラー。後でもう一度お試しください。';

  @override
  String get rateLimitExceeded => 'アクセス制限を超えました。しばらくしてからもう一度お試しください。';

  @override
  String get unauthorized => '認証に失敗しました。APIキーを確認してください。';

  @override
  String get settings => '設定';

  @override
  String get theme => 'テーマ';

  @override
  String get systemTheme => 'システム設定に従う';

  @override
  String get systemThemeDescription => 'デバイスのテーマに合わせる';

  @override
  String get lightTheme => 'ライト';

  @override
  String get lightThemeDescription => 'ライトモード';

  @override
  String get darkTheme => 'ダーク';

  @override
  String get darkThemeDescription => 'ダークモード';

  @override
  String get language => '言語';

  @override
  String get about => 'アプリについて';

  @override
  String get version => 'バージョン';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';
}
