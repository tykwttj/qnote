import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:qnote/features/settings/settings_model.dart';

class SettingsRepository {
  Settings _settings = const Settings();
  static const _fileName = 'qnote_settings.json';

  Settings get current => _settings;

  Future<void> load() async {
    try {
      final file = await _settingsFile();
      if (await file.exists()) {
        final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        _settings = Settings.fromJson(json);
      }
    } catch (_) {
      _settings = const Settings();
    }
  }

  Future<void> save(Settings settings) async {
    _settings = settings;
    final file = await _settingsFile();
    await file.writeAsString(jsonEncode(settings.toJson()));
  }

  Future<File> _settingsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, _fileName));
  }
}
