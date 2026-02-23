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

    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final asyncCharacter = ref.watch(
              providerCharacterDetailController(id),
            );

            return asyncCharacter.when(
              loading: () => const Center(child: CircularProgressWidget()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Error al cargar el detalle:\n$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
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
    final accentMuted = AppColors.primary.withValues(alpha: 0.18);
    final cardBg = const Color(0xFF141C2D);
    final cardBorder = const Color(0xFF23304B);
    final mutedText = AppColors.background.withValues(alpha: 0.68);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeroHeaderWidget(character: character),
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
                      iconColor: AppColors.primary,
                      backgroundColor: cardBg,
                      borderColor: cardBorder,
                      mutedColor: mutedText,
                    ),
                    const SizedBox(height: 12),
                    WideInfoCardWidget(
                      title: 'ULTIMA UBICACIÓN',
                      value: character.location.name,
                      icon: Icons.location_on_rounded,
                      iconBackground: accentMuted,
                      iconColor: AppColors.primary,
                      backgroundColor: cardBg,
                      borderColor: cardBorder,
                      mutedColor: mutedText,
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
