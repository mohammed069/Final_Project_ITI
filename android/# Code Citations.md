# Code Citations

## License: BSD_3_Clause
https://github.com/fluttercommunity/flutter_downloader/tree/9260ff5a32b482c46d5f762794d1eb2df4d63af9/example/android/build.gradle

```
{
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = "../build"
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(":app")
}
```


## License: unknown
https://github.com/x-syaifullah-x/flutter-started-project/tree/88762a4051840ca0ac1171928a1d89314020322b/android/build.gradle

```
"../build"
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
```

