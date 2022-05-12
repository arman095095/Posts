// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
    .package(url: "https://github.com/arman095095/Services.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Managers.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Module.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/DesignSystem.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/AlertManager.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Selection.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Utils.git", branch: "develop"),
    .package(url: "https://github.com/nathantannar4/InputBarAccessoryView.git", .upToNextMajor(from: "5.2.0")),
    .package(url: "https://github.com/arman095095/PostsRouteMap.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/UserStoryFacade.git", branch: "develop")
]

let package = Package(
    name: "Posts",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Posts",
            targets: ["Posts"]),
    ],
    dependencies: dependencies,
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Posts",
            dependencies: [.product(name: "Services", package: "Services"),
                           .product(name: "DesignSystem", package: "DesignSystem"),
                           .product(name: "AlertManager", package: "AlertManager"),
                           .product(name: "Selection", package: "Selection"),
                           .product(name: "Managers", package: "Managers"),
                           .product(name: "Utils", package: "Utils"),
                           .product(name: "Swinject", package: "Swinject"),
                           .product(name: "InputBarAccessoryView", package: "InputBarAccessoryView"),
                           .product(name: "PostsRouteMap", package: "PostsRouteMap"),
                           .product(name: "UserStoryFacade", package: "UserStoryFacade")]),
    ]
)
