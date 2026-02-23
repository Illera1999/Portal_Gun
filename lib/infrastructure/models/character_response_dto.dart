import 'package:portal_gun/lib.dart';

class CharactersResponseDto {
  const CharactersResponseDto({required this.info, required this.results});

  final CharactersInfoDto info;
  final List<CharacterDto> results;

  factory CharactersResponseDto.fromJson(Map<String, dynamic> json) {
    return CharactersResponseDto(
      info: CharactersInfoDto.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((item) => CharacterDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CharactersInfoDto {
  const CharactersInfoDto({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
  });

  final int count;
  final int pages;
  final String? next;
  final String? prev;

  factory CharactersInfoDto.fromJson(Map<String, dynamic> json) {
    return CharactersInfoDto(
      count: json['count'] as int,
      pages: json['pages'] as int,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );
  }
}
