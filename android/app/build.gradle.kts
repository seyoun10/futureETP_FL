plugins {
    id("com.android.application")
    // FCM(D-037). android/app/google-services.json이 있어야 빌드된다(RN apps/mobile과 같은 파일, FL-032)
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "io.github.seyoon.futureetp"
    // flutter_local_notifications 23이 37 이상을 요구한다(Flutter 기본 36)
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // flutter_local_notifications가 요구한다
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // 앱 ID는 RN과 같다(FL-002). dev 변형은 아래 productFlavors에서 .dev를 붙인다.
        applicationId = "io.github.seyoon.futureetp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 변형(D-043, FL-002). 실행: flutter run --flavor dev --dart-define-from-file=env/dev.json
    flavorDimensions += "variant"
    productFlavors {
        create("dev") {
            dimension = "variant"
            applicationIdSuffix = ".dev"
            manifestPlaceholders["appName"] = "futureETP Dev"
        }
        create("prod") {
            dimension = "variant"
            manifestPlaceholders["appName"] = "futureETP"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
