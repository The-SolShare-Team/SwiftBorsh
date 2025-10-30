// swift-tools-version: 6.2

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "SwiftBorsh",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "SwiftBorsh",
            targets: ["SwiftBorsh"]
        ),
        .library(name: "Base58", targets: ["Base58"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0")
    ],
    targets: [
        .macro(
            name: "SwiftBorshMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]),
        .target(
            name: "ByteBuffer",
            exclude: ["LICENSE.txt"]),
        .target(name: "Base58"),
        .testTarget(name: "Base58Tests", dependencies: ["Base58"]),
        .target(
            name: "SwiftBorsh",
            dependencies: ["ByteBuffer", "SwiftBorshMacros", "Base58"]
        ),
        .testTarget(
            name: "SwiftBorshTests",
            dependencies: ["SwiftBorsh"]
        ),
    ]
)
