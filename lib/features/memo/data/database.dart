import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:qnote/core/constants/app_colors.dart';
import 'package:qnote/features/memo/data/memo_table.dart';
import 'package:qnote/features/memo/domain/memo_entity.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Memos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
    );
  }

  // --- Memo CRUD ---

  Future<List<Memo>> getActiveMemos({
    MemoColor? colorFilter,
    String? searchQuery,
  }) async {
    final query = select(memos)
      ..where((t) => t.isDeleted.equals(false));

    if (colorFilter != null) {
      query.where((t) => t.colorIndex.equals(colorFilter.index));
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final pattern = '%$searchQuery%';
      query.where(
        (t) => t.title.like(pattern) | t.body.like(pattern),
      );
    }

    query.orderBy([
      (t) => OrderingTerm.desc(t.isPinned),
      (t) => OrderingTerm.desc(t.updatedAt),
    ]);

    final rows = await query.get();
    return rows.map(_memoFromRow).toList();
  }

  Stream<List<Memo>> watchActiveMemos({MemoColor? colorFilter}) {
    final query = select(memos)
      ..where((t) => t.isDeleted.equals(false));

    if (colorFilter != null) {
      query.where((t) => t.colorIndex.equals(colorFilter.index));
    }

    query.orderBy([
      (t) => OrderingTerm.desc(t.isPinned),
      (t) => OrderingTerm.desc(t.updatedAt),
    ]);

    return query.watch().map(
          (rows) => rows.map(_memoFromRow).toList(),
        );
  }

  Future<Memo?> getMemoById(String id) async {
    final query = select(memos)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _memoFromRow(row) : null;
  }

  Future<void> insertMemo(Memo memo) async {
    await into(memos).insert(_memoToCompanion(memo));
  }

  Future<void> updateMemo(Memo memo) async {
    await (update(memos)..where((t) => t.id.equals(memo.id)))
        .write(_memoToCompanion(memo));
  }

  Future<void> deleteMemoById(String id) async {
    await (delete(memos)..where((t) => t.id.equals(id))).go();
  }

  // --- Trash ---

  Future<List<Memo>> getDeletedMemos() async {
    final query = select(memos)
      ..where((t) => t.isDeleted.equals(true))
      ..orderBy([(t) => OrderingTerm.desc(t.deletedAt)]);
    final rows = await query.get();
    return rows.map(_memoFromRow).toList();
  }

  Stream<List<Memo>> watchDeletedMemos() {
    final query = select(memos)
      ..where((t) => t.isDeleted.equals(true))
      ..orderBy([(t) => OrderingTerm.desc(t.deletedAt)]);
    return query.watch().map(
          (rows) => rows.map(_memoFromRow).toList(),
        );
  }

  Future<void> softDeleteMemo(String id) async {
    final now = DateTime.now();
    await (update(memos)..where((t) => t.id.equals(id))).write(
      MemosCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> restoreMemo(String id) async {
    await (update(memos)..where((t) => t.id.equals(id))).write(
      MemosCompanion(
        isDeleted: const Value(false),
        deletedAt: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> purgeExpiredMemos(int retentionDays) async {
    final cutoff = DateTime.now().subtract(Duration(days: retentionDays));
    await (delete(memos)
          ..where(
            (t) =>
                t.isDeleted.equals(true) &
                t.deletedAt.isSmallerThanValue(cutoff),
          ))
        .go();
  }

  Future<void> emptyTrash() async {
    await (delete(memos)..where((t) => t.isDeleted.equals(true))).go();
  }

  // --- Pin ---

  Future<void> togglePin(String id) async {
    final memo = await getMemoById(id);
    if (memo == null) return;
    await (update(memos)..where((t) => t.id.equals(id))).write(
      MemosCompanion(
        isPinned: Value(!memo.isPinned),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // --- Helpers ---

  Memo _memoFromRow(MemoEntry row) {
    return Memo(
      id: row.id,
      title: row.title,
      body: row.body,
      color: MemoColor.values[row.colorIndex],
      isPinned: row.isPinned,
      isDeleted: row.isDeleted,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  MemosCompanion _memoToCompanion(Memo memo) {
    return MemosCompanion(
      id: Value(memo.id),
      title: Value(memo.title),
      body: Value(memo.body),
      colorIndex: Value(memo.color.index),
      isPinned: Value(memo.isPinned),
      isDeleted: Value(memo.isDeleted),
      createdAt: Value(memo.createdAt),
      updatedAt: Value(memo.updatedAt),
      deletedAt: Value(memo.deletedAt),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'qnote.db'));
    return NativeDatabase.createInBackground(file);
  });
}
