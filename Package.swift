// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KoolingSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "KoolingSDK",
            targets: ["KoolingSDK"]),
        .library(
            name: "Alamofire",
            targets: ["Alamofire"]),
    ],
    targets: [
        // Binary targets for the prebuilt frameworks
        .binaryTarget(
            name: "KoolingSDK",
            path: "./Sources/KoolingSDK.xcframework"),
        .binaryTarget(
            name: "Alamofire",
            path: "./Sources/Alamofire.xcframework"),
        .target(
            name: "KoolingSDKWrapper",
            dependencies: []),
    ]
)
