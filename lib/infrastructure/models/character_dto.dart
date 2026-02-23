class CharacterDto {
  const CharacterDto({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final CharacterReferenceDto origin;
  final CharacterReferenceDto location;
  final String image;
  final List<String> episode;
  final String url;
  final DateTime created;

  factory CharacterDto.fromJson(Map<String, dynamic> json) {
    return CharacterDto(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: (json['type'] as String?) ?? '',
      gender: json['gender'] as String,
      origin: CharacterReferenceDto.fromJson(
        json['origin'] as Map<String, dynamic>,
      ),
      location: CharacterReferenceDto.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      image: json['image'] as String,
      episode: (json['episode'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      url: json['url'] as String,
      created: DateTime.parse(json['created'] as String),
    );
  }
}

class CharacterReferenceDto {
  const CharacterReferenceDto({required this.name, required this.url});

  final String name;
  final String url;

  factory CharacterReferenceDto.fromJson(Map<String, dynamic> json) {
    return CharacterReferenceDto(
      name: (json['name'] as String?) ?? '',
      url: (json['url'] as String?) ?? '',
    );
  }
}
