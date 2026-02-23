import 'package:flutter/material.dart';
import 'package:portal_gun/lib.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onIndexSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onIndexSelected;

  @override
  Widget build(BuildContext context) {
    final navBg = AppColors.secondary;
    final navBorder = AppColors.primary;
    final navGlow = AppColors.primary;

    final activeColor = AppColors.primary;
    final inactiveColor = AppColors.background;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: navBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: navBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: navGlow,
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  selected: currentIndex == 0,
                  icon: Icons.grid_view_rounded,
                  label: 'INICIO',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  onTap: () => onIndexSelected(0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  selected: currentIndex == 1,
                  icon: Icons.settings,
                  label: 'AJUSTES',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  onTap: () => onIndexSelected(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
