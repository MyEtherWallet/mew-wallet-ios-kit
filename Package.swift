// swift-tools-version:5.3
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
      targets: ["MEWwalletKit"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.3.8")),
    .package(url: "https://github.com/MyEtherWallet/MEW-wallet-iOS-secp256k1-package.git", from: "1.0.0"),
    .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "3.0.0")),
    .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0")),
    .package(url: "https://github.com/MyEtherWallet/bls-eth-swift.git", .upToNextMajor(from: "1.0.0")),
    .package(url: "https://github.com/attaswift/BigInt.git", from: "5.2.1"),
    .package(name: "TweetNacl", url: "https://github.com/bitmark-inc/tweetnacl-swiftwrap.git", .branch("master")) 
  ],
  targets: [
    .target(
      name: "MEWwalletKit",
        dependencies: ["CryptoSwift", "MEW-wallet-iOS-secp256k1-package", "bls-eth-swift", "TweetNacl", "BigInt"],
      path: "Sources"
    ),
    .testTarget(
      name: "MEWwalletKitTests",
      dependencies: ["MEWwalletKit", "Quick", "Nimble"],
      path: "MEWwalletKitTests/Sources"
    )
  ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)

