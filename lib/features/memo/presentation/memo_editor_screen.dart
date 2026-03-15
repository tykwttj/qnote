import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qnote/core/constants/app_colors.dart';
import 'package:qnote/core/constants/app_constants.dart';
import 'package:qnote/core/services/ad_provider.dart';
import 'package:qnote/core/services/share_service.dart';
import 'package:qnote/core/utils/date_formatter.dart';
import 'package:qnote/core/utils/debouncer.dart';
import 'package:qnote/core/widgets/ad_banner_widget.dart';
import 'package:qnote/core/widgets/color_picker_sheet.dart';
import 'package:qnote/features/memo/data/memo_repository.dart';
import 'package:qnote/features/memo/domain/memo_entity.dart';
import 'package:qnote/features/memo/presentation/providers/memo_providers.dart';
import 'package:qnote/features/settings/settings_provider.dart';

class MemoEditorScreen extends ConsumerStatefulWidget {
  const MemoEditorScreen({super.key, required this.memoId});
  final String memoId;

  @override
  ConsumerState<MemoEditorScreen> createState() => _MemoEditorScreenState();
}

class _MemoEditorScreenState extends ConsumerState<MemoEditorScreen>
    with WidgetsBindingObserver {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _debouncer = Debouncer(duration: AppConstants.autoSaveDuration);
  Memo? _memo;
  bool _loaded = false;
  bool _keyboardVisible = false;
  BannerAd? _bannerAd;
  late final MemoRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = ref.read(memoRepositoryProvider);
    WidgetsBinding.instance.addObserver(this);
    _loadMemo();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    final adService = ref.read(adServiceProvider);
    adService.loadEditorBanner(onLoaded: () {
      if (mounted) setState(() => _bannerAd = adService.editorBannerAd);
    });
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding
        .instance.platformDispatcher.views.first.viewInsets.bottom;
    final visible = bottomInset > 0;
    if (visible != _keyboardVisible) {
      setState(() => _keyboardVisible = visible);
    }
  }

  Future<void> _loadMemo() async {
    final repo = _repo;
    final memo = await repo.getMemoById(widget.memoId);
    if (memo != null && mounted) {
      setState(() {
        _memo = memo;
        _titleController.text = memo.title;
        _bodyController.text = memo.body;
        _loaded = true;
      });
    }
  }

  void _onChanged() {
    if (_memo == null) return;
    setState(() {}); // update char count
    _debouncer.call(_save);
  }

  Future<void> _save() async {
    if (_memo == null) return;
    final updated = _memo!.copyWith(
      title: _titleController.text,
      body: _bodyController.text,
    );
    _memo = updated;
    await _repo.updateMemo(updated);
  }

  Future<void> _togglePin() async {
    if (_memo == null) return;
    await _repo.togglePin(_memo!.id);
    final updated =
        await _repo.getMemoById(_memo!.id);
    if (updated != null && mounted) {
      setState(() => _memo = updated);
    }
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => ColorPickerSheet(
        selectedColor: _memo?.color ?? MemoColor.white,
        onColorSelected: (color) async {
          Navigator.pop(context);
          if (_memo == null) return;
          final updated = _memo!.copyWith(color: color);
          setState(() => _memo = updated);
          await _repo.updateMemo(updated);
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debouncer.dispose();
    if (_memo != null) {
      final updated = _memo!.copyWith(
        title: _titleController.text,
        body: _bodyController.text,
      );
      _repo.updateMemo(updated);
    }
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = _memo != null
        ? (isDark ? _memo!.color.darkBackground : _memo!.color.lightBackground)
        : null;
    final charCount =
        _bodyController.text.length + _titleController.text.length;
    final fontSize = ref.watch(settingsProvider).fontSize.value;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.pop(context, true);
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _memo?.isPinned == true
                    ? Icons.push_pin
                    : Icons.push_pin_outlined,
              ),
              onPressed: _togglePin,
            ),
            IconButton(
              icon: const Icon(Icons.palette_outlined),
              onPressed: _showColorPicker,
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'share':
                    if (_memo != null) await ShareService.shareMemo(_memo!);
                  case 'copy':
                    if (_memo != null) {
                      await ShareService.copyToClipboard(_memo!);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    }
                  case 'delete':
                    if (_memo != null) {
                      await ref
                          .read(memoRepositoryProvider)
                          .moveToTrash(_memo!.id);
                      if (context.mounted) Navigator.pop(context, true);
                    }
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share_outlined, size: 20),
                      SizedBox(width: 12),
                      Text('Share'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'copy',
                  child: Row(
                    children: [
                      Icon(Icons.copy_outlined, size: 20),
                      SizedBox(width: 12),
                      Text('Copy to clipboard'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      onChanged: (_) => _onChanged(),
                      maxLength: AppConstants.titleMaxLength,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                        filled: false,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        '${DateFormatter.format(_memo!.updatedAt)}  |  $charCount characters',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _bodyController,
                        onChanged: (_) => _onChanged(),
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontSize: fontSize),
                        decoration: const InputDecoration(
                          hintText: 'Start writing...',
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!_keyboardVisible) AdBannerWidget(bannerAd: _bannerAd),
          ],
        ),
      ),
      ),
    );
  }
}
