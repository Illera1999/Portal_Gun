import 'package:portal_gun/lib.dart';

class RickAndMortyRepositoryImpl implements RickAndMortyRepository {
  RickAndMortyRepositoryImpl({required RickAndMortyDatasource datasource})
    : _datasource = datasource;

  final RickAndMortyDatasource _datasource;

  @override
  Future<CustomResponse<CharacterPageEntity>> getCharacters({int page = 1}) {
    return _datasource.getCharacters(page: page);
  }

  @override
  Future<CustomResponse<CharacterEntity>> getCharacterById(int id) {
    return _datasource.getCharacterById(id);
  }
}
