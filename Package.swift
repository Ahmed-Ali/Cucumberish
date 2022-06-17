// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cucumberish",
    platforms: [
      .iOS(.v9), 
      .macOS(.v10_10), 
      .tvOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Cucumberish",
            targets: ["Cucumberish"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Cucumberish",
            dependencies: [],
            resources: [
              .copy("Dependencies/Gherkin/gherkin-languages.json")
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("Core/Managers"),
                .headerSearchPath("Core/Models"),
                .headerSearchPath("Dependencies/Gherkin"),
                .headerSearchPath("Utils")
            ]
        ),
        .testTarget(
            name: "CucumberishTests",
            dependencies: ["Cucumberish"]),
    ]
)
