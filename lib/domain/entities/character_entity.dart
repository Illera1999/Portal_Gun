class CharacterEntity {
  const CharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.imageUrl,
    required this.episodeUrls,
    required this.apiUrl,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final CharacterReferenceEntity origin;
  final CharacterReferenceEntity location;
  final String imageUrl;
  final List<String> episodeUrls;
  final String apiUrl;
  final DateTime createdAt;
}

class CharacterReferenceEntity {
  const CharacterReferenceEntity({required this.name, required this.url});

  final String name;
  final String url;
}
