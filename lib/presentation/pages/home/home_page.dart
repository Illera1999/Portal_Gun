import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_gun/lib.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const pathRoute = '/home';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ProviderSubscription<
    AsyncValue<CustomResponse<CharacterPageEntity>>
  >
  _snackbarSub;

  @override
  void initState() {
    super.initState();

    _snackbarSub = ref.listenManual(providerCharactersController, (
      previous,
      next,
    ) {
      final currentResponse = next.asData?.value;
      if (currentResponse == null) return;

      final status = currentResponse.status;
      if (status == CustomResponseStatus.ok) return;

      if (!mounted) return;

      String? message;

      switch (status) {
        case CustomResponseStatus.badRequest:
          message =
              'La solicitud no es válida. Revisa los parámetros e inténtalo de nuevo.';
          break;
        case CustomResponseStatus.notFound:
          message = 'No se han encontrado resultados para esta petición.';
          break;
        case CustomResponseStatus.tooManyRequests:
          message =
              'Se han realizado demasiadas peticiones. Inténtalo de nuevo en unos segundos.';
          break;
        case CustomResponseStatus.serverError:
          message =
              'Se ha producido un error del servidor. Inténtalo de nuevo más tarde.';
          break;
        case CustomResponseStatus.unknown:
          message = 'Ha ocurrido un error inesperado. Inténtalo de nuevo.';
          break;
        case CustomResponseStatus.ok:
          break;
      }

      if (message == null) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
      return;
    });
  }

  @override
  void dispose() {
    _snackbarSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charactersController = ref.watch(providerCharactersController);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: charactersController.when(
          loading: () => const Center(child: CircularProgressWidget()),
          error: (error, stackTrace) => GenericErrorWidget(
            retryInvalidators: [
              (ref) => ref.invalidate(providerCharactersController),
            ],
            title: 'No se pudo cargar el listado',
            message:
                'Ha ocurrido un error al cargar los personajes. Puedes reintentar ahora.',
          ),
          data: (response) {
            final page = response.data;
            final characters = page?.results ?? const <CharacterEntity>[];
            final screenWidth = MediaQuery.sizeOf(context).width;
            final crossAxisCount = screenWidth >= 960
                ? 4
                : screenWidth >= 680
                ? 3
                : 2;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personajes de Rick y Morty',
                          style:
                              textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colorScheme.onSurface,
                                letterSpacing: -0.6,
                              ) ??
                              TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: colorScheme.onSurface,
                                letterSpacing: -0.6,
                              ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                if (characters.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No personajes encontrados')),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final character = characters[index];

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () => context.push(
                              '${HomePage.pathRoute}/${CharacterDetailPage.pathRoute.replaceFirst(':id', '${character.id}')}',
                            ),
                            child: CharacterCardWidget(character: character),
                          ),
                        );
                      }, childCount: characters.length),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (page != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Cargados ${characters.length} personajes'
                              ' (página ${page.prevPage == null ? 1 : page.prevPage! + 1} de ${page.pages})',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: page?.hasNextPage == true
                              ? () {
                                  ref
                                      .read(
                                        providerCharactersController.notifier,
                                      )
                                      .loadNextPage();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            disabledBackgroundColor:
                                colorScheme.surfaceContainerHighest,
                            disabledForegroundColor:
                                colorScheme.onSurfaceVariant,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            page?.hasNextPage == true
                                ? 'Cargar más personajes'
                                : 'No hay más páginas',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
