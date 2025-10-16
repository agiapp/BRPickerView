//
//  NSBundle+BRPickerView.h
//  BRPickerViewDemo
//
//  Created by renbo on 2019/10/30.
//  Copyright © 2019 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (BRPickerView)

/// 获取 BRPickerView 的资源包单例
+ (instancetype)br_pickerBundle;

/// 获取本地化字符串（简化版本）
/// @param key 本地化字符串的键（即 Localizable.strings 文件中 key-value 中的 key）
/// @param language 目标语言代码，如果为 nil 则使用系统首选语言
/// @return 返回对应语言的本地化字符串，如果找不到则返回空字符串
+ (NSString *)br_localizedStringForKey:(NSString *)key language:(nullable NSString *)language;

@end

NS_ASSUME_NONNULL_END
