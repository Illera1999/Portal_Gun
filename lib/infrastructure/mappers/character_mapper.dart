import 'package:portal_gun/lib.dart';

class CharacterMapper {
  const CharacterMapper._();

  static CharacterEntity toEntity(CharacterDto dto) {
    return CharacterEntity(
      id: dto.id,
      name: dto.name,
      status: dto.status,
      species: dto.species,
      type: dto.type,
      gender: dto.gender,
      origin: CharacterReferenceEntity(
        name: dto.origin.name,
        url: dto.origin.url,
      ),
      location: CharacterReferenceEntity(
        name: dto.location.name,
        url: dto.location.url,
      ),
      imageUrl: dto.image,
      episodeUrls: dto.episode,
      apiUrl: dto.url,
      createdAt: dto.created,
    );
  }

  static List<CharacterEntity> toEntityList(List<CharacterDto> dtos) {
    return dtos.map(toEntity).toList(growable: false);
  }
}
