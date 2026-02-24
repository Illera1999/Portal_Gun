# Router, deep links y startup/splash

## Router

El proyecto usa `go_router`.

Archivo principal:
- `lib/config/router/app_router.dart`

## Estructura de navegación

### Splash inicial

Ruta inicial:
- `/startup/splash`

Se usa para ejecutar una secuencia de arranque antes de entrar al shell principal.

### Shell con tabs

Se usa `StatefulShellRoute.indexedStack` para:
- tab `Home` (`/home`)
- tab `About` (`/about`)

Ventajas:
- cada pestaña tiene ruta real
- conserva estado por pestaña
- es escalable para añadir más ramas

## Tabla de rutas (actual)

- `/startup/splash`
- `/home`
- `/home/character/:id`
- `/about`

## Detalle de personaje

Ruta:
- `/home/character/:id`

El detalle se renderiza en el `root navigator` (mediante `parentNavigatorKey`) para que:
- no se muestre el bottom navigation bar encima del detalle
- se comporte como una pantalla “encima” del shell

## Deep links

La configuración está preparada para deep links porque:
- las rutas son reales (`/home`, `/about`, `/home/character/:id`)
- el `id` del detalle se valida en el router (`redirect` si no es entero)

Ejemplo válido:
- `/home/character/1`

Ejemplo inválido (redirige):
- `/home/character/abc` -> redirección a `/home`

## Startup / Splash (preparado para inicialización real)

Archivos:
- `lib/presentation/pages/startup/splash_page.dart`
- `lib/presentation/pages/startup/providers/startup_provider.dart`
- `lib/infrastructure/startup/app_startup_service_impl.dart`

Actualmente el startup:
- espera una duración mínima de splash
- ejecuta pasos placeholder (`session`, `preferences`, `remote config`, `warm up caches`)
- navega a `Home`

Aunque algunas tareas estén como `TODO`, la estructura ya está preparada para un arranque real (auth, config remota, precarga ligera, etc.).

## Por qué mantener Splash aunque hoy sea simple

- Deja preparado un punto único de inicialización.
- Evita mezclar carga de servicios en el árbol principal de UI.
- Facilita futuras ampliaciones (auth, onboarding, feature flags, warm-up, etc.).

## Posibles mejoras

- Añadir redirects globales si se introduce autenticación.
- Definir rutas nombradas (`name`) para navegación más segura (`pushNamed`) en flujos complejos.
- Añadir tests de navegación (widgets/integration) para validar rutas y redirects.
