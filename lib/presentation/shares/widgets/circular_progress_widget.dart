import 'package:flutter/material.dart';
import 'package:portal_gun/lib.dart';

class CircularProgressWidget extends StatelessWidget {
  const CircularProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: CircularProgressIndicator(
        strokeWidth: 5,
        color: AppColors.primary,
        backgroundColor: AppColors.primaryLight,
      ),
    );
  }
}
