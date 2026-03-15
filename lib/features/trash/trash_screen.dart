import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnote/core/constants/app_constants.dart';
import 'package:qnote/core/utils/date_formatter.dart';
import 'package:qnote/features/memo/domain/memo_entity.dart';
import 'package:qnote/features/memo/presentation/providers/memo_providers.dart';

final _trashProvider = StreamProvider<List<Memo>>((ref) {
  return ref.watch(memoRepositoryProvider).watchDeletedMemos();
});

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashAsync = ref.watch(_trashProvider);
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
        actions: [
          trashAsync.whenOrNull(
                data: (memos) => memos.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () => _confirmEmptyTrash(context, ref),
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: trashAsync.when(
        data: (memos) => memos.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 64,
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Trash is empty',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: memos.length,
                itemBuilder: (context, index) {
                  final memo = memos[index];
                  final remaining = memo.deletedAt != null
                      ? DateFormatter.trashRemainingDays(
                          memo.deletedAt!,
                          AppConstants.trashRetentionDays,
                        )
                      : '';
                  return ListTile(
                    title: Text(
                      memo.title.isEmpty ? 'Untitled' : memo.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(remaining),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.restore),
                          tooltip: 'Restore',
                          onPressed: () =>
                              ref.read(memoRepositoryProvider).restoreMemo(memo.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever,
                              color: Colors.red),
                          tooltip: 'Delete permanently',
                          onPressed: () => _confirmDelete(context, ref, memo),
                        ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Memo memo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete permanently?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(memoRepositoryProvider).permanentlyDelete(memo.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmEmptyTrash(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Empty trash?'),
        content: const Text(
            'All items in trash will be permanently deleted. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(memoRepositoryProvider).emptyTrash();
              Navigator.pop(context);
            },
            child: const Text('Empty', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
