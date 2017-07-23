import Foundation
import PackageDescription

let package = Package(
    name: "iCalendar",
    dependencies: [
        .Package(url: "https://github.com/antitypical/Result.git", versions: Version(3, 2, 3)..<Version(3, .max, .max)),
        .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 7)
    ],
    swiftLanguageVersions: [3, 4]
)
