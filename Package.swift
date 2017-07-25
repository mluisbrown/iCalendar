// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "iCalendar",
    products: [
        .library(
            name: "iCalendar",
            targets: ["iCalendar"]),
    ],
    dependencies: [
        .package(url: "https://github.com/antitypical/Result.git", from: "3.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMinor(from: "1.1.0")),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.0"),
    ],
    targets: [
        .target(
            name: "iCalendar",
            dependencies: ["Result"],
            path: "Sources"),
        .testTarget(
            name: "iCalendarTests",
            dependencies: ["iCalendar", "Quick", "Nimble"]),
    ],
    swiftLanguageVersions: [3, 4]
)
