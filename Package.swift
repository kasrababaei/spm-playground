// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "spmp",
  platforms: [.macOS(.v15)],
  products: [
    .executable(name: "spm-playground", targets: ["SwiftPackageManagerPlayground"])
  ],
  dependencies: [],
  targets: [
    .executableTarget(
        name: "SwiftPackageManagerPlayground",
        swiftSettings: [
            .unsafeFlags([
                "-Xfrontend",
                "-warn-long-function-bodies=150",
                "-Xfrontend",
                "-warn-long-expression-type-checking=150",
            ])//, .when(configuration: .debug)),
        ]
    ),
    .testTarget(name: "SwiftPackageManagerPlayground-Tests", dependencies: ["SwiftPackageManagerPlayground"])
  ]
)
