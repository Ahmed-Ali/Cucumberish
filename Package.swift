// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cucumberish",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Cucumberish",
            targets: ["Cucumberish"]),
    ],
    dependencies: [],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Cucumberish",
            path: "Sources",
            exclude: ["Dependencies/Gherkin/gherkin-languages.json"],
            sources: ["Cucumberish", "Dependencies", "Utils"],
            resources: [
                        .process("Dependencies/Gherkin/gherkin-languages.json")],
            publicHeadersPath: "Sources/Cucumberish"
        )
    ]
)
