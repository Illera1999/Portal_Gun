import 'package:flutter/material.dart';
import 'package:portal_gun/lib.dart';

class AboutApiSectionWidget extends StatelessWidget {
  const AboutApiSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF161F31) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2A3853)
        : const Color(0xFFE7EBF3);
    final bodyColor = isDark
        ? AppColors.background.withValues(alpha: 0.88)
        : const Color(0xFF44546C);
    final mutedColor = isDark
        ? AppColors.background.withValues(alpha: 0.62)
        : const Color(0xFF70819A);
    final chipBg = isDark
        ? AppColors.primary.withValues(alpha: 0.14)
        : const Color(0xFFEAF0F7);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0F14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.hub_rounded,
                    color: Color(0xFF64E3D8),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'The Rick and Morty API',
                        style: TextStyle(
                          color: Color(0xFF79C845),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'rickandmortyapi.com',
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'The Rick and Morty API is a RESTful API based on the television '
              'show Rick and Morty. You can get access to characters, images, '
              'locations and episodes.',
              style: TextStyle(
                color: bodyColor,
                fontSize: 14,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ApiTagChip(label: 'RESTFUL', backgroundColor: chipBg),
                _ApiTagChip(label: 'OPEN SOURCE', backgroundColor: chipBg),
                _ApiTagChip(label: 'PUBLIC API', backgroundColor: chipBg),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ApiTagChip extends StatelessWidget {
  const _ApiTagChip({
    required this.label,
    required this.backgroundColor,
  });

  final String label;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark
              ? AppColors.background.withValues(alpha: 0.92)
              : const Color(0xFF5F718A),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
