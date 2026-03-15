import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qnote/features/memo/domain/memo_entity.dart';

class ShareService {
  ShareService._();

  static String _memoToText(Memo memo) {
    final buf = StringBuffer();
    if (memo.title.isNotEmpty) {
      buf.writeln(memo.title);
      buf.writeln();
    }
    buf.write(memo.body);
    return buf.toString();
  }

  static Future<void> shareMemo(Memo memo) async {
    await Share.share(_memoToText(memo));
  }

  static Future<void> copyToClipboard(Memo memo) async {
    await Clipboard.setData(ClipboardData(text: _memoToText(memo)));
  }
}
