import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_gun/lib.dart';

final providerCharactersController =
    AsyncNotifierProvider<
      CharactersController,
      CustomResponse<CharactersPageEntity>
    >(CharactersController.new);

class CharactersController
    extends AsyncNotifier<CustomResponse<CharactersPageEntity>> {
  bool _isLoadingNext = false;

  @override
  Future<CustomResponse<CharactersPageEntity>> build() async {
    final repo = ref.watch(providerRickAndMortyRepository);
    final response = await repo.getCharacters(page: 1);
    if (response.status != CustomResponseStatus.ok || response.data == null) {
      throw Exception('Failed to load characters');
    }
    return response;
  }

  Future<void> loadNextPage() async {
    if (_isLoadingNext) return;

    final currentResponse = state.asData?.value;
    if (currentResponse == null) return;

    final currentPage = currentResponse.data;
    if (currentPage == null) return;
    if (!currentPage.hasNextPage) return;

    _isLoadingNext = true;

    try {
      final repo = ref.read(providerRickAndMortyRepository);
      final response = await repo.getCharacters(page: currentPage.nextPage!);

      if (response.status != CustomResponseStatus.ok) {
        state = AsyncData(
          CustomResponse<CharactersPageEntity>(
            status: response.status,
            data: currentPage,
          ),
        );
        return;
      }

      final nextPage = response.data;
      if (nextPage == null) {
        state = AsyncData(
          CustomResponse<CharactersPageEntity>(
            status: CustomResponseStatus.unknown,
            data: currentPage,
          ),
        );
        return;
      }

      state = AsyncData(
        CustomResponse.success(
          CharactersPageEntity(
            count: nextPage.count,
            pages: nextPage.pages,
            nextPage: nextPage.nextPage,
            prevPage: nextPage.prevPage,
            results: [...currentPage.results, ...nextPage.results],
          ),
        ),
      );
    } catch (_) {
      state = AsyncData(
        CustomResponse<CharactersPageEntity>(
          status: CustomResponseStatus.unknown,
          data: currentPage,
        ),
      );
    } finally {
      _isLoadingNext = false;
    }
  }
}
