// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Kevin",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: ".kevin", targets: ["Kevin"]),
        .library(name: ".kevin-Dynamic", type: .dynamic, targets: ["Kevin"])
    ],
    targets: [
        .target(name: "Kevin", resources: [.copy("Resources/Assets.xcassets")]),
        .testTarget(
            name: "KevinTests",
            dependencies: ["Kevin"])
    ]
)
