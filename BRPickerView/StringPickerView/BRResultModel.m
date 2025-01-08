//
//  BRResultModel.m
//  BRPickerViewDemo
//
//  Created by renbo on 2019/10/2.
//  Copyright © 2019 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRResultModel.h"

@implementation BRResultModel

/// 判断两个对象是否相等
/// @param object 目标对象
- (BOOL)isEqual:(id)object {
    // 1.对象的地址相同
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[BRResultModel class]]) {
        return NO;
    }
    
    BRResultModel *model = (BRResultModel *)object;
    if (!model) {
        return NO;
    }
    // 2.对象的类型相同，且对象的各个属性相等
    BOOL isSameKey = (!self.key && !model.key) || [self.key isEqualToString:model.key];
    BOOL isSameValue = (!self.value && !model.value) || [self.value isEqualToString:model.value];
    
    return isSameKey && isSameValue;
}

- (NSUInteger)hash {
    return [self.key hash] ^ [self.value hash];
}

@end
