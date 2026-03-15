import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnote/core/constants/app_colors.dart';
import 'package:qnote/features/memo/data/database.dart';
import 'package:qnote/features/memo/data/memo_repository.dart';
import 'package:qnote/features/memo/domain/memo_entity.dart';

// Database provider
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Repository provider
final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  return MemoRepository(ref.watch(databaseProvider));
});

// Color filter state
final colorFilterProvider = StateProvider<MemoColor?>((ref) => null);

// Sort mode
enum SortMode { updatedDesc, createdDesc, titleAsc }

final sortModeProvider = StateProvider<SortMode>((ref) => SortMode.updatedDesc);

// Active memos stream (sorted)
final memosProvider = StreamProvider<List<Memo>>((ref) {
  final repo = ref.watch(memoRepositoryProvider);
  final colorFilter = ref.watch(colorFilterProvider);
  final sortMode = ref.watch(sortModeProvider);

  return repo.watchActiveMemos(colorFilter: colorFilter).map((memos) {
    final pinned = memos.where((m) => m.isPinned).toList();
    final unpinned = memos.where((m) => !m.isPinned).toList();

    int Function(Memo, Memo) comparator;
    switch (sortMode) {
      case SortMode.updatedDesc:
        comparator = (a, b) => b.updatedAt.compareTo(a.updatedAt);
      case SortMode.createdDesc:
        comparator = (a, b) => b.createdAt.compareTo(a.createdAt);
      case SortMode.titleAsc:
        comparator = (a, b) =>
            a.title.toLowerCase().compareTo(b.title.toLowerCase());
    }

    pinned.sort(comparator);
    unpinned.sort(comparator);
    return [...pinned, ...unpinned];
  });
});
