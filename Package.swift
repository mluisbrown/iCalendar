import PackageDescription

let package = Package(
    name: "iCalendar"
    dependencies: {
        var deps: [Package.Dependency] = [
            .Package(url: "https://github.com/antitypical/Result.git", versions: Version(3, 2, 3)..<Version(3, .max, .max)),
        ]
        if isSwiftPackagerManagerTest {
            deps += [
                .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1, minor: 1),
                .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 7),
            ]
        }
        return deps
    }(),
    swiftLanguageVersions: [3, 4]
)
