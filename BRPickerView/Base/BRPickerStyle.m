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

- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = BR_RGB_HEX(0xf1f1f1, 1.0f);
    }
    return _lineColor;
}

- (UIColor *)leftTextColor {
    if (!_leftTextColor) {
        _leftTextColor = kDefaultThemeColor;
    }
    return _leftTextColor;
}

- (BRBorderStyle)leftBorderStyle {
    if (!_leftBorderStyle) {
        _leftBorderStyle = BRBorderStyleNone;
    }
    return _leftBorderStyle;
}

- (UIColor *)titleTextColor {
    if (!_titleTextColor) {
        _titleTextColor = [kDefaultThemeColor colorWithAlphaComponent:0.8f];
    }
    return _titleTextColor;
}

- (UIColor *)rightTextColor {
    if (!_rightTextColor) {
        _rightTextColor = kDefaultThemeColor;
    }
    return _rightTextColor;
}

- (BRBorderStyle)rightBorderStyle {
    if (!_rightBorderStyle) {
        _rightBorderStyle = BRBorderStyleNone;
    }
    return _rightBorderStyle;
}

@end
