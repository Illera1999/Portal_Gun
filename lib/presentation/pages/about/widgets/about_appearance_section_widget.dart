import 'package:flutter/material.dart';
import 'package:portal_gun/lib.dart';

class AboutAppearanceSectionWidget extends StatelessWidget {
  const AboutAppearanceSectionWidget({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF161F31) : Colors.white;
    final iconBg = const Color(0xFF5A63E8);
    final tileBorder = isDark
        ? const Color(0xFF2A3853)
        : const Color(0xFFE7EBF3);
    final textColor = isDark ? Colors.white : AppColors.secondary;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tileBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.nightlight_round,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Dark Mode',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Switch(
              value: isDarkMode,
              onChanged: onDarkModeChanged,
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }
}
