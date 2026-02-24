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

## Detail (detalle por id)

Archivo clave:
- `lib/presentation/pages/home/providers/character_detail_controller_provider.dart`

Se usa `AsyncNotifierProvider.autoDispose.family` con parámetro `int` (`id`), lo que permite:
- un provider por personaje
- invalidar/reintentar el detalle de un id concreto
- liberar el estado al salir del detalle

`autoDispose` se usa intencionadamente para dar la sensación de “volver a pedir los datos” cuando el usuario entra de nuevo al detalle (útil en una demo/prueba técnica y coherente con el flujo de refresco).

## Reintentos y errores

El widget genérico de error (`GenericErrorWidget`) recibe callbacks tipados de invalidación:
- ejemplo: `(ref) => ref.invalidate(providerCharactersController)`
- ejemplo: `(ref) => ref.invalidate(providerCharacterDetailController(id))`

Esto mantiene la lógica de reintento reutilizable y desacoplada de cada pantalla.

No existe una pantalla/pestaña de error dedicada: cada vista resuelve su estado de error localmente y ofrece reintento desde el propio contenido.
