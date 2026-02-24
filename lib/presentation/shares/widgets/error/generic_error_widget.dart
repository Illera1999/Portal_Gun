import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_gun/lib.dart';

typedef ErrorRetryInvalidator = void Function(WidgetRef ref);

class GenericErrorWidget extends ConsumerWidget {
  const GenericErrorWidget({
    super.key,
    required this.retryInvalidators,
    this.title = 'Algo salió mal',
    this.message =
        'Se ha producido un error inesperado. Inténtalo de nuevo en unos segundos.',
    this.buttonLabel = 'Reintentar',
    this.onRetry,
  });

  final List<ErrorRetryInvalidator> retryInvalidators;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x140F172A),
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
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.secondary,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.35,
                      color: AppColors.secondary.withValues(alpha: 0.70),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        for (final invalidate in retryInvalidators) {
                          invalidate(ref);
                        }
                        onRetry?.call();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(buttonLabel),
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
    required this.retryInvalidators,
    this.title = 'Algo salió mal',
    this.message =
        'Se ha producido un error inesperado. Inténtalo de nuevo en unos segundos.',
    this.buttonLabel = 'Reintentar',
    this.appBarTitle,
    this.showAppBar = true,
    this.onRetry,
    this.backgroundColor = Colors.white,
  });

  final List<ErrorRetryInvalidator> retryInvalidators;
  final String title;
  final String message;
  final String buttonLabel;
  final String? appBarTitle;
  final bool showAppBar;
  final VoidCallback? onRetry;
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
        retryInvalidators: retryInvalidators,
        title: title,
        message: message,
        buttonLabel: buttonLabel,
        onRetry: onRetry,
      ),
    );
  }
}
