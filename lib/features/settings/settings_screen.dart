import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnote/core/constants/app_colors.dart';
import 'package:qnote/core/constants/app_constants.dart';
import 'package:qnote/features/settings/settings_model.dart';
import 'package:qnote/features/settings/settings_provider.dart';
import 'package:qnote/features/trash/trash_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return SafeArea(
      top: false,
      child: Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Theme'),
            subtitle: Text(_themeName(settings.themeMode)),
            onTap: () => _showThemePicker(context, settings, notifier),
          ),
          ListTile(
            leading: const Icon(Icons.format_size),
            title: const Text('Font size'),
            subtitle: Text(settings.fontSize.label),
            onTap: () => _showFontSizePicker(context, settings, notifier),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text('Default color'),
            subtitle: Text(settings.defaultColor.label),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: settings.defaultColor.color,
                shape: BoxShape.circle,
                border: settings.defaultColor == MemoColor.white
                    ? Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.3))
                    : null,
              ),
            ),
            onTap: () =>
                _showDefaultColorPicker(context, settings, notifier),
          ),
          const Divider(),
          const _SectionHeader('Language'),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(_localeName(settings.locale)),
            onTap: () => _showLanguagePicker(context, settings, notifier),
          ),
          const Divider(),
          const _SectionHeader('Data'),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Trash'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TrashScreen()),
            ),
          ),
          const Divider(),
          const _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text(AppConstants.appVersion),
          ),
        ],
      ),
    ),
    );
  }

  String _themeName(ThemeMode mode) => switch (mode) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };

  String _localeName(String locale) => switch (locale) {
        'ja' => '日本語',
        _ => 'English',
      };

  void _showThemePicker(
      BuildContext context, Settings settings, SettingsNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Theme'),
        children: ThemeMode.values.map((mode) {
          return RadioListTile<ThemeMode>(
            title: Text(_themeName(mode)),
            value: mode,
            groupValue: settings.themeMode,
            onChanged: (v) {
              if (v != null) notifier.setThemeMode(v);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showFontSizePicker(
      BuildContext context, Settings settings, SettingsNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Font size'),
        children: FontSize.values.map((size) {
          return RadioListTile<FontSize>(
            title: Text(size.label),
            subtitle: Text('${size.value.toInt()}pt'),
            value: size,
            groupValue: settings.fontSize,
            onChanged: (v) {
              if (v != null) notifier.setFontSize(v);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showDefaultColorPicker(
      BuildContext context, Settings settings, SettingsNotifier notifier) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _DefaultColorSheet(
        selected: settings.defaultColor,
        onSelected: (color) {
          notifier.setDefaultColor(color);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, Settings settings, SettingsNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Language'),
        children: [
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: settings.locale,
            onChanged: (v) {
              if (v != null) notifier.setLocale(v);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('日本語'),
            value: 'ja',
            groupValue: settings.locale,
            onChanged: (v) {
              if (v != null) notifier.setLocale(v);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _DefaultColorSheet extends StatelessWidget {
  const _DefaultColorSheet({
    required this.selected,
    required this.onSelected,
  });

  final MemoColor selected;
  final ValueChanged<MemoColor> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Default color',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: MemoColor.values.map((color) {
                final isSelected = color == selected;
                return GestureDetector(
                  onTap: () => onSelected(color),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : color == MemoColor.white
                                ? theme.colorScheme.outline
                                    .withValues(alpha: 0.3)
                                : Colors.transparent,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
