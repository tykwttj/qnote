import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnote/core/constants/app_colors.dart';
import 'package:qnote/features/settings/settings_model.dart';
import 'package:qnote/features/settings/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier(ref.watch(settingsRepositoryProvider));
});

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(this._repo) : super(const Settings()) {
    _load();
  }

  final SettingsRepository _repo;

  Future<void> _load() async {
    await _repo.load();
    state = _repo.current;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _repo.save(state);
  }

  Future<void> setDefaultColor(MemoColor color) async {
    state = state.copyWith(defaultColor: color);
    await _repo.save(state);
  }

  Future<void> setFontSize(FontSize size) async {
    state = state.copyWith(fontSize: size);
    await _repo.save(state);
  }

  Future<void> setViewMode(ViewMode mode) async {
    state = state.copyWith(viewMode: mode);
    await _repo.save(state);
  }

  Future<void> setLocale(String locale) async {
    state = state.copyWith(locale: locale);
    await _repo.save(state);
  }

  Future<void> setPro(bool isPro) async {
    state = state.copyWith(isPro: isPro);
    await _repo.save(state);
  }
}
