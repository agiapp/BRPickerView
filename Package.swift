// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    // 指定包的名称
    name: "BRPickerView",
    // 该库的一些配置
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BRPickerView",
            targets: ["BRPickerView"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BRPickerView",
            path: "BRPickerView",
            // 指定该库包含的资源文件
            resources: [
                .process("Base/BRPickerView.bundle"),
                .process("AddressPickerView/BRAddressPickerView.bundle"), 
                .copy("PrivacyInfo.xcprivacy")
            ],
            // 指定公共头文件的路径。在这里，它设置为当前目录（"."）
            publicHeadersPath: ".",
            // 为C语言源代码指定一些设置
            cSettings: [
                //Config header path
                .headerSearchPath("."),
            ]
        ),
    ]
)
