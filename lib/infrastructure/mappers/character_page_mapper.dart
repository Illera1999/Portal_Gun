import 'package:portal_gun/lib.dart';

class CharacterPageMapper {
  const CharacterPageMapper._();

  static CharacterPageEntity toEntity(CharactersResponseDto dto) {
    return CharacterPageEntity(
      count: dto.info.count,
      pages: dto.info.pages,
      nextPage: _extractPage(dto.info.next),
      prevPage: _extractPage(dto.info.prev),
      results: CharacterMapper.toEntityList(dto.results),
    );
  }

  static int? _extractPage(String? url) {
    if (url == null || url.isEmpty) return null;

    final uri = Uri.tryParse(url);
    final pageParam = uri?.queryParameters['page'];

    return int.tryParse(pageParam ?? '');
  }
}
