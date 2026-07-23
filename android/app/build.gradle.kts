import java.io.FileInputStream
import java.io.FileOutputStream
import java.util.Properties
import java.util.zip.CRC32
import java.util.zip.ZipEntry
import java.util.zip.ZipFile
import java.util.zip.ZipOutputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.isFile) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
        localProperties.load(reader)
    }
}

val googleMapsApiKey =
    localProperties.getProperty("GOOGLE_MAPS_API_KEY")
        ?: System.getenv("GOOGLE_MAPS_API_KEY")
        ?: ""

fun rewriteArchiveWithNativeLibs(
    sourceArchive: File,
    nativeLibDir: File,
    targetArchive: File,
    archiveRoot: String,
) {
    if (!sourceArchive.isFile) return

    val tempArchive = File(targetArchive.parentFile, "${targetArchive.name}.tmp")
    targetArchive.parentFile.mkdirs()
    val archivePrefix = if (archiveRoot.isBlank()) "" else "$archiveRoot/"
    val libPrefix = "${archivePrefix}lib/"

    ZipFile(sourceArchive).use { zipFile ->
        ZipOutputStream(FileOutputStream(tempArchive)).use { zout ->
            zipFile.entries().asSequence().forEach { entry ->
                val name = entry.name
                val isSignatureFile =
                    name.startsWith("META-INF/") &&
                        (name.endsWith(".RSA") ||
                            name.endsWith(".SF") ||
                            name.endsWith(".DSA") ||
                            name.endsWith(".MF"))

                if (name.isNotBlank() && !name.startsWith(libPrefix) && !isSignatureFile) {
                    val outEntry = ZipEntry(name).apply { time = entry.time }
                    if (entry.method == ZipEntry.STORED) {
                        outEntry.setMethod(ZipEntry.STORED)
                        outEntry.setSize(entry.size)
                        outEntry.setCompressedSize(entry.compressedSize)
                        outEntry.setCrc(entry.crc)
                    }
                    zout.putNextEntry(outEntry)
                    zipFile.getInputStream(entry).use { input -> input.copyTo(zout) }
                    zout.closeEntry()
                }
            }

            nativeLibDir.walkTopDown()
                .filter { it.isFile }
                .sortedBy { it.relativeTo(nativeLibDir).invariantSeparatorsPath }
                .forEach { libFile ->
                    val relativePath = libFile.relativeTo(nativeLibDir).invariantSeparatorsPath
                    val bytes = libFile.readBytes()
                    val crc32 = CRC32().apply { update(bytes) }.value
                    val outEntry = ZipEntry("${libPrefix}$relativePath").apply {
                        setMethod(ZipEntry.STORED)
                        setSize(bytes.size.toLong())
                        setCompressedSize(bytes.size.toLong())
                        setCrc(crc32)
                        time = libFile.lastModified()
                    }
                    zout.putNextEntry(outEntry)
                    zout.write(bytes)
                    zout.closeEntry()
                }
        }
    }

    tempArchive.copyTo(targetArchive, overwrite = true)
    tempArchive.delete()
}

fun resolveAndroidSdkDir(localProperties: Properties): File {
    val sdkDirPath =
        localProperties.getProperty("sdk.dir")
            ?: System.getenv("ANDROID_SDK_ROOT")
            ?: System.getenv("ANDROID_HOME")
            ?: error("No se pudo resolver el Android SDK. Revisa local.properties o ANDROID_SDK_ROOT.")
    return File(sdkDirPath)
}

fun resolveBuildToolsDir(sdkDir: File): File {
    val buildToolsRoot = File(sdkDir, "build-tools")
    return buildToolsRoot
        .listFiles()
        ?.filter { it.isDirectory }
        ?.maxByOrNull { it.name }
        ?: error("No se encontro ninguna version de build-tools en: ${buildToolsRoot.absolutePath}")
}

fun resolveNdkToolchainBinDir(sdkDir: File, ndkVersion: String): File {
    val hostTag =
        when {
            System.getProperty("os.name").contains("Mac", ignoreCase = true) -> "darwin-x86_64"
            System.getProperty("os.name").contains("Windows", ignoreCase = true) -> "windows-x86_64"
            else -> "linux-x86_64"
        }
    val toolchainDir = File(sdkDir, "ndk/$ndkVersion/toolchains/llvm/prebuilt/$hostTag/bin")
    require(toolchainDir.isDirectory) {
        "No se encontro el toolchain del NDK en: ${toolchainDir.absolutePath}"
    }
    return toolchainDir
}

