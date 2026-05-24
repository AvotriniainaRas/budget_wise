plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.avotriniaina.budget_wise"  // ← changer
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.avotriniaina.budget_wise"  // ← changer
        minSdk = flutter.minSdkVersion                          // ← changer (explicite)
        targetSdk = flutter.targetSdkVersion
        versionCode = 1                      // ← changer
        versionName = "1.0.0"               // ← changer
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
