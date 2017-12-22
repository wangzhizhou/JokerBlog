// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "todo",
    dependencies: [
    .Package(url: "https://github.com/IBM-Swift/Kitura", majorVersion: 1, minor: 7),
    .Package(url: "https://github.com/IBM-Swift/Swift-cfenv", majorVersion: 4, minor: 0),
    .Package(url: "https://github.com/IBM-Swift/Kitura-Credentials", majorVersion: 1, minor: 7),
    .Package(url: "https://github.com/IBM-Swift/Kitura-CredentialsFacebook", majorVersion: 1, minor: 7),
    .Package(url: "https://github.com/davidungar/miniPromiseKit", majorVersion: 4, minor: 3),
    ]
)
