// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Qnote';

  @override
  String get noMemos => 'メモがありません。\n＋をタップして作成しましょう。';

  @override
  String get search => '検索';

  @override
  String get settings => '設定';

  @override
  String get trash => 'ゴミ箱';

  @override
  String get newMemo => '新規メモ';

  @override
  String get edit => '編集';

  @override
  String get delete => '削除';

  @override
  String get restore => '復元';

  @override
  String get permanentlyDelete => '完全に削除';

  @override
  String get emptyTrash => 'ゴミ箱を空にする';

  @override
  String get emptyTrashConfirm => 'ゴミ箱のアイテムをすべて削除しますか？この操作は取り消せません。';

  @override
  String get pin => 'ピン留め';

  @override
  String get unpin => 'ピン留め解除';

  @override
  String get colorPicker => '色を選択';

  @override
  String get share => '共有';

  @override
  String get cancel => 'キャンセル';

  @override
  String get ok => 'OK';

  @override
  String daysLeft(int count) {
    return '残り$count日';
  }

  @override
  String get expiringSoon => 'まもなく期限切れ';

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(int count) {
    return '$count分前';
  }

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeSystem => 'システム';

  @override
  String get settingsDefaultColor => 'デフォルトカラー';

  @override
  String get settingsFontSize => 'フォントサイズ';

  @override
  String get settingsViewMode => '表示モード';

  @override
  String get viewModeList => 'リスト';

  @override
  String get viewModeGrid => 'グリッド';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsRemoveAds => '広告を非表示にする';

  @override
  String get settingsRateApp => 'アプリを評価する';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String characters(int count) {
    return '$count文字';
  }
}
