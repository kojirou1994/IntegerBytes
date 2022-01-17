// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "IntegerBytes",
  products: [
    .library(name: "IntegerBytes", targets: ["IntegerBytes"]),
  ],
  dependencies: [
    .package(url: "https://github.com/kojirou1994/Endianness.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "IntegerBytes",
      dependencies: [
        .product(name: "Endianness", package: "Endianness"),
      ]),
    .testTarget(
      name: "IntegerBytesTests",
      dependencies: ["IntegerBytes"]),
  ]
)
