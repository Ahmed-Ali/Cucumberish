// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cucumberish",
    platforms: [.iOS(.v9) , .tvOS(.v9), .macOS(.v10_10) ],
    products: [
        
        .library(
            name: "Cucumberish",
            targets: ["Cucumberish"]),
    ],
    dependencies: [
     
    ],
    targets: [
        .target(
            name: "Cucumberish",
            path: "Cucumberish" ,
            exclude:["Dependencies/Gherkin/gherkin-languages.json"],
            resources:[
                .process("Resources")
            ],
            publicHeadersPath: "PublicHeader",
            cSettings: [
                .headerSearchPath("./Core"),
                .headerSearchPath("./Core/Managers"),
                .headerSearchPath("./Core/Models"),
                .headerSearchPath("./Utils"),
                .headerSearchPath("./Dependencies/Gherkin"),
            ]
        ),
    ]
)
