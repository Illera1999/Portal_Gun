import 'package:flutter/material.dart';
import 'package:portal_gun/lib.dart';

class AboutFooterNoteWidget extends StatelessWidget {
  const AboutFooterNoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.background.withValues(alpha: 0.52)
        : const Color(0xFF96A5BB);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      child: Column(
        children: [
          Text(
            'Created with interdimensional love.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'CHARACTERS AND ART ARE PROPERTY OF ADULT SWIM',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
