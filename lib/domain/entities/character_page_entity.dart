import 'package:portal_gun/lib.dart';

class CharactersPageEntity {
  const CharactersPageEntity({
    required this.count,
    required this.pages,
    required this.nextPage,
    required this.prevPage,
    required this.results,
  });

  final int count;
  final int pages;
  final int? nextPage;
  final int? prevPage;
  final List<CharacterEntity> results;

  bool get hasNextPage => nextPage != null;

  CharactersPageEntity.empty({
    int? count,
    int? pages,
    int? nextPage,
    int? prevPage,
    List<CharacterEntity>? results,
  }) : this(
         count: count ?? 0,
         pages: pages ?? 0,
         nextPage: nextPage,
         prevPage: prevPage,
         results: results ?? [],
       );
}
