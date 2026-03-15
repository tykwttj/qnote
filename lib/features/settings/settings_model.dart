import 'package:flutter/material.dart';
import 'package:qnote/core/constants/app_colors.dart';
import 'package:qnote/core/constants/app_constants.dart';

enum FontSize {
  small(AppConstants.fontSizeSmall, 'Small'),
  medium(AppConstants.fontSizeMedium, 'Medium'),
  large(AppConstants.fontSizeLarge, 'Large');

  const FontSize(this.value, this.label);
  final double value;
  final String label;
}

enum ViewMode {
  list('List'),
  grid('Grid');

  const ViewMode(this.label);
  final String label;
}

class Settings {
  const Settings({
    this.themeMode = ThemeMode.system,
    this.defaultColor = MemoColor.white,
    this.fontSize = FontSize.medium,
    this.viewMode = ViewMode.list,
    this.autoSave = true,
    this.trashRetentionDays = AppConstants.trashRetentionDays,
    this.locale = 'en',
    this.isPro = false,
  });

  final ThemeMode themeMode;
  final MemoColor defaultColor;
  final FontSize fontSize;
  final ViewMode viewMode;
  final bool autoSave;
  final int trashRetentionDays;
  final String locale;
  final bool isPro;

  Settings copyWith({
    ThemeMode? themeMode,
    MemoColor? defaultColor,
    FontSize? fontSize,
    ViewMode? viewMode,
    bool? autoSave,
    int? trashRetentionDays,
    String? locale,
    bool? isPro,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      defaultColor: defaultColor ?? this.defaultColor,
      fontSize: fontSize ?? this.fontSize,
      viewMode: viewMode ?? this.viewMode,
      autoSave: autoSave ?? this.autoSave,
      trashRetentionDays: trashRetentionDays ?? this.trashRetentionDays,
      locale: locale ?? this.locale,
      isPro: isPro ?? this.isPro,
    );
  }

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.index,
        'defaultColor': defaultColor.index,
        'fontSize': fontSize.index,
        'viewMode': viewMode.index,
        'autoSave': autoSave,
        'trashRetentionDays': trashRetentionDays,
        'locale': locale,
        'isPro': isPro,
      };

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 0],
      defaultColor: MemoColor.values[json['defaultColor'] as int? ?? 0],
      fontSize: FontSize.values[json['fontSize'] as int? ?? 1],
      viewMode: ViewMode.values[json['viewMode'] as int? ?? 0],
      autoSave: json['autoSave'] as bool? ?? true,
      trashRetentionDays:
          json['trashRetentionDays'] as int? ?? AppConstants.trashRetentionDays,
      locale: json['locale'] as String? ?? 'en',
      isPro: json['isPro'] as bool? ?? false,
    );
  }
}
