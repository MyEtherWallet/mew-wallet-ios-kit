// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MEWwalletKit",
  platforms: [
      .iOS(.v11)
  ],
  products: [
    .library(
      name: "MEWwalletKit",
      type: .dynamic,
      targets: ["MEWwalletKit"]
    )
  ],
  dependencies: [
    .package(url: "git@github.com:MyEtherWallet/MEW-wallet-iOS-CryptoSwift.git", .branch("feature/spm-dynamic")),
    .package(url: "git@github.com:MyEtherWallet/MEW-wallet-iOS-secp256k1-package.git", from: "1.0.0"),
    .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "2.0.0")),
    .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "8.0.0"))
  ],
  targets: [
    .target(
      name: "MEWwalletKit",
      dependencies: ["CryptoSwift", "MEW-wallet-iOS-secp256k1-package"],
      path: "Sources"
    ),
    .testTarget(
      name: "MEWwalletKitTests",
      dependencies: ["MEWwalletKit", "Quick", "Nimble"],
      path: "MEWwalletKitTests/Sources"
    )
  ]
)
