import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_gun/lib.dart';

class HeroHeaderWidget extends StatelessWidget {
  const HeroHeaderWidget({
    super.key,
    required this.character,
    this.bottomOverlayColor,
  });

  final CharacterEntity character;
  final Color? bottomOverlayColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final footerOverlayColor = bottomOverlayColor ?? theme.scaffoldBackgroundColor;
    final imageFallbackColor = colorScheme.surfaceContainerHighest;

    return SizedBox(
      height: 420,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            character.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                color: imageFallbackColor,
                alignment: Alignment.center,
                child: CircularProgressIndicator(color: colorScheme.primary),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: imageFallbackColor,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: colorScheme.onSurfaceVariant,
                  size: 42,
                ),
              );
            },
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.35),
                  footerOverlayColor.withValues(alpha: 0.98),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 10,
            left: 16,
            child: Material(
              color: Colors.black.withValues(alpha: 0.30),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 10),
                StatusChipWidget(status: character.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
