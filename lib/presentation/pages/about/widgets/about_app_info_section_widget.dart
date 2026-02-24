import 'package:flutter/material.dart';
import 'package:portal_gun/lib.dart';

class AboutAppInfoSectionWidget extends StatelessWidget {
  const AboutAppInfoSectionWidget({
    super.key,
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    required this.environmentLabel,
    required this.baseUrl,
  });

  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
  final String environmentLabel;
  final String baseUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF161F31) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2A3853)
        : const Color(0xFFE7EBF3);
    final dividerColor = isDark
        ? const Color(0xFF24324B)
        : const Color(0xFFEEF2F7);
    final valueColor = isDark
        ? AppColors.background.withValues(alpha: 0.82)
        : const Color(0xFF657792);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          _AboutInfoRowWidget(
            icon: Icons.info_outline_rounded,
            iconBg: const Color(0xFFDDF2CC),
            iconColor: const Color(0xFF7EB34A),
            label: 'Version',
            value: version,
            valueColor: valueColor,
          ),
          Divider(height: 1, color: dividerColor),
          _AboutInfoRowWidget(
            icon: Icons.tag_rounded,
            iconBg: const Color(0xFFFFE5D5),
            iconColor: const Color(0xFFFF6E28),
            label: 'Build',
            value: buildNumber,
            valueColor: valueColor,
          ),
          Divider(height: 1, color: dividerColor),
          _AboutInfoRowWidget(
            icon: Icons.inventory_2_outlined,
            iconBg: const Color(0xFFE6ECF6),
            iconColor: const Color(0xFF60728D),
            label: 'Package',
            value: packageName,
            valueColor: valueColor,
            isMultilineValue: true,
          ),
          Divider(height: 1, color: dividerColor),
          _AboutInfoRowWidget(
            icon: Icons.developer_mode_rounded,
            iconBg: const Color(0xFFE6ECF6),
            iconColor: const Color(0xFF60728D),
            label: 'Environment',
            value: environmentLabel,
            valueColor: valueColor,
          ),
          Divider(height: 1, color: dividerColor),
          _AboutInfoRowWidget(
            icon: Icons.rocket_launch_outlined,
            iconBg: AppColors.primaryLight,
            iconColor: AppColors.primary.withValues(alpha: 0.85),
            label: 'App',
            value: appName,
            valueColor: valueColor,
          ),
          Divider(height: 1, color: dividerColor),
          _AboutInfoRowWidget(
            icon: Icons.link_rounded,
            iconBg: const Color(0xFFE7F0FF),
            iconColor: const Color(0xFF4B79D8),
            label: 'Base URL',
            value: baseUrl,
            valueColor: valueColor,
            isMultilineValue: true,
          ),
        ],
      ),
    );
  }
}

class _AboutInfoRowWidget extends StatelessWidget {
  const _AboutInfoRowWidget({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
    this.isMultilineValue = false,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
  final bool isMultilineValue;

  @override
  Widget build(BuildContext context) {
    final labelColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.secondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: isMultilineValue
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: isMultilineValue ? 3 : 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: valueColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
