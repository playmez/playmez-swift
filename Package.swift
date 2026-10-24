// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "PlaymezEmbed",
    platforms: [.iOS(.v14), .macOS(.v12)],
    products: [
        .library(name: "PlaymezEmbed", targets: ["PlaymezEmbed"]),
    ],
    targets: [
        .target(name: "PlaymezEmbed", path: "Sources/PlaymezEmbed"),
        .testTarget(name: "PlaymezEmbedTests", dependencies: ["PlaymezEmbed"], path: "Tests/PlaymezEmbedTests"),
    ]
)
