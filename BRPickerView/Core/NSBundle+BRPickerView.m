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
+ (instancetype)br_pickerBundle {
    static NSBundle *pickerBundle = nil;
    if (!pickerBundle) {
        // 获取 BRPickerView.bundle
        NSBundle *bundle = [NSBundle bundleForClass:[BRPickerAlertView class]];
        NSString *bundlePath = [bundle pathForResource:@"BRPickerView" ofType:@"bundle"];
        pickerBundle = [NSBundle bundleWithPath:bundlePath];
    }
    return pickerBundle;
}

#pragma mark - 获取国际化后的文本
+ (NSString *)br_localizedStringForKey:(NSString *)key language:(NSString *)language {
    return [self br_localizedStringForKey:key value:nil language:language];
}

+ (NSString *)br_localizedStringForKey:(NSString *)key value:(NSString *)value language:(NSString *)language {
    static NSBundle *bundle = nil;
    if (!bundle) {
        // 如果没有手动设置语言，将随系统的语言自动改变
        if (!language) {
            // 系统首选语言
            language = [NSLocale preferredLanguages].firstObject;
        }
        
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant、zh-HK、zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        // 从 BRPickerView.bundle 中查找资源
        bundle = [NSBundle bundleWithPath:[[self br_pickerBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

@end
