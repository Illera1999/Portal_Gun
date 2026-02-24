# HTTP, DTOs y `CustomResponse`

## Cliente HTTP

Se usa `dio` para consumir la API pública de Rick and Morty.

Archivo principal:
- `lib/infrastructure/datasources/rick_and_morty_api_datasource.dart`

## Flujo de datos

1. `dio` recibe JSON
2. JSON -> DTO (`fromJson`)
3. DTO -> Entity (mapper)
4. Repository devuelve resultado a la capa de presentación

## DTO vs Entity

### DTO (`infrastructure/models`)

Representa la forma exacta de la respuesta de la API.

Ejemplos:
- `CharacterDto`
- `CharactersResponseDto`

### Entity (`domain/entities`)

Representa el modelo que usa la app.

Ejemplos:
- `CharacterEntity`
- `CharactersPageEntity`

## `CustomResponse`

Archivo:
- `lib/domain/entities/custom_response.dart`

Se usa para devolver una respuesta tipada desde datasource/repository:
- `status` (`200`, `400`, `404`, `429`, `500`, `unknown`)
- `data` (si aplica)

### Ventajas

- La capa de presentación no depende de `DioException`
- El manejo de errores es más explícito
- Permite reaccionar por código de estado (`429` -> snackbar, etc.)

## Paginación

La API devuelve:
- `info` (`count`, `pages`, `next`, `prev`)
- `results` (lista de personajes)

Se transforma a `CharactersPageEntity`, donde:
- la app usa `results`
- `next/prev` se convierten a `nextPage` / `prevPage` (`int?`)

Esto simplifica la lógica de `loadNextPage()`.

## Archivos relacionados (implementación actual)

- DTO paginado: `lib/infrastructure/models/characters_response_dto.dart`
- Entity paginada: `lib/domain/entities/characters_page_entity.dart`
- Mapper paginado: `lib/infrastructure/mappers/character_page_mapper.dart`
- Repository contrato: `lib/domain/repositories/rick_and_morty_repository.dart`

## Posibles mejoras

### 1. Separar éxito/error en tipos distintos

Actualmente `CustomResponse<T>` representa tanto éxito como error mediante `status + data`.

Una evolución posible sería usar un modelo más explícito (por ejemplo, `CustomResult<T>` con variantes de éxito y error) para:
- evitar estados ambiguos (`status` de error con `data` presente),
- mejorar el tipado en la capa de presentación.

### 2. Añadir más contexto de error

`CustomResponse` podría incluir campos opcionales como:
- `message`
- `rawStatusCode`
- `errorCode` (si el backend lo devuelve)
- `retryAfter`

Esto facilitaría mostrar mensajes más precisos y gestionar casos como `429` con backoff.

### 3. Manejo de reintentos y rate limiting

Para `429 Too Many Requests`, se puede mejorar la experiencia leyendo el header `Retry-After` y aplicando:
- cooldown temporal,
- reintento manual bloqueado durante X segundos,
- mensaje UI con tiempo restante.

### 4. Logging condicionado por entorno

Ahora existe logging simple de URL + status. Se puede mejorar para que:
- en `dev` se registren más detalles,
- en `prod` se desactive o se reduzca el nivel de logs,
- se conecte a una herramienta de observabilidad (si aplica).

### 5. Caching / persistencia local

Si la app creciera, se podría añadir cache local para:
- reducir llamadas repetidas,
- mejorar tiempos de carga,
- soportar uso offline parcial.

Esto encajaría bien manteniendo la misma separación por capas (domain/infrastructure/presentation).

### 6. DTOs generados automáticamente (opcional)

Para proyectos más grandes, se puede valorar generación de código (`json_serializable`, `freezed`, etc.) para:
- reducir boilerplate en `fromJson`,
- mejorar consistencia,
- simplificar mantenimiento de modelos.

En esta prueba se ha priorizado implementación manual por simplicidad y claridad.
