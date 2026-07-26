# Flujo de Trabajo y Compilación

## Instalación de Dependencias

```bash
flutter pub get
```

## Ejecución en Modo Desarrollo

El comando principal levantará la app utilizando las variables de entorno por defecto:

```bash
flutter run
```

## Generación de Producción (Android)

Para compilar la aplicación para la Google Play Store (creación del Android App Bundle - AAB), asegúrate de tener los certificados de firma (Keystore) configurados en `android/key.properties`, y luego ejecuta:

```bash
flutter build appbundle --release
```
