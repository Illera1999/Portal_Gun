import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ErrorRetryCallback = Future<void> Function(WidgetRef ref);

final _providerGenericErrorRetrying = NotifierProvider.autoDispose
    .family<_GenericErrorRetryingNotifier, bool, Object>(
      _GenericErrorRetryingNotifier.new,
    );

class _GenericErrorRetryingNotifier extends Notifier<bool> {
  _GenericErrorRetryingNotifier(Object _);

  @override
  bool build() {
    return false;
  }

  void startRetry() {
    state = true;
  }

  void finishRetry() {
    state = false;
  }
}

class GenericErrorWidget extends ConsumerWidget {
  const GenericErrorWidget({
    super.key,
    required this.onRetry,
    this.title = 'Algo salió mal',
    this.message =
        'Se ha producido un error inesperado. Inténtalo de nuevo en unos segundos.',
    this.buttonLabel = 'Reintentar',
  });

  final ErrorRetryCallback onRetry;
  final String title;
  final String message;
  final String buttonLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retryStateKey = this;
    final isRetrying = ref.watch(_providerGenericErrorRetrying(retryStateKey));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? colorScheme.surface : Colors.white;
    final shadowColor = Colors.black.withValues(alpha: isDark ? 0.20 : 0.08);
    final iconBg = colorScheme.primaryContainer;
    final iconColor = colorScheme.onPrimaryContainer;
    final titleColor = colorScheme.onSurface;
    final messageColor = colorScheme.onSurfaceVariant;
    final buttonBg = colorScheme.primary;
    final buttonFg = colorScheme.onPrimary;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: iconColor,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.35,
                      color: messageColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isRetrying
                          ? null
                          : () async {
                              final retryingNotifier = ref.read(
                                _providerGenericErrorRetrying(
                                  retryStateKey,
                                ).notifier,
                              );

                              retryingNotifier.startRetry();

                              try {
                                await onRetry(ref);

                                // Small delay so the user perceives the retry action before rebuilds.
                                await Future<void>.delayed(
                                  const Duration(milliseconds: 350),
                                );
                              } finally {
                                if (!context.mounted) return;
                                ref
                                    .read(
                                      _providerGenericErrorRetrying(
                                        retryStateKey,
                                      ).notifier,
                                    )
                                    .finishRetry();
                              }
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: buttonBg,
                        foregroundColor: buttonFg,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: isRetrying
                            ? SizedBox(
                                key: const ValueKey('retry-loading'),
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: buttonFg,
                                ),
                              )
                            : const Icon(
                                Icons.refresh_rounded,
                                key: ValueKey('retry-icon'),
                              ),
                      ),
                      label: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Text(
                          isRetrying ? 'Reintentando...' : buttonLabel,
                          key: ValueKey(
                            isRetrying ? 'retry-label-loading' : 'retry-label',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GenericErrorPage extends StatelessWidget {
  const GenericErrorPage({
    super.key,
    required this.onRetry,
    this.title = 'Algo salió mal',
    this.message =
        'Se ha producido un error inesperado. Inténtalo de nuevo en unos segundos.',
    this.buttonLabel = 'Reintentar',
    this.appBarTitle,
    this.showAppBar = true,
    this.backgroundColor = Colors.white,
  });

  final ErrorRetryCallback onRetry;
  final String title;
  final String message;
  final String buttonLabel;
  final String? appBarTitle;
  final bool showAppBar;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: showAppBar
          ? AppBar(
              backgroundColor: backgroundColor,
              elevation: 0,
              title: Text(appBarTitle ?? 'Error'),
            )
          : null,
      body: GenericErrorWidget(
        onRetry: onRetry,
        title: title,
        message: message,
        buttonLabel: buttonLabel,
      ),
    );
  }
}
