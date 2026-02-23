import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_gun/lib.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  static const pathRoute = '/startup/splash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.read(providerAppConfig);
    ref.listen(providerStartup, (previous, next) {
      next.whenOrNull(
        data: (result) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            context.go(result.destination);
          });
        },
        error: (error, stackTrace) {},
      );
    });
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          config.appName,
                          style: context.bold40.copyWith(
                            fontFamily: 'Lexend',
                            color: AppColors.secondary,
                          ),
                        ),
                        const Gap(1),
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressWidget(),
                    const Gap(48),
                    Text(
                      'Preparando tu experiencia ...',
                      textAlign: TextAlign.center,
                      style: context.font24.copyWith(
                        fontFamily: 'Lexend',
                        color: AppColors.secondary,
                      ),
                    ),
                    const Gap(48),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
