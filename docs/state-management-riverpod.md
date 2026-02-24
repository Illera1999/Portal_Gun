# Gestión de estado con Riverpod

## Enfoque usado

El proyecto usa `flutter_riverpod` para:
- dependencias compartidas (repository, startup service, config)
- estado de tema (claro/oscuro)
- controladores asíncronos de pantalla (listado y detalle)

## Providers principales

### Configuración global

- `providerAppConfig`
  - definido en `bootstrap`
  - permite cambiar entorno (`dev`/`prod`) sin tocar widgets

### Tema

- `providerThemeMode`
  - gestiona `ThemeMode.light` / `ThemeMode.dark`
  - se consume en `MaterialApp.router`

### Datos Rick and Morty

- `providerRickAndMortyRepository`
  - expone el repository que usa la UI

### Otros providers compartidos

- `providerPackageInfo`
  - obtiene información real de la app (`appName`, `version`, `buildNumber`, `packageName`)
  - se usa en `About`

- `providerStartup`
  - ejecuta el flujo de startup y devuelve el destino de navegación

## Home (listado paginado)

Archivo clave:
- `lib/presentation/pages/home/providers/characters_controller_provider.dart`

Se usa un `AsyncNotifierProvider`:
- carga inicial en `build()`
- paginación con `loadNextPage()`
- conserva resultados ya cargados si falla una página posterior
- permite reaccionar al `status` (`429`, `500`, etc.) para UI (por ejemplo, `SnackBar` personalizado en `Home`)

El estado actual del controller expone `CustomResponse<CharactersPageEntity>` para que la UI pueda:
- leer `results`
- reaccionar a `status` (`429`, `500`, etc.)

### Manejo de `429` en Home

`HomePage` usa `ref.listenManual(...)` para escuchar cambios del estado del controller y:
- detectar `CustomResponseStatus.tooManyRequests`
- mostrar un `SnackBar` con mensaje personalizado

Esto permite mantener el render principal desacoplado de efectos de UI (mensajes, navegación, dialogs).

## Detail (detalle por id)

Archivo clave:
- `lib/presentation/pages/home/providers/character_detail_controller_provider.dart`

Se usa `AsyncNotifierProvider.autoDispose.family` con parámetro `int` (`id`), lo que permite:
- un provider por personaje
- invalidar/reintentar el detalle de un id concreto
- liberar el estado al salir del detalle

`autoDispose` se usa intencionadamente para dar la sensación de “volver a pedir los datos” cuando el usuario entra de nuevo al detalle (útil en una demo/prueba técnica y coherente con el flujo de refresco).

## Patrón de reintento

El retry no llama directamente a métodos del controller desde el widget de error.

En su lugar, se invalida el provider correspondiente:
- `ref.invalidate(providerCharactersController)`
- `ref.invalidate(providerCharacterDetailController(id))`

Ventajas:
- patrón uniforme
- menos acoplamiento con la implementación del controller
- Riverpod vuelve a ejecutar el flujo de carga de forma natural

## Reintentos y errores

El widget genérico de error (`GenericErrorWidget`) recibe callbacks tipados de invalidación:
- ejemplo: `(ref) => ref.invalidate(providerCharactersController)`
- ejemplo: `(ref) => ref.invalidate(providerCharacterDetailController(id))`

Esto mantiene la lógica de reintento reutilizable y desacoplada de cada pantalla.

No existe una pantalla/pestaña de error dedicada: cada vista resuelve su estado de error localmente y ofrece reintento desde el propio contenido.

## Posibles mejoras

- Migrar el estado de `Home` a un estado de UI específico (`items`, `isLoadingMore`, `hasMore`, `lastErrorStatus`) en vez de exponer `CustomResponse` directamente.
- Añadir tests unitarios del provider de detalle.
- Añadir tests de widget para `HomePage` / `CharacterDetailPage` y validación de `SnackBar`.
