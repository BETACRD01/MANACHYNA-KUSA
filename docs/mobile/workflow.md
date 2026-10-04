# 🛠️ Flujo de Trabajo y Compilación (Flutter)

Guía completa para configurar el entorno local, compilar, depurar inalámbricamente y generar los binarios de producción de la aplicación móvil.

---

## 🚀 Inicio Rápido

Todos los comandos de Flutter deben ejecutarse dentro de la carpeta `mobile/`:

```bash
# 1. Navegar al directorio de la app móvil
cd mobile

# 2. Descargar las dependencias
flutter pub get

# 3. Generar código de modelos (Freezed & JSON)
dart run build_runner build --delete-conflicting-outputs
```

---

## 🔍 Verificación de Código y Tests

Antes de enviar cambios o realizar un commit:

```bash
cd mobile

# Análisis estático de Dart
flutter analyze --no-pub

# Ejecución de la suite de pruebas
flutter test
```

---

## 📱 Depuración en Dispositivo Físico

### 1. Conexión Inalámbrica (ADB por Wi-Fi)
Para conectar tu teléfono Android (ej. Samsung Galaxy S23 Ultra) por Wi-Fi sin cables:

1. Asegúrate de que el teléfono y la computadora compartan la misma red Wi-Fi.
2. Identifica la IP local de tu dispositivo (ej. `192.168.1.12`).
3. Activa el modo TCP/IP y conecta ADB:
   ```bash
   adb tcpip 5555
   adb connect 192.168.1.12:5555
   ```
4. Verifica que el dispositivo aparezca reconocido:
   ```bash
   flutter devices
   ```
5. Ejecuta la app directamente en el dispositivo:
   ```bash
   flutter run -d 192.168.1.12:5555
   ```

---

## 📦 Compilación para Producción

### 🤖 Android (Google Play Store)
Para generar el archivo **Android App Bundle (AAB)** firmado:

1. Asegúrate de que tus certificados y contraseñas de firma estén en `mobile/android/key.properties`.
2. Ejecuta:
   ```bash
   cd mobile
   flutter build appbundle --release
   ```
El archivo resultante se creará en:  
`mobile/build/app/outputs/bundle/release/app-release.aab`

### 📱 Android (APK directo para pruebas)
```bash
cd mobile
flutter build apk --release
```

### 🍎 iOS (App Store)
```bash
cd mobile
flutter build ipa --release
```
