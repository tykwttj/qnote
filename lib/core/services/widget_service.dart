import 'dart:convert';

import 'package:home_widget/home_widget.dart';
import 'package:qnote/features/memo/domain/memo_entity.dart';

class WidgetService {
  WidgetService._();

  static const _appGroupId = 'group.com.qnote.widget';
  static const _iOSWidgetName = 'QnoteWidget';
  static const _androidWidgetName = 'QnoteWidgetProvider';

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  static Future<void> updateWidget(List<Memo> memos) async {
    final pinnedMemos = memos.where((m) => m.isPinned).take(5).toList();
    final recentMemos = memos.where((m) => !m.isPinned).take(5).toList();
    final displayMemos = [...pinnedMemos, ...recentMemos].take(5).toList();

    // Store memo data for widget
    final memoData = displayMemos
        .map((m) => {
              'id': m.id,
              'title': m.title.isEmpty ? 'Untitled' : m.title,
              'body': m.body,
              'colorIndex': m.color.index,
              'isPinned': m.isPinned,
            })
        .toList();

    await HomeWidget.saveWidgetData('memo_count', displayMemos.length);
    await HomeWidget.saveWidgetData('memos_json', jsonEncode(memoData));

    // Save individual memo fields for simpler widget layouts
    for (var i = 0; i < 5; i++) {
      if (i < displayMemos.length) {
        final m = displayMemos[i];
        await HomeWidget.saveWidgetData(
            'memo_${i}_title', m.title.isEmpty ? 'Untitled' : m.title);
        await HomeWidget.saveWidgetData('memo_${i}_body',
            m.body.length > 80 ? '${m.body.substring(0, 80)}...' : m.body);
        await HomeWidget.saveWidgetData('memo_${i}_color', m.color.index);
        await HomeWidget.saveWidgetData('memo_${i}_pinned', m.isPinned);
      } else {
        await HomeWidget.saveWidgetData('memo_${i}_title', null);
        await HomeWidget.saveWidgetData('memo_${i}_body', null);
        await HomeWidget.saveWidgetData('memo_${i}_color', null);
        await HomeWidget.saveWidgetData('memo_${i}_pinned', null);
      }
    }

    await HomeWidget.updateWidget(
      iOSName: _iOSWidgetName,
      androidName: _androidWidgetName,
    );
  }
}
