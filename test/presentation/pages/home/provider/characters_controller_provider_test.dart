import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portal_gun/lib.dart';

void main() {
  group('CharactersController pagination', () {
    test('loadNextPage appends next page results', () async {
      final fakeRepo = _FakeRickAndMortyRepository(
        pages: {
          1: CustomResponse.success(
            CharacterPageEntity(
              count: 4,
              pages: 2,
              nextPage: 2,
              prevPage: null,
              results: [_character(1), _character(2)],
            ),
          ),
          2: CustomResponse.success(
            CharacterPageEntity(
              count: 4,
              pages: 2,
              nextPage: null,
              prevPage: 1,
              results: [_character(3), _character(4)],
            ),
          ),
        },
      );

      final container = ProviderContainer(
        overrides: [
          providerRickAndMortyRepository.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final firstPage = await container.read(
        providerCharactersController.future,
      );
      expect(firstPage.status, CustomResponseStatus.ok);
      expect(firstPage.data, isNotNull);
      expect(firstPage.data!.results.map((e) => e.id).toList(), [1, 2]);

      await container
          .read(providerCharactersController.notifier)
          .loadNextPage();

      final current = container.read(providerCharactersController).requireValue;
      expect(current.status, CustomResponseStatus.ok);
      expect(current.data, isNotNull);
      expect(current.data!.results.map((e) => e.id).toList(), [1, 2, 3, 4]);
      expect(fakeRepo.getCharactersCalls, 2);
    });

    test(
      'loadNextPage keeps current list and exposes error status when request fails',
      () async {
        final fakeRepo = _FakeRickAndMortyRepository(
          pages: {
            1: CustomResponse.success(
              CharacterPageEntity(
                count: 4,
                pages: 2,
                nextPage: 2,
                prevPage: null,
                results: [_character(1), _character(2)],
              ),
            ),
            2: const CustomResponse<CharacterPageEntity>(
              status: CustomResponseStatus.serverError,
            ),
          },
        );

        final container = ProviderContainer(
          overrides: [
            providerRickAndMortyRepository.overrideWith((ref) => fakeRepo),
          ],
        );
        addTearDown(container.dispose);

        await container.read(providerCharactersController.future);
        await container
            .read(providerCharactersController.notifier)
            .loadNextPage();

        final current = container
            .read(providerCharactersController)
            .requireValue;
        expect(current.status, CustomResponseStatus.serverError);
        expect(current.data, isNotNull);
        expect(current.data!.results.map((e) => e.id).toList(), [1, 2]);
        expect(fakeRepo.getCharactersCalls, 2);
      },
    );

    test('loadNextPage does nothing when there is no next page', () async {
      final fakeRepo = _FakeRickAndMortyRepository(
        pages: {
          1: CustomResponse.success(
            CharacterPageEntity(
              count: 2,
              pages: 1,
              nextPage: null,
              prevPage: null,
              results: [_character(1), _character(2)],
            ),
          ),
        },
      );

      final container = ProviderContainer(
        overrides: [
          providerRickAndMortyRepository.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(providerCharactersController.future);
      await container
          .read(providerCharactersController.notifier)
          .loadNextPage();

      final current = container.read(providerCharactersController).requireValue;
      expect(current.status, CustomResponseStatus.ok);
      expect(current.data!.results.map((e) => e.id).toList(), [1, 2]);
      expect(fakeRepo.getCharactersCalls, 1);
    });

    test(
      'loadNextPage sets unknown status and preserves list when next response has no data',
      () async {
        final fakeRepo = _FakeRickAndMortyRepository(
          pages: {
            1: CustomResponse.success(
              CharacterPageEntity(
                count: 4,
                pages: 2,
                nextPage: 2,
                prevPage: null,
                results: [_character(1), _character(2)],
              ),
            ),
            2: const CustomResponse<CharacterPageEntity>(
              status: CustomResponseStatus.ok,
            ),
          },
        );

        final container = ProviderContainer(
          overrides: [
            providerRickAndMortyRepository.overrideWith((ref) => fakeRepo),
          ],
        );
        addTearDown(container.dispose);

        await container.read(providerCharactersController.future);
        await container
            .read(providerCharactersController.notifier)
            .loadNextPage();

        final current = container
            .read(providerCharactersController)
            .requireValue;
        expect(current.status, CustomResponseStatus.unknown);
        expect(current.data, isNotNull);
        expect(current.data!.results.map((e) => e.id).toList(), [1, 2]);
        expect(fakeRepo.getCharactersCalls, 2);
      },
    );

    test(
      'loadNextPage catches repository exception and preserves current list with unknown status',
      () async {
        final fakeRepo = _FakeRickAndMortyRepository(
          pages: {
            1: CustomResponse.success(
              CharacterPageEntity(
                count: 4,
                pages: 2,
                nextPage: 2,
                prevPage: null,
                results: [_character(1), _character(2)],
              ),
            ),
          },
          exceptionsByPage: {2: Exception('network down')},
        );

        final container = ProviderContainer(
          overrides: [
            providerRickAndMortyRepository.overrideWith((ref) => fakeRepo),
          ],
        );
        addTearDown(container.dispose);

        await container.read(providerCharactersController.future);
        await container
            .read(providerCharactersController.notifier)
            .loadNextPage();

        final current = container
            .read(providerCharactersController)
            .requireValue;
        expect(current.status, CustomResponseStatus.unknown);
        expect(current.data, isNotNull);
        expect(current.data!.results.map((e) => e.id).toList(), [1, 2]);
        expect(fakeRepo.getCharactersCalls, 2);
      },
    );

    test('build exposes async error when first page is not ok', () async {
      final fakeRepo = _FakeRickAndMortyRepository(
        pages: {
          1: const CustomResponse<CharacterPageEntity>(
            status: CustomResponseStatus.serverError,
          ),
        },
      );

      final container = ProviderContainer(
        overrides: [
          providerRickAndMortyRepository.overrideWith((ref) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container
          .listen<AsyncValue<CustomResponse<CharacterPageEntity>>>(
            providerCharactersController,
            (previous, next) {},
            fireImmediately: true,
          );
      addTearDown(subscription.close);

      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final state = container.read(providerCharactersController);
      expect(state.hasError, isTrue);
      expect(fakeRepo.getCharactersCalls, 1);
    });
  });
}

class _FakeRickAndMortyRepository implements RickAndMortyRepository {
  _FakeRickAndMortyRepository({
    required this.pages,
    this.exceptionsByPage = const {},
  });

  final Map<int, CustomResponse<CharacterPageEntity>> pages;
  final Map<int, Exception> exceptionsByPage;
  int getCharactersCalls = 0;

  @override
  Future<CustomResponse<CharacterPageEntity>> getCharacters({
    int page = 1,
  }) async {
    getCharactersCalls++;

    final exception = exceptionsByPage[page];
    if (exception != null) throw exception;

    return pages[page] ??
        const CustomResponse<CharacterPageEntity>(
          status: CustomResponseStatus.notFound,
        );
  }

  @override
  Future<CustomResponse<CharacterEntity>> getCharacterById(int id) async {
    return const CustomResponse<CharacterEntity>(
      status: CustomResponseStatus.notFound,
    );
  }
}

CharacterEntity _character(int id) {
  return CharacterEntity(
    id: id,
    name: 'Character $id',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    origin: const CharacterReferenceEntity(name: 'Earth', url: ''),
    location: const CharacterReferenceEntity(name: 'Earth', url: ''),
    imageUrl: 'https://example.com/character/$id.png',
    episodeUrls: const [],
    apiUrl: 'https://example.com/api/character/$id',
    createdAt: DateTime(2020, 1, 1),
  );
}
