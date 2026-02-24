import 'package:portal_gun/lib.dart';

abstract class RickAndMortyRepository {
  Future<CustomResponse<CharacterPageEntity>> getCharacters({int page = 1});
  Future<CustomResponse<CharacterEntity>> getCharacterById(int id);
}
