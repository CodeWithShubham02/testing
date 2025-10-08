//ext.kotlin_version = '1.9.0' // or similar
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    layout.buildDirectory.set(newSubprojectBuildDir)

    evaluationDependsOn(":app")
}
tasks.named<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// build.gradle.kts (Project-level)
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
        classpath("com.google.gms:google-services:4.4.3")
        classpath("com.android.tools.build:gradle:8.1.0")
    }
}