//
//  NSBundle+BRPickerView.h
//  BRPickerViewDemo
//
//  Created by renbo on 2019/10/30.
//  Copyright © 2019 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (BRPickerView)

/// 获取 BRPickerView.bundle
+ (instancetype)br_pickerBundle;

/// 获取国际化后的文本
/// @param key 代表 Localizable.strings 文件中 key-value 中的 key。
/// @param language 设置语言（可为空，为nil时将随系统的语言自动改变）
+ (NSString *)br_localizedStringForKey:(NSString *)key language:(NSString *)language;

@end

NS_ASSUME_NONNULL_END
