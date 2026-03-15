import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnote/core/constants/app_colors.dart';
import 'package:qnote/features/memo/presentation/providers/memo_providers.dart';

class ColorFilterBar extends ConsumerWidget {
  const ColorFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(colorFilterProvider);
    final theme = Theme.of(context);

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _FilterChip(
            label: 'All',
            color: null,
            isSelected: selected == null,
            onTap: () =>
                ref.read(colorFilterProvider.notifier).state = null,
            theme: theme,
          ),
          ...MemoColor.values.map(
            (color) => _FilterChip(
              label: null,
              color: color,
              isSelected: selected == color,
              onTap: () =>
                  ref.read(colorFilterProvider.notifier).state = color,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  final String? label;
  final MemoColor? color;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: label != null
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
              : const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? (color?.color ?? theme.colorScheme.primary)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (color?.color ?? theme.colorScheme.outline)
                      .withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Center(
            child: label != null
                ? Text(
                    label!,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  )
                : Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color!.color,
                      shape: BoxShape.circle,
                      border: color == MemoColor.white
                          ? Border.all(
                              color: theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            )
                          : null,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
