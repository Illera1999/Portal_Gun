# Portal Gun

Aplicación Flutter de prueba técnica basada en la API pública de Rick and Morty.

Incluye:
- navegación con `go_router` (tabs + detalle),
- gestión de estado con `Riverpod`,
- consumo HTTP con `dio`,
- listado paginado,
- pantalla de detalle,
- manejo de errores con reintento,
- control de `429` en `Home` con `SnackBar` y mensajes personalizados.

Nota:
- No existe una “pestaña de error” dedicada. El manejo de error se resuelve en cada pantalla con un bloque/estado de error y opción de **reintentar**.

## Comandos mínimos

```bash
flutter pub get
flutter run -t lib/main_dev.dart
```

## Comandos útiles

```bash
flutter run -t lib/main_prod.dart
flutter test
dart analyze
```

### Builds (APK / IPA)

```bash
flutter build apk --release -t lib/main_prod.dart
flutter build ipa --release -t lib/main_prod.dart
```

Nota:
- Para `ipa` necesitas firma/configuración de iOS (certificados/profiles) correctamente preparada.

## Índice de documentación técnica

- [Arquitectura y capas](docs/architecture.md)
- [Gestión de estado con Riverpod](docs/state-management-riverpod.md)
- [HTTP, DTOs y `CustomResponse`](docs/networking-custom-response.md)
- [Router, deep links y startup/splash](docs/navigation-startup.md)

## Archivos clave (referencia rápida)

- Router principal: [`lib/config/router/app_router.dart`](lib/config/router/app_router.dart)
- Splash / startup: [`lib/presentation/pages/startup/splash_page.dart`](lib/presentation/pages/startup/splash_page.dart)
- Servicio de startup: [`lib/infrastructure/startup/app_startup_service_impl.dart`](lib/infrastructure/startup/app_startup_service_impl.dart)
- Listado (Home): [`lib/presentation/pages/home/home_page.dart`](lib/presentation/pages/home/home_page.dart)
- Detalle personaje: [`lib/presentation/pages/home/character_detail_page.dart`](lib/presentation/pages/home/character_detail_page.dart)
- Controller detalle (`autoDispose`): [`lib/presentation/pages/home/providers/character_detail_controller_provider.dart`](lib/presentation/pages/home/providers/character_detail_controller_provider.dart)
- Controller paginación: [`lib/presentation/pages/home/providers/characters_controller_provider.dart`](lib/presentation/pages/home/providers/characters_controller_provider.dart)
- Respuesta tipada: [`lib/domain/entities/custom_response.dart`](lib/domain/entities/custom_response.dart)
- Tests de paginación: [`test/presentation/pages/home/provider/characters_controller_provider_test.dart`](test/presentation/pages/home/provider/characters_controller_provider_test.dart)

## Posibles mejoras

- Mejorar aún más el diseño visual general (UI/UX), especialmente algunos estados y transiciones.
- Ampliar el trabajo de decoración/acabado visual de la app (más pulido en detalles de layout, microinteracciones y refinamiento estético).
- Por tiempo, se priorizó dejar cerrada la funcionalidad principal (navegación, datos, estados, detalle, errores y tests) frente a seguir profundizando en el acabado visual.
