import 'package:flutter/material.dart';
import 'package:portal_gun/lib.dart';

class AboutSectionHeaderWidget extends StatelessWidget {
  const AboutSectionHeaderWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: isDark
              ? AppColors.background.withValues(alpha: 0.72)
              : const Color(0xFF627590),
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}
