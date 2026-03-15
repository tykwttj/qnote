import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qnote/core/constants/app_constants.dart';
import 'package:qnote/core/services/ad_provider.dart';
import 'package:qnote/core/services/widget_service.dart';
import 'package:qnote/core/theme/page_transitions.dart';
import 'package:qnote/core/widgets/ad_banner_widget.dart';
import 'package:qnote/core/widgets/animated_memo_list.dart';
import 'package:qnote/core/widgets/color_filter_bar.dart';
import 'package:qnote/core/widgets/memo_card.dart';
import 'package:qnote/features/memo/domain/memo_entity.dart';
import 'package:qnote/features/memo/presentation/memo_editor_screen.dart';
import 'package:qnote/features/memo/presentation/providers/memo_providers.dart';
import 'package:qnote/features/search/search_screen.dart';
import 'package:qnote/features/settings/settings_model.dart' as s;
import 'package:qnote/features/settings/settings_provider.dart';
import 'package:qnote/features/settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  BannerAd? _bannerAd;
  bool _adsLoaded = false;

  void _tryLoadAds(int memoCount) {
    if (_adsLoaded) return;
    _adsLoaded = true;
    final adService = ref.read(adServiceProvider);
    adService.updateState(memoCount: memoCount, isPro: false);
    adService.loadHomeBanner(onLoaded: () {
      if (mounted) setState(() => _bannerAd = adService.homeBannerAd);
    });
    adService.preloadInterstitial();
  }

  @override
  Widget build(BuildContext context) {
    final memosAsync = ref.watch(memosProvider);
    final settings = ref.watch(settingsProvider);
    final sortMode = ref.watch(sortModeProvider);
    final isGrid = settings.viewMode == s.ViewMode.grid;

    return SafeArea(
      top: false,
      child: Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'view':
                  ref.read(settingsProvider.notifier).setViewMode(
                        isGrid ? s.ViewMode.list : s.ViewMode.grid,
                      );
                case 'sort_updated':
                  ref.read(sortModeProvider.notifier).state =
                      SortMode.updatedDesc;
                case 'sort_created':
                  ref.read(sortModeProvider.notifier).state =
                      SortMode.createdDesc;
                case 'sort_title':
                  ref.read(sortModeProvider.notifier).state = SortMode.titleAsc;
                case 'settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(isGrid ? Icons.view_list : Icons.grid_view, size: 20),
                    const SizedBox(width: 12),
                    Text(isGrid ? 'List view' : 'Grid view'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              CheckedPopupMenuItem(
                value: 'sort_updated',
                checked: sortMode == SortMode.updatedDesc,
                child: const Text('Sort by updated'),
              ),
              CheckedPopupMenuItem(
                value: 'sort_created',
                checked: sortMode == SortMode.createdDesc,
                child: const Text('Sort by created'),
              ),
              CheckedPopupMenuItem(
                value: 'sort_title',
                checked: sortMode == SortMode.titleAsc,
                child: const Text('Sort by title'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const ColorFilterBar(),
          Expanded(
            child: memosAsync.when(
              data: (memos) {
                // Sync home widget whenever memo list changes
                WidgetService.updateWidget(memos);
                _tryLoadAds(memos.length);
                return memos.isEmpty
                    ? const _EmptyState()
                    : isGrid
                        ? _MemoGridView(memos: memos)
                        : _MemoListView(memos: memos);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          AdBannerWidget(bannerAd: _bannerAd),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createMemo(context, ref),
        child: const Icon(Icons.add),
      ),
    ),
    );
  }

  Future<void> _createMemo(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(memoRepositoryProvider);
    final defaultColor = ref.read(settingsProvider).defaultColor;
    final memo = await repo.createMemo(color: defaultColor);
    if (context.mounted) {
      final result = await Navigator.push<bool>(
        context,
        SlideUpRoute<bool>(page: MemoEditorScreen(memoId: memo.id)),
      );
      if (result == true) {
        ref.read(adServiceProvider).onReturnToHome();
      }
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 64,
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No memos yet.\nTap + to create one.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _MemoListView extends ConsumerWidget {
  const _MemoListView({required this.memos});
  final List<Memo> memos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 80),
      itemCount: memos.length,
      itemBuilder: (context, index) => AnimatedListItem(
        index: index,
        child: _SlidableMemoCard(memo: memos[index]),
      ),
    );
  }
}

class _MemoGridView extends ConsumerWidget {
  const _MemoGridView({required this.memos});
  final List<Memo> memos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: memos.length,
      itemBuilder: (context, index) {
        final memo = memos[index];
        return MemoGridCard(
          memo: memo,
          onTap: () async {
            final result = await Navigator.push<bool>(
              context,
              SlideUpRoute<bool>(page: MemoEditorScreen(memoId: memo.id)),
            );
            if (result == true) {
              ref.read(adServiceProvider).onReturnToHome();
            }
          },
        );
      },
    );
  }
}

class _SlidableMemoCard extends ConsumerWidget {
  const _SlidableMemoCard({required this.memo});
  final Memo memo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Slidable(
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) =>
                ref.read(memoRepositoryProvider).togglePin(memo.id),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: memo.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
            label: memo.isPinned ? 'Unpin' : 'Pin',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) =>
                ref.read(memoRepositoryProvider).moveToTrash(memo.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: MemoCard(
        memo: memo,
        onTap: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => MemoEditorScreen(memoId: memo.id),
            ),
          );
          if (result == true) {
            ref.read(adServiceProvider).onReturnToHome();
          }
        },
      ),
    );
  }
}
