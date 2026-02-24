import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_gun/lib.dart';

final providerCharacterDetailController =
    AsyncNotifierProvider.autoDispose.family<
      CharacterDetailController,
      CharacterEntity,
      int
    >(CharacterDetailController.new);

class CharacterDetailController extends AsyncNotifier<CharacterEntity> {
  CharacterDetailController(this._id);

  final int _id;

  @override
  Future<CharacterEntity> build() async {
    final repo = ref.watch(providerRickAndMortyRepository);
    final response = await repo.getCharacterById(_id);

    if (response.status != CustomResponseStatus.ok || response.data == null) {
      throw Exception(
        'Failed to load character detail. Status: ${response.status.code}',
      );
    }

    return response.data!;
  }
}
