plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    
    // ENSURE this line is present, without a version:
    id("com.google.gms.google-services") 
}

android {
    namespace = "com.lawadvisor.lawyer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.lawadvisor.lawyer"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
// Add this block at the very end of android/app/build.gradle.kts

dependencies {
    // Original Dependencies
    implementation("com.pusher:pusher-java-client:2.2.8")
    implementation("com.google.android.material:material:1.2.0-alpha02")

    // Firebase BOM (Best Practice)
    implementation(platform("com.google.firebase:firebase-bom:33.5.1"))
    
    // List all Firebase dependencies WITHOUT versions
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-analytics")

    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    // Errorprone annotation fix (optional but good for a modern project)
    implementation("com.google.errorprone:error_prone_annotations:2.20.0")
}