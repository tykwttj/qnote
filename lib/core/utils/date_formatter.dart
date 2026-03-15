import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String format(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24 && now.day == date.day) {
      return DateFormat.Hm().format(date);
    }
    if (diff.inDays < 7) return DateFormat.E().add_Hm().format(date);
    if (now.year == date.year) return DateFormat.MMMd().add_Hm().format(date);
    return DateFormat.yMMMd().format(date);
  }

  static String trashRemainingDays(DateTime deletedAt, int retentionDays) {
    final expiry = deletedAt.add(Duration(days: retentionDays));
    final remaining = expiry.difference(DateTime.now()).inDays;
    if (remaining <= 0) return 'Expiring soon';
    return '$remaining days left';
  }
}
