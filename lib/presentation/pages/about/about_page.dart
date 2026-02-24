import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:portal_gun/lib.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  static const pathRoute = '/about';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfig = ref.watch(providerAppConfig);
    final themeMode = ref.watch(providerThemeMode);
    final packageInfoAsync = ref.watch(providerPackageInfo);
    final packageInfo = packageInfoAsync.asData?.value;
    final packageAppName = packageInfo?.appName.trim() ?? '';
    final displayAppName = packageAppName.isEmpty
        ? appConfig.appName
        : packageAppName;
    final isDarkMode = themeMode == ThemeMode.dark;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pageBg = isDark ? const Color(0xFF0B1120) : const Color(0xFFEFF1F6);
    final panelBg = isDark ? const Color(0xFF101827) : const Color(0xFFF2F4F8);
    final panelBorder = isDark
        ? const Color(0xFF22304A)
        : const Color(0xFFE2E7EF);

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                decoration: BoxDecoration(
                  color: panelBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: panelBorder),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AJUSTES',
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.secondary,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Gap(18),
                      const Divider(height: 1),
                      const Gap(18),
                      const AboutSectionHeaderWidget(title: 'Apariencia'),
                      AboutAppearanceSectionWidget(
                        isDarkMode: isDarkMode,
                        onDarkModeChanged: (enabled) {
                          ref
                              .read(providerThemeMode.notifier)
                              .setDarkMode(enabled);
                        },
                      ),
                      const Gap(24),
                      const AboutSectionHeaderWidget(title: 'Sobre la API'),
                      const AboutApiSectionWidget(),
                      const Gap(24),
                      const AboutSectionHeaderWidget(
                        title: 'Información de la App',
                      ),
                      AboutAppInfoSectionWidget(
                        appName: displayAppName,
                        packageName: packageInfo?.packageName ?? 'portal_gun',
                        version: packageInfo?.version ?? '—',
                        buildNumber: packageInfo?.buildNumber ?? '—',
                        environmentLabel: appConfig.environment.name
                            .toUpperCase(),
                        baseUrl: appConfig.baseUrl,
                      ),
                      const Gap(18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
