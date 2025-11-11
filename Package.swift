// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TycoSwift",
    products: [
        .library(
            name: "TycoSwift",
            targets: ["TycoSwift"]
        ),
    ],
    targets: [
        .target(
            name: "CTyco",
            publicHeadersPath: "include",
            cSettings: [
                .unsafeFlags(["-I../tyco-c/include"])
            ],
            linkerSettings: [
                .unsafeFlags(["-L../tyco-c/build", "-ltyco_c"])
            ]
        ),
        .target(
            name: "TycoSwift",
            dependencies: ["CTyco"]
        ),
        .testTarget(
            name: "TycoSwiftTests",
            dependencies: ["TycoSwift"]
        ),
    ]
)
