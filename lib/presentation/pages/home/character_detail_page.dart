import 'package:flutter/material.dart';

class CharacterDetailPage extends StatelessWidget {
  const CharacterDetailPage({super.key, required this.characterId});

  static const pathRoute = 'character/:id';

  final int? characterId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Character Detail')),
      body: Center(
        child: Text(
          characterId == null
              ? 'Character Detail Page'
              : 'Character ID: $characterId',
        ),
      ),
    );
  }
}
