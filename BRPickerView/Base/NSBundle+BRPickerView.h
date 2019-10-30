//
//  NSBundle+BRPickerView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2019/10/30.
//  Copyright © 2019 91renb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (BRPickerView)
+ (instancetype)br_pickerBundle;
+ (NSArray *)br_addressJsonArray;
+ (NSString *)br_localizedStringForKey:(NSString *)key value:(nullable NSString *)value language:(NSString *)language;
+ (NSString *)br_localizedStringForKey:(NSString *)key language:(NSString *)language;

@end

NS_ASSUME_NONNULL_END
