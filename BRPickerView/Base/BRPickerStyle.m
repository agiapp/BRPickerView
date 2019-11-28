//
//  BRPickerStyle.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2019/10/2.
//  Copydone © 2019年 91renb. All dones reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRPickerStyle.h"
#import "NSBundle+BRPickerView.h"

// 标题颜色
#define kDefaultTextColor BR_RGB_HEX(0x333333, 1.0)

@implementation BRPickerStyle

/// 设置默认样式

- (UIColor *)maskColor {
    if (!_maskColor) {
        _maskColor = [UIColor colorWithWhite:0 alpha:0.2f];
    }
    return _maskColor;
}

- (UIColor *)alertViewColor {
    if (!_alertViewColor) {
        _alertViewColor = self.pickerColor;
    }
    return _alertViewColor;
}

- (UIColor *)shadowLineColor {
    if (!_shadowLineColor) {
        _shadowLineColor = BR_RGB_HEX(0xcccccc, 1.0f);
    }
    return _shadowLineColor;
}

- (UIColor *)titleBarColor {
    if (!_titleBarColor) {
        _titleBarColor = BR_RGB_HEX(0xfdfdfd, 1.0f);
    }
    return _titleBarColor;
}

- (CGFloat)titleBarHeight {
    if (!self.hiddenTitleBarView) {
        if (_titleBarHeight < 44.0f && (!self.hiddenCancelBtn || !self.hiddenDoneBtn || !self.hiddenTitleLabel)) {
            _titleBarHeight = 44.0f;
        }
    } else {
        _titleBarHeight = 0;
    }
    return _titleBarHeight;
}

- (UIColor *)titleLineColor {
    if (!_titleLineColor) {
        _titleLineColor = BR_RGB_HEX(0xf1f1f1, 1.0f);
    }
    return _titleLineColor;
}

- (UIColor *)cancelColor {
    if (!_cancelColor) {
        _cancelColor = [UIColor clearColor];
    }
    return _cancelColor;
}

- (UIColor *)cancelTextColor {
    if (!_cancelTextColor) {
        _cancelTextColor = kDefaultTextColor;
    }
    return _cancelTextColor;
}

- (UIFont *)cancelTextFont {
    if (!_cancelTextFont) {
        _cancelTextFont = [UIFont systemFontOfSize:16.0f];
    }
    return _cancelTextFont;
}

- (NSString *)cancelBtnTitle {
    if (!_cancelBtnTitle && !_cancelBtnImage) {
        _cancelBtnTitle = [NSBundle br_localizedStringForKey:@"取消" language:self.language];
    }
    return _cancelBtnTitle;
}

- (CGRect)cancelBtnFrame {
    if (CGRectEqualToRect(_cancelBtnFrame, CGRectZero) || _cancelBtnFrame.size.height == 0) {
        _cancelBtnFrame = CGRectMake(5, 8, 60, 28);
    }
    return _cancelBtnFrame;
}

- (UIColor *)titleLabelColor {
    if (!_titleLabelColor) {
        _titleLabelColor = [UIColor clearColor];
    }
    return _titleLabelColor;
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

- (CGRect)titleLabelFrame {
    if (CGRectEqualToRect(_titleLabelFrame, CGRectZero) || _titleLabelFrame.size.height == 0) {
        _titleLabelFrame = CGRectMake(5 + 60 + 2, 0, SCREEN_WIDTH - 2 * (5 + 60 + 2), 44);
    }
    return _titleLabelFrame;
}

- (UIColor *)doneColor {
    if (!_doneColor) {
        _doneColor = [UIColor clearColor];
    }
    return _doneColor;
}

- (UIColor *)doneTextColor {
    if (!_doneTextColor) {
        _doneTextColor = kDefaultTextColor;
    }
    return _doneTextColor;
}

- (UIFont *)doneTextFont {
    if (!_doneTextFont) {
        _doneTextFont = [UIFont systemFontOfSize:16.0f];
    }
    return _doneTextFont;
}

- (NSString *)doneBtnTitle {
    if (!_doneBtnTitle && !_doneBtnImage) {
        _doneBtnTitle = [NSBundle br_localizedStringForKey:@"确定" language:self.language];
    }
    return _doneBtnTitle;
}

- (CGRect)doneBtnFrame {
    if (CGRectEqualToRect(_doneBtnFrame, CGRectZero) || _doneBtnFrame.size.height == 0) {
        _doneBtnFrame = CGRectMake(SCREEN_WIDTH - 60 - 5, 8, 60, 28);
    }
    return _doneBtnFrame;
}

- (UIColor *)pickerColor {
    if (!_pickerColor) {
        _pickerColor = [UIColor whiteColor];
    }
    return _pickerColor;
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
        _pickerTextFont = [UIFont systemFontOfSize:18.0f];
    }
    return _pickerTextFont;
}

- (CGFloat)pickerHeight {
    if (_pickerHeight < 40) {
        _pickerHeight = 216.0f;
    }
    return _pickerHeight;
}

- (CGFloat)rowHeight {
    if (_rowHeight < 20) {
        _rowHeight = 35.0f;
    }
    return _rowHeight;
}

- (NSString *)language {
    if (!_language) {
        // 跟随系统的首选语言自动改变
        _language = [NSLocale preferredLanguages].firstObject;
    }
    return _language;
}

#pragma mark - 快捷设置自定义样式 - 取消/确定按钮圆角样式
+ (instancetype)pickerStyleWithThemeColor:(UIColor *)themeColor {
    BRPickerStyle *customStyle = [[self alloc]init];
    if (themeColor && [themeColor isKindOfClass:[UIColor class]]) {
        customStyle.cancelTextColor = themeColor;
        customStyle.cancelBorderStyle = BRBorderStyleSolid;
        customStyle.doneColor = themeColor;
        customStyle.doneTextColor = [UIColor whiteColor];
        customStyle.doneBorderStyle = BRBorderStyleFill;
    }
    return customStyle;
}

@end
