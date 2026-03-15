import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qnote/core/constants/app_colors.dart';
import 'package:qnote/features/memo/data/database.dart';
import 'package:qnote/features/memo/data/memo_repository.dart';

void main() {
  late AppDatabase db;
  late MemoRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = MemoRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('MemoRepository', () {
    test('createMemo creates a memo with default values', () async {
      final memo = await repo.createMemo();

      expect(memo.id, isNotEmpty);
      expect(memo.title, isEmpty);
      expect(memo.body, isEmpty);
      expect(memo.color, MemoColor.white);
      expect(memo.isPinned, false);
      expect(memo.isDeleted, false);
    });

    test('createMemo uses specified color', () async {
      final memo = await repo.createMemo(color: MemoColor.blue);
      expect(memo.color, MemoColor.blue);
    });

    test('getActiveMemos returns non-deleted memos', () async {
      await repo.createMemo();
      await repo.createMemo();
      final memos = await repo.getActiveMemos();
      expect(memos.length, 2);
    });

    test('updateMemo persists changes', () async {
      final memo = await repo.createMemo();
      final updated = memo.copyWith(title: 'Test Title', body: 'Test Body');
      await repo.updateMemo(updated);

      final fetched = await repo.getMemoById(memo.id);
      expect(fetched?.title, 'Test Title');
      expect(fetched?.body, 'Test Body');
    });

    test('moveToTrash soft-deletes memo', () async {
      final memo = await repo.createMemo();
      await repo.moveToTrash(memo.id);

      final active = await repo.getActiveMemos();
      expect(active, isEmpty);

      final deleted = await db.getDeletedMemos();
      expect(deleted.length, 1);
      expect(deleted.first.id, memo.id);
    });

    test('restoreMemo undeletes memo', () async {
      final memo = await repo.createMemo();
      await repo.moveToTrash(memo.id);
      await repo.restoreMemo(memo.id);

      final active = await repo.getActiveMemos();
      expect(active.length, 1);
      expect(active.first.isDeleted, false);
    });

    test('permanentlyDelete removes memo', () async {
      final memo = await repo.createMemo();
      await repo.permanentlyDelete(memo.id);

      final fetched = await repo.getMemoById(memo.id);
      expect(fetched, isNull);
    });

    test('togglePin flips pin state', () async {
      final memo = await repo.createMemo();
      expect(memo.isPinned, false);

      await repo.togglePin(memo.id);
      final pinned = await repo.getMemoById(memo.id);
      expect(pinned?.isPinned, true);

      await repo.togglePin(memo.id);
      final unpinned = await repo.getMemoById(memo.id);
      expect(unpinned?.isPinned, false);
    });

    test('search finds memos by title', () async {
      final memo = await repo.createMemo();
      await repo.updateMemo(memo.copyWith(title: 'Shopping List'));
      await repo.createMemo();

      final results = await repo.search('Shopping');
      expect(results.length, 1);
      expect(results.first.title, 'Shopping List');
    });

    test('search finds memos by body', () async {
      final memo = await repo.createMemo();
      await repo.updateMemo(memo.copyWith(body: 'Buy milk and eggs'));

      final results = await repo.search('milk');
      expect(results.length, 1);
    });

    test('emptyTrash removes all deleted memos', () async {
      final m1 = await repo.createMemo();
      final m2 = await repo.createMemo();
      await repo.moveToTrash(m1.id);
      await repo.moveToTrash(m2.id);

      await repo.emptyTrash();
      final deleted = await db.getDeletedMemos();
      expect(deleted, isEmpty);
    });

    test('color filter returns matching memos', () async {
      await repo.createMemo(color: MemoColor.red);
      await repo.createMemo(color: MemoColor.blue);
      await repo.createMemo(color: MemoColor.red);

      final reds = await repo.getActiveMemos(colorFilter: MemoColor.red);
      expect(reds.length, 2);

      final blues = await repo.getActiveMemos(colorFilter: MemoColor.blue);
      expect(blues.length, 1);
    });
  });
}
