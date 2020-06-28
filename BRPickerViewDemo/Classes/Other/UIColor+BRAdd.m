//
//  UIColor+BRAdd.m
//  BRPickerViewDemo
//
//  Created by renbo on 2019/12/26.
//  Copyright © 2019 irenb. All rights reserved.
//

#import "UIColor+BRAdd.h"

@implementation UIColor (BRAdd)

+ (UIColor *)br_systemBackgroundColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor systemBackgroundColor];
    } else {
        return [UIColor whiteColor];
    }
}

+ (UIColor *)br_labelColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor labelColor];
    } else {
        return [UIColor blackColor];
    }
}

@end
