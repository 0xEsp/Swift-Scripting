// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FileTransform",
    platforms: [
        .macOS(.v12),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", from: "0.5.2"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.2"),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.7"),
    ],
    targets: [
        .executableTarget(
            name: "parser",
            dependencies: [
                .product(name: "SwiftToolsSupport", package: "swift-tools-support-core"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "AnyCodable", package: "AnyCodable"),
            ],
            path: "Sources/Script"
        ),
    ]
)
