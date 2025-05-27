// swift-tools-version: 5.9
// 声明构建此包所需的最低 Swift 版本

import PackageDescription

let package = Package(
    // 指定包的名称
    name: "BRPickerView",
    // 设置默认本地化为英语，用于处理本地化资源
    defaultLocalization: "en",
    // 该库的一些配置
    products: [
        // 定义包生成的库，使其可以被其他包或项目引用
        .library(
            name: "BRPickerView",
            targets: ["BRPickerView"]
        ),
    ],
    targets: [
        // 定义目标模块，指定源代码和资源的组织方式
        .target(
            name: "BRPickerView",
            path: "BRPickerView",
            // 排除 Deprecated 目录及其下的所有文件，这些文件仅用于 CocoaPods 集成
            exclude: ["Deprecated"],
            // 指定该库包含的资源文件，包括 bundle 和隐私清单
            resources: [
                .process("Core/BRPickerView.bundle"),  // 处理并打包 bundle 资源
                .copy("PrivacyInfo.xcprivacy")        // 复制隐私清单文件
            ],
            // 指定公共头文件的路径
            publicHeadersPath: "include",
            // 为C语言源代码指定一些设置
            cSettings: [
                // 配置头文件搜索路径，使编译器能够找到所需的头文件
                .headerSearchPath(".")
            ]
        )
    ]
)
