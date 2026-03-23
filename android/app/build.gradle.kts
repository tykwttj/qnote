plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Decode dart-defines passed by Flutter and expose as a map.
val dartDefines: Map<String, String> = (project.properties["dart-defines"] as? String)
    ?.split(",")
    ?.associate { encoded ->
        val decoded = String(java.util.Base64.getDecoder().decode(encoded))
        val (key, value) = decoded.split("=", limit = 2)
        key to value
    } ?: emptyMap()

// Load key.properties for release signing (if available)
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = java.util.Properties()
if (keyPropertiesFile.exists()) {
    keyProperties.load(java.io.FileInputStream(keyPropertiesFile))
}

android {
    namespace = "com.qnote.qnote"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.qnote.qnote"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Inject AdMob App ID into AndroidManifest.xml
        manifestPlaceholders["admobAppId"] =
            dartDefines["ADMOB_APP_ID_ANDROID"] ?: "ca-app-pub-3940256099942544~3347511713"
    }

    signingConfigs {
        if (keyPropertiesFile.exists()) {
            create("release") {
                keyAlias = keyProperties["keyAlias"] as String
                keyPassword = keyProperties["keyPassword"] as String
                storeFile = file(keyProperties["storeFile"] as String)
                storePassword = keyProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keyPropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