fun prepareNativeLibsForPackaging(
    project: Project,
    sdkDir: File,
    ndkVersion: String,
    sourceDir: File,
    targetDir: File,
) {
    require(sourceDir.isDirectory) {
        "No se encontro el directorio de libs nativas en: ${sourceDir.absolutePath}"
    }

    val toolchainBinDir = resolveNdkToolchainBinDir(sdkDir, ndkVersion)
    val objcopyBinary = File(toolchainBinDir, "llvm-objcopy")
    require(objcopyBinary.isFile) {
        "No se encontro llvm-objcopy en: ${objcopyBinary.absolutePath}"
    }

    if (targetDir.exists()) targetDir.deleteRecursively()
    targetDir.mkdirs()

    sourceDir.walkTopDown()
        .filter { it.isFile }
        .sortedBy { it.relativeTo(sourceDir).invariantSeparatorsPath }
        .forEach { libFile ->
            val outputFile = File(targetDir, libFile.relativeTo(sourceDir).invariantSeparatorsPath)
            outputFile.parentFile.mkdirs()
            libFile.copyTo(outputFile, overwrite = true)

            if (outputFile.extension == "so") {
                project.exec {
                    commandLine(
                        objcopyBinary.absolutePath,
                        "--strip-unneeded",
                        outputFile.absolutePath,
                    )
                }
            }
        }
}

