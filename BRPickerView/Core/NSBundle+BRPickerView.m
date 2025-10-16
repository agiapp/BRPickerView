//
//  NSBundle+BRPickerView.m
//  BRPickerViewDemo
//
//  Created by renbo on 2019/10/30.
//  Copyright © 2019 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import "NSBundle+BRPickerView.h"
#import "BRPickerAlertView.h"

BRSYNTH_DUMMY_CLASS(NSBundle_BRPickerView)

@implementation NSBundle (BRPickerView)

#pragma mark - 获取 BRPickerView.bundle
/// 获取 BRPickerView 的资源包单例
/// @discussion 该方法使用 dispatch_once 确保线程安全，首次调用时会查找并加载 BRPickerView.bundle
/// @return 返回 BRPickerView.bundle 的 NSBundle 实例，如果找不到则返回主 bundle
+ (instancetype)br_pickerBundle {
    static NSBundle *pickerBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 使用 BRPickerAlertView 类来定位 bundle
        
        // 注意：不同的包管理器有不同的资源路径结构，所以需要条件编译来适配。
        // 1.CocoaPods：资源在 Pods/BRPickerView/ 目录下
        // 2.SPM：资源在 .build/checkouts/BRPickerView/ 或其他特定目录
        // 3.手动集成：资源在项目目录中
#ifdef SWIFT_PACKAGE
        // 方式1: Swift Package Manager
        NSBundle *bundle = SWIFTPM_MODULE_BUNDLE; // SPM 提供的特殊宏，指向 SPM 包中的正确资源路径
#else
        // 方式2: CocoaPods 或手动集成
        NSBundle *bundle = [NSBundle bundleForClass:[BRPickerAlertView class]];
#endif
        // 在 bundle 中查找 BRPickerView.bundle
        NSString *bundlePath = [bundle pathForResource:@"BRPickerView" ofType:@"bundle"];
        if (bundlePath) {
            pickerBundle = [NSBundle bundleWithPath:bundlePath];
        }
        
        // 如果找不到 BRPickerView.bundle，回退到主 bundle
        if (!pickerBundle) {
            pickerBundle = bundle;
            NSLog(@"⚠️ BRPickerView.bundle not found, using main bundle instead");
        }
    });
    return pickerBundle;
}

#pragma mark - 国际化文本处理
/// 获取本地化字符串（简化版本）
/// @param key 本地化字符串的键（即 Localizable.strings 文件中 key-value 中的 key）
/// @param language 目标语言代码，如果为 nil 则使用系统首选语言
/// @return 返回对应语言的本地化字符串，如果找不到则返回空字符串
+ (NSString *)br_localizedStringForKey:(NSString *)key language:(NSString *)language {
    return [self br_localizedStringForKey:key value:nil language:language];
}

/// 获取本地化字符串（完整版本）
/// @param key 本地化字符串的键（即 Localizable.strings 文件中 key-value 中的 key）
/// @param value 默认值，当找不到对应键时的返回值
/// @param language 目标语言代码，如果为 nil 则使用系统首选语言
/// @return 返回对应语言的本地化字符串，如果找不到则返回默认值或空字符串
+ (NSString *)br_localizedStringForKey:(NSString *)key value:(NSString *)value language:(NSString *)language {
    // 参数安全检查
    if (!key || key.length == 0) return @"";
    
    // 确定使用哪种语言
    NSString *preferredLanguage = language ?: [NSLocale preferredLanguages].firstObject;
    NSString *standardizedLanguage = [self standardizeLanguageCode:preferredLanguage];
    
    // 获取对应语言的 bundle
    NSBundle *languageBundle = [self bundleForLanguage:standardizedLanguage];
    
    // 从语言包中获取本地化字符串
    NSString *localizedString = [languageBundle localizedStringForKey:key value:value table:nil];
    
    // 检查是否需要回退到主 bundle
    BOOL needsFallback = !localizedString ||
                        [localizedString isEqualToString:value] ||
                        localizedString.length == 0;
    if (needsFallback) {
        // 回退到主 bundle 的本地化
        localizedString = [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
    }

    
    // 如果 BRPickerView 包中没有找到，或者值与传入的 value 相同，尝试从主包查找
    if (!localizedString || [localizedString isEqualToString:value] || localizedString.length == 0) {
        // 回退到主包的本地化
        localizedString = [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
    }
    
    return localizedString ?: (value ?: @"");
}

#pragma mark - 语言代码标准化
/// 标准化语言代码
/// @discussion 将各种语言代码格式统一为标准格式，支持中英文检测
/// @param languageCode 原始语言代码
/// @return 返回标准化后的语言代码
+ (NSString *)standardizeLanguageCode:(NSString *)languageCode {
    if (!languageCode || languageCode.length == 0) {
        return @"en"; // 默认英文
    }
    
    NSString *lowercaseCode = [languageCode lowercaseString]; // 转小写
    NSString *uppercaseCode = [languageCode uppercaseString]; // 转大写
    
    // 英文检测
    if ([lowercaseCode hasPrefix:@"en"]) {
        return @"en";
    }
    // 中文检测
    if ([lowercaseCode hasPrefix:@"zh"]) {
        // 简体中文检测
        if ([uppercaseCode containsString:@"HANS"] ||
            [uppercaseCode containsString:@"CN"] ||
            [languageCode isEqualToString:@"zh_CN"] ||
            [lowercaseCode isEqualToString:@"zh"] ||
            [uppercaseCode containsString:@"SIMPLIFIED"]) {
            return @"zh-Hans"; // 简体中文
        }
        
        // 繁体中文检测
        if ([uppercaseCode containsString:@"HANT"] ||
            [uppercaseCode containsString:@"TW"] ||
            [uppercaseCode containsString:@"HK"] ||
            [uppercaseCode containsString:@"MO"] ||
            [uppercaseCode containsString:@"TRADITIONAL"]) {
            return @"zh-Hant"; // 繁体中文
        }
        
        // 默认简体中文
        return @"zh-Hans";
    }
    
    // 可以在这里添加更多语言支持
    // 例如：日语、韩语、法语等
    
    return @"en"; // 默认回退到英文
}

#pragma mark - 语言包管理
/// 获取指定语言的 bundle
/// @param language 目标语言代码
/// @return 返回对应语言的 lproj bundle，如果找不到则返回默认的英文 bundle
+ (NSBundle *)bundleForLanguage:(NSString *)language {
    if (!language || language.length == 0) {
        language = @"en"; // 默认语言
    }
    
    NSBundle *pickerBundle = [self br_pickerBundle];
    
    // 1. 首先尝试精确匹配语言包
    NSString *path = [pickerBundle pathForResource:language ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:path];
    
    if (languageBundle) {
        return languageBundle;
    }
    
    // 2. 语言回退机制
    NSString *fallbackLanguage = nil;
    if ([language isEqualToString:@"zh-Hant"]) {
        // 繁体中文回退到简体中文
        fallbackLanguage = @"zh-Hans";
    } else if ([language hasPrefix:@"zh"]) {
        // 其他中文变体回退到简体中文
        fallbackLanguage = @"zh-Hans";
    } else {
        // 其他语言回退到英文
        fallbackLanguage = @"en";
    }
    
    if (fallbackLanguage) {
        path = [pickerBundle pathForResource:fallbackLanguage ofType:@"lproj"];
        languageBundle = [NSBundle bundleWithPath:path];
        if (languageBundle) {
            return languageBundle;
        }
    }
    
    // 3. 最终回退到 picker bundle 本身
    return pickerBundle;
}

@end
