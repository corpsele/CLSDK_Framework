// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CLSDK_Framework",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CLSDK_Framework",
            targets: ["CLSDK_Framework"]
        ),
        .library(name: "CLSDK_Framework-Static", type: .static, targets: ["CLSDK_Framework"]),
        .library(name: "CLSDK_Framework-Dynamic", type: .dynamic, targets: ["CLSDK_Framework"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CLSDK_Framework",
            path: "Sources"
        ),
        .testTarget(
            name: "CLSDK_FrameworkTests",
            dependencies: ["CLSDK_Framework"]
        ),
    ]
)
