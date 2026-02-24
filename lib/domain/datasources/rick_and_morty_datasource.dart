import 'package:portal_gun/lib.dart';

abstract class RickAndMortyDatasource {
  Future<CustomResponse<CharacterPageEntity>> getCharacters({int page = 1});
  Future<CustomResponse<CharacterEntity>> getCharacterById(int id);
}
