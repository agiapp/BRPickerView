//
//  BRPickerStyle.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2019/10/2.
//  Copyright © 2019年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRPickerStyle.h"
#import "BRPickerViewMacro.h"

@implementation BRPickerStyle

/// 设置默认样式

- (UIColor *)maskColor {
    if (!_maskColor) {
        _maskColor = [UIColor colorWithWhite:0 alpha:0.2f];
    }
    return _maskColor;
}

- (UIColor *)pickerColor {
    if (!_pickerColor) {
        _pickerColor = [UIColor whiteColor];
    }
    return _pickerColor;
}

- (UIColor *)titleBarColor {
    if (!_titleBarColor) {
        _titleBarColor = kBRToolBarColor;
    }
    return _titleBarColor;
}

- (UIColor *)titleLineColor {
    if (!_titleLineColor) {
        _titleLineColor = BR_RGB_HEX(0xf1f1f1, 1.0f);
    }
    return _titleLineColor;
}

- (UIColor *)leftColor {
    if (!_leftColor) {
        _leftColor = [UIColor clearColor];
    }
    return _leftColor;
}

- (UIColor *)leftTextColor {
    if (!_leftTextColor) {
        _leftTextColor = kDefaultTextColor;
    }
    return _leftTextColor;
}

- (UIFont *)leftTextFont {
    if (!_leftTextFont) {
        _leftTextFont = [UIFont systemFontOfSize:16.0f];
    }
    return _leftTextFont;
}

- (BRBorderStyle)leftBorderStyle {
    if (!_leftBorderStyle) {
        _leftBorderStyle = BRBorderStyleNone;
    }
    return _leftBorderStyle;
}

- (UIColor *)titleTextColor {
    if (!_titleTextColor) {
        _titleTextColor = [kDefaultTextColor colorWithAlphaComponent:0.8f];
    }
    return _titleTextColor;
}

- (UIFont *)titleTextFont {
    if (!_titleTextFont) {
        _titleTextFont = [UIFont systemFontOfSize:15.0f];
    }
    return _titleTextFont;
}

- (UIColor *)rightColor {
    if (!_rightColor) {
        _rightColor = [UIColor clearColor];
    }
    return _rightColor;
}

- (UIColor *)rightTextColor {
    if (!_rightTextColor) {
        _rightTextColor = kDefaultTextColor;
    }
    return _rightTextColor;
}

- (UIFont *)rightTextFont {
    if (!_rightTextFont) {
        _rightTextFont = [UIFont systemFontOfSize:16.0f];
    }
    return _rightTextFont;
}

- (BRBorderStyle)rightBorderStyle {
    if (!_rightBorderStyle) {
        _rightBorderStyle = BRBorderStyleNone;
    }
    return _rightBorderStyle;
}

- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    }
    return _separatorColor;
}

- (UIColor *)pickerTextColor {
    if (!_pickerTextColor) {
        _pickerTextColor = kDefaultTextColor;
    }
    return _pickerTextColor;
}

- (UIFont *)pickerTextFont {
    if (!_pickerTextFont) {
        _pickerTextFont = [UIFont systemFontOfSize:18.0f * kScaleFit];
    }
    return _pickerTextFont;
}

#pragma mark - 快捷设置自定义样式 - 取消/确定按钮圆角样式
+ (instancetype)pickerStyleWithThemeColor:(UIColor *)themeColor {
    BRPickerStyle *customStyle = [[self alloc]init];
    if (themeColor && [themeColor isKindOfClass:[UIColor class]]) {
        customStyle.leftTextColor = themeColor;
        customStyle.leftBorderStyle = BRBorderStyleSolid;
        customStyle.rightColor = themeColor;
        customStyle.rightTextColor = [UIColor whiteColor];
        customStyle.rightBorderStyle = BRBorderStyleFill;
    }
    return customStyle;
}


@end
