import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_gun/lib.dart';

class CharacterDetailPage extends ConsumerWidget {
  const CharacterDetailPage({super.key, required this.characterId});

  static const pathRoute = 'character/:id';

  final int characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = characterId;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final asyncCharacter = ref.watch(
              providerCharacterDetailController(id),
            );

            return asyncCharacter.when(
              loading: () => const Center(child: CircularProgressWidget()),
              error: (error, stack) => GenericErrorWidget(
                retryInvalidators: [
                  (ref) => ref.invalidate(providerCharacterDetailController(id)),
                ],
                title: 'No se pudo cargar el personaje',
                message:
                    'Ha ocurrido un error al cargar el detalle. Puedes reintentar ahora.',
              ),
              data: (character) =>
                  _CharacterDetailContent(character: character),
            );
          },
        ),
      ),
    );
  }
}

class _CharacterDetailContent extends StatelessWidget {
  const _CharacterDetailContent({required this.character});

  final CharacterEntity character;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final accentColor = colorScheme.primary;
    final accentMuted = accentColor.withValues(alpha: isDark ? 0.22 : 0.14);
    final cardBg = isDark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surface;
    final cardBorder = colorScheme.outlineVariant.withValues(
      alpha: isDark ? 0.60 : 0.35,
    );
    final mutedText = colorScheme.onSurfaceVariant;
    final valueText = colorScheme.onSurface;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeroHeaderWidget(
                character: character,
                bottomOverlayColor: theme.scaffoldBackgroundColor,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InfoCardWidget(
                            title: 'ESPECIE',
                            value: character.species,
                            backgroundColor: cardBg,
                            borderColor: cardBorder,
                            mutedColor: mutedText,
                            valueColor: valueText,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InfoCardWidget(
                            title: 'GÉNERO',
                            value: character.gender,
                            backgroundColor: cardBg,
                            borderColor: cardBorder,
                            mutedColor: mutedText,
                            valueColor: valueText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    WideInfoCardWidget(
                      title: 'ORIGEN',
                      value: character.origin.name,
                      icon: Icons.public_rounded,
                      iconBackground: accentMuted,
                      iconColor: accentColor,
                      backgroundColor: cardBg,
                      borderColor: cardBorder,
                      mutedColor: mutedText,
                      valueColor: valueText,
                    ),
                    const SizedBox(height: 12),
                    WideInfoCardWidget(
                      title: 'ULTIMA UBICACIÓN',
                      value: character.location.name,
                      icon: Icons.location_on_rounded,
                      iconBackground: accentMuted,
                      iconColor: accentColor,
                      backgroundColor: cardBg,
                      borderColor: cardBorder,
                      mutedColor: mutedText,
                      valueColor: valueText,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
