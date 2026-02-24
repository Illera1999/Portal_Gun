# Arquitectura y capas

## Objetivo

Separar claramente UI, estado y acceso a datos para que el proyecto sea fácil de mantener, testear y extender.

## Estructura principal

- `lib/config`
- `lib/domain`
- `lib/infrastructure`
- `lib/presentation`

## Regla de dependencias (dirección)

La dirección de dependencias intenta mantenerse así:

- `presentation` -> `domain`
- `infrastructure` -> `domain`
- `config` -> puede orquestar `presentation` y configuración global
- `domain` -> no depende de `presentation` ni de `infrastructure`

Esto permite cambiar implementaciones técnicas sin afectar a la UI o al dominio.

## Responsabilidad por capa

### `config`

Configuración transversal de la app:
- arranque (`bootstrap`)
- tema (`AppTheme`)
- router (`go_router`)
- `AppConfig` (entorno, nombre de app, flags)

### `domain`

Reglas y contratos de negocio (sin dependencias de Flutter ni de red):
- `entities`
- `datasources` (interfaces)
- `repositories` (interfaces)
- `startup` (contrato del servicio de inicio)

Ejemplo:
- `RickAndMortyDatasource` define qué operaciones existen
- `RickAndMortyRepository` define la API que consume la capa de presentación

Regla práctica:
- aquí no hay `Dio`, `BuildContext`, `Widget`, `fromJson`, etc.

### `infrastructure`

Implementación técnica de acceso a datos:
- `dio` para HTTP
- DTOs (`fromJson`)
- mappers (`DTO -> Entity`)
- implementaciones de datasource/repository

Aquí es donde se transforma la respuesta de la API pública en entidades de dominio.

Responsabilidades típicas en esta capa:
- mapear códigos HTTP a `CustomResponseStatus`
- parsear DTOs
- extraer paginación (`next/prev -> nextPage/prevPage`)
- centralizar logging técnico de red

### `presentation`

UI + estado de pantalla:
- páginas
- widgets reutilizables
- providers/controladores de Riverpod

Se mantiene separada de `infrastructure` mediante el uso de interfaces (`domain/repositories`).

Organización usada en este proyecto:
- `pages/*` para pantallas por feature
- `pages/*/widgets` para widgets locales de la feature
- `shares/providers` para providers reutilizables/globales
- `shares/widgets` para widgets compartidos (por ejemplo error genérico, loading)

## Flujo end-to-end (ejemplo Home)

1. `HomePage` observa `providerCharactersController`
2. `CharactersController` pide datos al repository
3. `RickAndMortyRepositoryImpl` delega en datasource
4. `RickAndMortyApiDatasource` usa `dio`
5. JSON -> DTO -> Entity
6. El controller actualiza estado y la UI se reconstruye

## Decisiones de diseño destacadas

### `go_router` + shell route

Se usa `StatefulShellRoute.indexedStack` para conservar estado por pestaña y tener rutas reales.

### `CustomResponse`

Se usa una respuesta tipada simple (`status + data`) para desacoplar la UI de `DioException`.

### Error genérico reutilizable

Se opta por `GenericErrorWidget` con callbacks de retry (invalidación de providers), en lugar de una pantalla de error dedicada.

## Tradeoffs asumidos en esta entrega

- Se priorizó claridad y funcionalidad sobre sofisticación arquitectónica extra (por ejemplo, no se añadió cache local).
- Se mantuvo `CustomResponse` simple para acelerar la implementación y hacer el flujo fácil de leer.
- Se dejó la UI visualmente cuidada pero sin entrar en más animaciones/transiciones por tiempo.

## Por qué esta estructura

- Permite testear lógica sin UI ni red real.
- Hace más sencillo cambiar la API/cliente HTTP en el futuro.
- Reduce el acoplamiento entre widgets y detalles de backend.
- Escala mejor si se añaden más features (favoritos, filtros, búsqueda, etc.).

## Nota de diseño

Se usa un `barrel` (`lib/lib.dart`) para centralizar exports y simplificar imports en el proyecto.

Tradeoff del `barrel`:
- simplifica imports y acelera desarrollo,
- pero en proyectos grandes puede ocultar dependencias si se abusa.
