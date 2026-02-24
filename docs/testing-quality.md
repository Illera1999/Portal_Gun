# Testing y calidad

## Qué se ha cubierto

El proyecto incluye tests unitarios orientados a la lógica de paginación del listado de personajes.

Archivo principal:
- `test/presentation/pages/home/provider/characters_controller_provider_test.dart`

## Qué se valida en los tests actuales

- carga inicial correcta de página 1
- concatenación de resultados al cargar siguiente página
- conservación de datos si falla una página posterior
- tratamiento de respuestas sin datos
- manejo de errores inesperados
- evitar llamadas innecesarias cuando no hay más páginas

## Por qué se eligió esta capa para testear

La paginación es una de las partes más sensibles de la prueba porque mezcla:
- datos remotos
- estados de UI
- errores parciales (mantener lista y reportar fallo)

Testear el controller aporta más valor que un test superficial de UI.

## Calidad estática

Comandos usados:

```bash
dart analyze
flutter test
```

## Posibles mejoras de testing

- Añadir tests unitarios del provider de detalle (`character_detail_controller_provider`).
- Añadir tests de widget para `HomePage`:
  - loading
  - empty
  - error con `GenericErrorWidget`
- Añadir tests de navegación (`Home` -> `Detail`).
- Añadir tests de integración para flujos completos (`Splash` -> shell -> `Home` -> `Detail`).
