import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_gun/lib.dart';

final providerRickAndMortyRepository = Provider<RickAndMortyRepository>((ref) {
  final datasource = RickAndMortyApiDatasource();
  return RickAndMortyRepositoryImpl(datasource: datasource);
});
