import 'package:qnote/core/constants/app_colors.dart';
import 'package:qnote/features/memo/data/database.dart';
import 'package:qnote/features/memo/domain/memo_entity.dart';
import 'package:uuid/uuid.dart';

class MemoRepository {
  MemoRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  // Active memos
  Stream<List<Memo>> watchActiveMemos({MemoColor? colorFilter}) =>
      _db.watchActiveMemos(colorFilter: colorFilter);

  Future<List<Memo>> getActiveMemos({
    MemoColor? colorFilter,
    String? searchQuery,
  }) =>
      _db.getActiveMemos(colorFilter: colorFilter, searchQuery: searchQuery);

  Future<Memo?> getMemoById(String id) => _db.getMemoById(id);

  // Create
  Future<Memo> createMemo({MemoColor color = MemoColor.white}) {
    final now = DateTime.now();
    final memo = Memo(
      id: _uuid.v4(),
      title: '',
      body: '',
      color: color,
      isPinned: false,
      isDeleted: false,
      createdAt: now,
      updatedAt: now,
    );
    return _db.insertMemo(memo).then((_) => memo);
  }

  // Update
  Future<void> updateMemo(Memo memo) =>
      _db.updateMemo(memo.copyWith(updatedAt: DateTime.now()));

  // Soft delete -> trash
  Future<void> moveToTrash(String id) => _db.softDeleteMemo(id);

  // Pin toggle
  Future<void> togglePin(String id) => _db.togglePin(id);

  // Trash
  Stream<List<Memo>> watchDeletedMemos() => _db.watchDeletedMemos();

  Future<void> restoreMemo(String id) => _db.restoreMemo(id);

  Future<void> permanentlyDelete(String id) => _db.deleteMemoById(id);

  Future<void> emptyTrash() => _db.emptyTrash();

  Future<void> purgeExpiredMemos(int retentionDays) =>
      _db.purgeExpiredMemos(retentionDays);

  // Search
  Future<List<Memo>> search(String query) =>
      _db.getActiveMemos(searchQuery: query);
}
