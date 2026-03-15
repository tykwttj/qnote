// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Qnote';

  @override
  String get noMemos => 'No memos yet.\nTap + to create one.';

  @override
  String get search => 'Search';

  @override
  String get settings => 'Settings';

  @override
  String get trash => 'Trash';

  @override
  String get newMemo => 'New memo';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get restore => 'Restore';

  @override
  String get permanentlyDelete => 'Permanently delete';

  @override
  String get emptyTrash => 'Empty trash';

  @override
  String get emptyTrashConfirm =>
      'Delete all items in trash? This cannot be undone.';

  @override
  String get pin => 'Pin';

  @override
  String get unpin => 'Unpin';

  @override
  String get colorPicker => 'Choose color';

  @override
  String get share => 'Share';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String daysLeft(int count) {
    return '$count days left';
  }

  @override
  String get expiringSoon => 'Expiring soon';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get settingsDefaultColor => 'Default color';

  @override
  String get settingsFontSize => 'Font size';

  @override
  String get settingsViewMode => 'View mode';

  @override
  String get viewModeList => 'List';

  @override
  String get viewModeGrid => 'Grid';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsRemoveAds => 'Remove ads';

  @override
  String get settingsRateApp => 'Rate app';

  @override
  String get settingsVersion => 'Version';

  @override
  String characters(int count) {
    return '$count characters';
  }
}
