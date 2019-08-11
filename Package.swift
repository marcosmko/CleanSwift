// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "CleanSwift",
    products: [
        .library(
            name: "CleanSwift",
            targets: ["CleanSwift"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CleanSwift",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "CleanSwiftTests",
            dependencies: ["CleanSwift"]),
    ]
)
