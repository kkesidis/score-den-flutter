allprojects {
    repositories {
        google()
        mavenCentral()
    }

    subprojects {
        // 1. Instantly inject the namespace the millisecond the plugin hits to stop the VariantBuilder crash
        pluginManager.withPlugin("com.android.library") {
            extensions.configure<com.android.build.api.dsl.LibraryExtension> {
                if (project.name == "isar_flutter_libs" && namespace == null) {
                    namespace = "dev.isar.isar_flutter_libs"
                }
            }
        }

        // 2. Force the compileSdk upgrade immediately after the library configurations load
        afterEvaluate {
            if (plugins.hasPlugin("com.android.library")) {
                extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                    compileSdk = 34
                }
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