android {
    namespace = "com.example.flutter_application_manachyna_kusa_2_0"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_application_manachyna_kusa_2_0"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true
        manifestPlaceholders["googleMapsApiKey"] = googleMapsApiKey
    }

    signingConfigs {
        create("release") {
            val storeFilePath = keystoreProperties["storeFile"] as String?
            if (storeFilePath != null) {
                storeFile = file(storeFilePath)
                storePassword = keystoreProperties["storePassword"] as String?
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
            }
        }
    }

    buildTypes {
        debug {
            manifestPlaceholders["usesCleartextTraffic"] = "true"
        }
        release {
            signingConfig = if (keystorePropertiesFile.isFile) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

val repairDebugApk = tasks.register("repairDebugApk") {
    dependsOn("assembleDebug")

    doLast {
        val debugApk = File(buildDir, "outputs/apk/debug/app-debug.apk")
        val nativeLibDir = File(
            buildDir,
            "intermediates/merged_native_libs/debug/mergeDebugNativeLibs/out/lib",
        )
        val preparedNativeLibDir = File(buildDir, "tmp/debug-apk-repair/stripped-lib")
        val flutterOutputApk = File(
            rootProject.projectDir.parentFile,
            "build/app/outputs/flutter-apk/app-debug.apk",
        )
        val sdkDir = resolveAndroidSdkDir(localProperties)
        val buildToolsDir = resolveBuildToolsDir(sdkDir)
        val debugSigningConfig = android.signingConfigs.getByName("debug")
        val keystorePath =
            debugSigningConfig.storeFile?.absolutePath
                ?: File(System.getProperty("user.home"), ".android/debug.keystore").absolutePath
        val storePassword = debugSigningConfig.storePassword ?: "android"
        val keyAlias = debugSigningConfig.keyAlias ?: "androiddebugkey"
        val keyPassword = debugSigningConfig.keyPassword ?: "android"

        prepareNativeLibsForPackaging(
            project = project,
            sdkDir = sdkDir,
            ndkVersion = android.ndkVersion,
            sourceDir = nativeLibDir,
            targetDir = preparedNativeLibDir,
        )

        val rewrittenApk = File(buildDir, "tmp/debug-apk-repair/app-debug.apk").apply {
            parentFile.mkdirs()
        }
        rewriteArchiveWithNativeLibs(
            sourceArchive = debugApk,
            nativeLibDir = preparedNativeLibDir,
            targetArchive = rewrittenApk,
            archiveRoot = "",
        )

        val alignedApk = File(buildDir, "tmp/debug-apk-repair/app-debug-aligned.apk")
        project.exec {
            environment("JAVA_HOME", System.getProperty("java.home"))
            commandLine(
                File(buildToolsDir, "zipalign").absolutePath,
                "-f",
                "4",
                rewrittenApk.absolutePath,
                alignedApk.absolutePath,
            )
        }

        val signedApk = File(buildDir, "tmp/debug-apk-repair/app-debug-signed.apk")
        project.exec {
            environment("JAVA_HOME", System.getProperty("java.home"))
            commandLine(
                File(buildToolsDir, "apksigner").absolutePath,
                "sign",
                "--ks",
                keystorePath,
                "--ks-key-alias",
                keyAlias,
                "--ks-pass",
                "pass:$storePassword",
                "--key-pass",
                "pass:$keyPassword",
                "--out",
                signedApk.absolutePath,
                alignedApk.absolutePath,
            )
        }

        signedApk.copyTo(debugApk, overwrite = true)
        flutterOutputApk.parentFile.mkdirs()
        signedApk.copyTo(flutterOutputApk, overwrite = true)
    }
}

val repairReleaseApk = tasks.register("repairReleaseApk") {
    dependsOn("assembleRelease")

    doLast {
        val releaseApk = File(buildDir, "outputs/apk/release/app-release.apk")
        val nativeLibDir = File(
            buildDir,
            "intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib",
        )
        val preparedNativeLibDir = File(buildDir, "tmp/release-apk-repair/stripped-lib")
        val flutterOutputApk = File(
            rootProject.projectDir.parentFile,
            "build/app/outputs/flutter-apk/app-release.apk",
        )
        val sdkDir = resolveAndroidSdkDir(localProperties)
        val buildToolsDir = resolveBuildToolsDir(sdkDir)

        prepareNativeLibsForPackaging(
            project = project,
            sdkDir = sdkDir,
            ndkVersion = android.ndkVersion,
            sourceDir = nativeLibDir,
            targetDir = preparedNativeLibDir,
        )

        val rewrittenApk = File(buildDir, "tmp/release-apk-repair/app-release.apk").apply {
            parentFile.mkdirs()
        }
        rewriteArchiveWithNativeLibs(
            sourceArchive = releaseApk,
            nativeLibDir = preparedNativeLibDir,
            targetArchive = rewrittenApk,
            archiveRoot = "",
        )

        val alignedApk = File(buildDir, "tmp/release-apk-repair/app-release-aligned.apk")
        project.exec {
            environment("JAVA_HOME", System.getProperty("java.home"))
            commandLine(
                File(buildToolsDir, "zipalign").absolutePath,
                "-f",
                "4",
                rewrittenApk.absolutePath,
                alignedApk.absolutePath,
            )
        }

        val debugSigningConfig = android.signingConfigs.getByName("debug")
        val keystorePath =
            debugSigningConfig.storeFile?.absolutePath
                ?: File(System.getProperty("user.home"), ".android/debug.keystore").absolutePath
        val storePassword = debugSigningConfig.storePassword ?: "android"
        val keyAliasKeystore = debugSigningConfig.keyAlias ?: "androiddebugkey"
        val keyPassword = debugSigningConfig.keyPassword ?: "android"

        val signedApk = File(buildDir, "tmp/release-apk-repair/app-release-signed.apk")
        project.exec {
            environment("JAVA_HOME", System.getProperty("java.home"))
            commandLine(
                File(buildToolsDir, "apksigner").absolutePath,
                "sign",
                "--ks",
                keystorePath,
                "--ks-key-alias",
                keyAliasKeystore,
                "--ks-pass",
                "pass:$storePassword",
                "--key-pass",
                "pass:$keyPassword",
                "--out",
                signedApk.absolutePath,
                alignedApk.absolutePath,
            )
        }

        signedApk.copyTo(releaseApk, overwrite = true)
        flutterOutputApk.parentFile.mkdirs()
        signedApk.copyTo(flutterOutputApk, overwrite = true)
    }
}

afterEvaluate {
    tasks.matching { it.name == "assembleDebug" }.configureEach {
        finalizedBy(repairDebugApk)
    }
    tasks.matching { it.name == "assembleRelease" }.configureEach {
        finalizedBy(repairReleaseApk)
    }
}
