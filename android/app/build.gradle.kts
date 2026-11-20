import java.util.Properties

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

    // release 서명 키는 RN과 같은 저장소 밖 키다(D-039). 같은 키라 RN 앱 위에 덮어 설치된다(FL-034).
    // 경로는 gradle 속성 futureetp.signingProperties로 바꿀 수 있다. 파일이 없으면 release 빌드를 멈춘다:
    // debug 키로 서명된 APK를 깔면 나중에 지우고 다시 깔아야 해서 접근 키가 사라진다.
    val signingFile = file(
        findProperty("futureetp.signingProperties")
            ?: "${System.getProperty("user.home")}/.config/futureetp/android-release.properties",
    )
    val isReleaseTask = gradle.startParameter.taskNames.any { it.lowercase().contains("release") }
    signingConfigs {
        create("release") {
            // 필수 키가 비거나 파일이 없으면 release 작업만 멈춘다(debug·profile 빌드는 이 서명을 쓰지 않는다)
            val props = Properties()
            if (signingFile.exists()) signingFile.inputStream().use { props.load(it) }
            val keys = listOf("storeFile", "storePassword", "keyAlias", "keyPassword")
            val missing = keys.filter { props.getProperty(it).isNullOrBlank() }
            if (missing.isEmpty()) {
                // 상대 경로는 properties 파일 위치 기준이다(android/app 기준이 아니다)
                storeFile = signingFile.parentFile.resolve(props.getProperty("storeFile"))
                storePassword = props.getProperty("storePassword")
                keyAlias = props.getProperty("keyAlias")
                keyPassword = props.getProperty("keyPassword")
            } else if (isReleaseTask) {
                throw GradleException(
                    if (signingFile.exists()) "release signing file $signingFile is missing: ${missing.joinToString()}"
                    else "release signing file not found: $signingFile",
                )
            }
        }
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

    // release lintVital은 끈다. 이 AGP의 lint가 JDK 21 API(List.removeLast)를 불러
    // flutter jdk-dir(JDK 17)로는 plugin 모듈 분석에서 NoSuchMethodError로 멈춘다(FL-034)
    lint {
        checkReleaseBuilds = false
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // 실기기·Apple Silicon 에뮬레이터가 모두 arm64라 arm64-v8a만 넣는다(D-039 보충과 같음)
            ndk { abiFilters += "arm64-v8a" }
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
