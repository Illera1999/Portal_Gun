# Arquitectura y capas

## Objetivo

Separar claramente UI, estado y acceso a datos para que el proyecto sea fácil de mantener, testear y extender.

## Estructura principal

- `lib/config`
- `lib/domain`
- `lib/infrastructure`
- `lib/presentation`

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

### `infrastructure`

Implementación técnica de acceso a datos:
- `dio` para HTTP
- DTOs (`fromJson`)
- mappers (`DTO -> Entity`)
- implementaciones de datasource/repository

Aquí es donde se transforma la respuesta de la API pública en entidades de dominio.

### `presentation`

UI + estado de pantalla:
- páginas
- widgets reutilizables
- providers/controladores de Riverpod

Se mantiene separada de `infrastructure` mediante el uso de interfaces (`domain/repositories`).

## Por qué esta estructura

- Permite testear lógica sin UI ni red real.
- Hace más sencillo cambiar la API/cliente HTTP en el futuro.
- Reduce el acoplamiento entre widgets y detalles de backend.
- Escala mejor si se añaden más features (favoritos, filtros, búsqueda, etc.).

## Nota de diseño

Se usa un `barrel` (`lib/lib.dart`) para centralizar exports y simplificar imports en el proyecto.
