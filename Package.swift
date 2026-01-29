// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MakeHomerProudTimerClient",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "MakeHomerProudTimerClient",
            path: "Sources"
        ),
    ]
)
