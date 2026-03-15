import 'package:flutter/material.dart';

/// 9-color palette for memo categorization.
enum MemoColor {
  white,
  red,
  orange,
  yellow,
  green,
  teal,
  blue,
  purple,
  pink;

  Color get color => switch (this) {
        MemoColor.white => const Color(0xFFFFFFFF),
        MemoColor.red => const Color(0xFFEF5350),
        MemoColor.orange => const Color(0xFFFF9800),
        MemoColor.yellow => const Color(0xFFFFEE58),
        MemoColor.green => const Color(0xFF66BB6A),
        MemoColor.teal => const Color(0xFF26A69A),
        MemoColor.blue => const Color(0xFF42A5F5),
        MemoColor.purple => const Color(0xFFAB47BC),
        MemoColor.pink => const Color(0xFFEC407A),
      };

  Color get lightBackground => switch (this) {
        MemoColor.white => const Color(0xFFFAFAFA),
        MemoColor.red => const Color(0xFFFFEBEE),
        MemoColor.orange => const Color(0xFFFFF3E0),
        MemoColor.yellow => const Color(0xFFFFFDE7),
        MemoColor.green => const Color(0xFFE8F5E9),
        MemoColor.teal => const Color(0xFFE0F2F1),
        MemoColor.blue => const Color(0xFFE3F2FD),
        MemoColor.purple => const Color(0xFFF3E5F5),
        MemoColor.pink => const Color(0xFFFCE4EC),
      };

  Color get darkBackground => switch (this) {
        MemoColor.white => const Color(0xFF2C2C2C),
        MemoColor.red => const Color(0xFF4E2527),
        MemoColor.orange => const Color(0xFF4E3524),
        MemoColor.yellow => const Color(0xFF4E4B24),
        MemoColor.green => const Color(0xFF264E2A),
        MemoColor.teal => const Color(0xFF244E48),
        MemoColor.blue => const Color(0xFF24364E),
        MemoColor.purple => const Color(0xFF3D264E),
        MemoColor.pink => const Color(0xFF4E2435),
      };

  String get label => switch (this) {
        MemoColor.white => 'White',
        MemoColor.red => 'Red',
        MemoColor.orange => 'Orange',
        MemoColor.yellow => 'Yellow',
        MemoColor.green => 'Green',
        MemoColor.teal => 'Teal',
        MemoColor.blue => 'Blue',
        MemoColor.purple => 'Purple',
        MemoColor.pink => 'Pink',
      };
}
