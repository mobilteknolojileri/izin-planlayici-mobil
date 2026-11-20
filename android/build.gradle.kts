allprojects {
    repositories {
        google()
        mavenCentral()
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
// The NDK lives inside the project (.tooling/ndk/<version>) so the
// machine-wide SDK stays untouched. CI has no .tooling folder and uses the
// runner's SDK as usual.
val projectNdk: File? =
    rootProject.file("../.tooling/ndk").listFiles()?.singleOrNull { it.isDirectory }
subprojects {
    if (projectNdk == null) return@subprojects

    // Flutter's Gradle plugin installs a missing NDK into the global SDK with
    // sdkmanager. Without the sdkmanager path it leaves the NDK to AGP, which
    // honours ndkPath below.
    extra.set("flutter.sdkManagerPath", null)

    // Every Android module needs ndkPath, including Flutter plugins with
    // native code such as :jni, because AGP otherwise downloads a missing NDK
    // into the global SDK.
    listOf("com.android.application", "com.android.library").forEach { pluginId ->
        pluginManager.withPlugin(pluginId) {
            extensions.getByName("android").withGroovyBuilder {
                "setNdkPath"(projectNdk.absolutePath)
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
