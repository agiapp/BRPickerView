//
//  BRPickerStyle.m
//  BRPickerViewDemo
//
//  Created by renbo on 2019/10/2.
//  Copyright © 2019 irenb. All dones reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRPickerStyle.h"
#import "NSBundle+BRPickerView.h"

// 标题颜色
#define kBRDefaultTextColor BR_RGB_HEX(0x333333, 1.0f)

@implementation BRPickerStyle

- (instancetype)init {
    if (self = [super init]) {
        self.clearPickerNewStyle = YES;
    }
    return self;
}

/// 设置默认样式

- (UIColor *)maskColor {
    if (!_maskColor) {
        _maskColor = [self br_colorWithLightColor:BR_RGB_HEX(0x000000, 0.3f) darkColor:BR_RGB_HEX(0x666666, 0.3f)];
    }
    return _maskColor;
}

- (UIColor *)shadowLineColor {
    if (!_shadowLineColor) {
        if (@available(iOS 13.0, *)) {
            // 边框线颜色，有透明度
            _shadowLineColor = [UIColor separatorColor];
        } else {
            _shadowLineColor = BR_RGB_HEX(0xc6c6c8, 1.0f);
        }
    }
    return _shadowLineColor;
}

- (CGFloat)shadowLineHeight {
    if (_shadowLineHeight <= 0 || _shadowLineHeight > 5.0f) {
        _shadowLineHeight = 0.5f;
    }
    return _shadowLineHeight;
}

- (CGFloat)paddingBottom {
    if (_paddingBottom <= 0) {
        _paddingBottom = BR_BOTTOM_MARGIN;
    }
    return _paddingBottom;
}

- (UIColor *)titleBarColor {
    if (!_titleBarColor) {
        if (@available(iOS 13.0, *)) {
            // #ffffff(正常)、#1c1c1e(深色)
            _titleBarColor = [UIColor secondarySystemGroupedBackgroundColor];
        } else {
            _titleBarColor = [UIColor whiteColor];
        }
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
        _titleLineColor = [self br_colorWithLightColor:BR_RGB_HEX(0xededee, 1.0f) darkColor:BR_RGB_HEX(0x18181c, 1.0f)];
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
        if (@available(iOS 13.0, *)) {
            _cancelTextColor = [UIColor labelColor];
        } else {
            _cancelTextColor = kBRDefaultTextColor;
        }
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
        if (@available(iOS 13.0, *)) {
            _titleTextColor = [UIColor secondaryLabelColor];
        } else {
            _titleTextColor = BR_RGB_HEX(0x999999, 1.0f);
        }
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
        _titleLabelFrame = CGRectMake(5 + 60 + 2, 0, BRGetKeyWindow().bounds.size.width - 2 * (5 + 60 + 2), 44);
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
        if (@available(iOS 13.0, *)) {
            _doneTextColor = [UIColor labelColor];
        } else {
            _doneTextColor = kBRDefaultTextColor;
        }
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
        _doneBtnFrame = CGRectMake(BRGetKeyWindow().bounds.size.width - 60 - 5, 8, 60, 28);
    }
    return _doneBtnFrame;
}

- (UIColor *)pickerColor {
    if (!_pickerColor) {
        if (@available(iOS 13.0, *)) {
            // #ffffff(正常)、#1c1c1e(深色)
            _pickerColor = [UIColor secondarySystemGroupedBackgroundColor];
        } else {
            _pickerColor = [UIColor whiteColor];
        }
    }
    return _pickerColor;
}

- (UIColor *)separatorColor {
    if (!_separatorColor) {
        if (@available(iOS 13.0, *)) {
            // 分割线颜色，无透明度
            _separatorColor = [UIColor opaqueSeparatorColor];
        } else {
            _separatorColor = BR_RGB_HEX(0xc6c6c8, 1.0f);
        }
    }
    return _separatorColor;
}

- (UIColor *)pickerTextColor {
    if (!_pickerTextColor) {
        if (@available(iOS 13.0, *)) {
            _pickerTextColor = [UIColor labelColor];
        } else {
            _pickerTextColor = kBRDefaultTextColor;
        }
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
        // zh-Hans-CN(简体中文)、zh-Hant-CN(繁体中文)、en-CN(美式英语)、en-GB(英式英语)
        // 其中`CN`是iOS9以后新增的地区代码，如：CN 代表中国，US 代表美国
        _language = [NSLocale preferredLanguages].firstObject;
    }
    return _language;
}

- (UIColor *)dateUnitTextColor {
    if (!_dateUnitTextColor) {
        if (@available(iOS 13.0, *)) {
            _dateUnitTextColor = [UIColor labelColor];
        } else {
            _dateUnitTextColor = kBRDefaultTextColor;
        }
    }
    return _dateUnitTextColor;
}

- (UIFont *)dateUnitTextFont {
    if (!_dateUnitTextFont) {
        _dateUnitTextFont = [UIFont systemFontOfSize:18.0f];
    }
    return _dateUnitTextFont;
}

#pragma mark - 创建自定义动态颜色（适配深色模式）
- (UIColor *)br_colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    if (@available(iOS 13.0, *)) {
        UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if ([traitCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return lightColor;
            } else {
                return darkColor;
            }
        }];
        return dyColor;
    } else {
        return lightColor;
    }
}

#pragma mark - 弹框模板样式1 - 取消/确定按钮圆角样式
+ (instancetype)pickerStyleWithThemeColor:(UIColor *)themeColor {
    BRPickerStyle *customStyle = [[self alloc]init];
    if (themeColor) {
        customStyle.cancelTextColor = themeColor;
        customStyle.cancelBorderStyle = BRBorderStyleSolid;
        customStyle.doneColor = themeColor;
        customStyle.doneTextColor = [UIColor whiteColor];
        customStyle.doneBorderStyle = BRBorderStyleFill;
    }
    return customStyle;
}

#pragma mark - 弹框模板样式2 - 顶部圆角样式 + 完成按钮
+ (instancetype)pickerStyleWithDoneTextColor:(UIColor *)doneTextColor {
    BRPickerStyle *customStyle = [[self alloc]init];
    if (doneTextColor) {
        customStyle.topCornerRadius = 16.0f;
        customStyle.hiddenCancelBtn = YES;
        customStyle.hiddenTitleLine = YES;
        customStyle.titleLabelFrame = CGRectMake(20, 4, 100, 40);
        customStyle.doneTextColor = doneTextColor;
        customStyle.doneTextFont = [UIFont boldSystemFontOfSize:18.0f];
        customStyle.doneBtnFrame = CGRectMake(BRGetKeyWindow().bounds.size.width - 60, 4, 60, 40);
        customStyle.doneBtnTitle = [NSBundle br_localizedStringForKey:@"完成" language:customStyle.language];
        customStyle.selectRowTextColor = doneTextColor;
        customStyle.selectRowTextFont = [UIFont boldSystemFontOfSize:20.0f];
    }
    return customStyle;
}

#pragma mark - 弹框模板样式3 - 顶部圆角样式 + 图标按钮
+ (instancetype)pickerStyleWithDoneBtnImage:(UIImage *)doneBtnImage {
    BRPickerStyle *customStyle = [[self alloc]init];
    if (doneBtnImage) {
        customStyle.topCornerRadius = 16.0f;
        customStyle.hiddenTitleLine = YES;
        customStyle.hiddenCancelBtn = YES;
        customStyle.titleLabelFrame = CGRectMake(20, 4, 100, 40);
        customStyle.doneBtnImage = doneBtnImage;
        customStyle.doneBtnFrame = CGRectMake(BRGetKeyWindow().bounds.size.width - 44, 4, 40, 40);
    }
    return customStyle;
}


#pragma mark - 设置选择器中间选中行的样式
- (void)setupPickerSelectRowStyle:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // 1.设置分割线的颜色
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    if (systemVersion.doubleValue < 14.0) {
        for (UIView *subView in pickerView.subviews) {
            if (subView && [subView isKindOfClass:[UIView class]] && subView.frame.size.height <= 1) {
                subView.backgroundColor = self.separatorColor;
                // 设置分割线高度
                if (self.separatorHeight > 0) {
                    CGRect rect = subView.frame;
                    rect.size.height = self.separatorHeight;
                    subView.frame = rect;
                }
            }
        }
    }
    
    // 2.设置选择器中间选中行的背景颜色
    UIView *contentView = nil;
    NSArray *subviews = pickerView.subviews;
    if (subviews.count > 0) {
        id firstView = subviews.firstObject;
        if (firstView && [firstView isKindOfClass:[UIView class]]) {
            contentView = (UIView *)firstView;
        }
    }
    if (self.selectRowColor) {
        UIView *columnView = nil;
        if (contentView) {
            id obj = [contentView valueForKey:@"subviewCache"];
            if (obj && [obj isKindOfClass:[NSArray class]]) {
                NSArray *columnViews = (NSArray *)obj;
                if (columnViews.count > 0) {
                    id columnObj = columnViews.firstObject;
                    if (columnObj && [columnObj isKindOfClass:[UIView class]]) {
                        columnView = (UIView *)columnObj;
                    }
                }
            }
        }
        if (columnView) {
            id obj = [columnView valueForKey:@"middleContainerView"];
            if (obj && [obj isKindOfClass:[UIView class]]) {
                UIView *selectRowView = (UIView *)obj;
                // 中间选中行的背景颜色
                selectRowView.backgroundColor = self.selectRowColor;
            }
        }
    }
    
    if (contentView && self.clearPickerNewStyle) {
        if (systemVersion.doubleValue >= 14.0) {
            // ①隐藏中间选择行的背景样式
            id lastView = subviews.lastObject;
            if (lastView && [lastView isKindOfClass:[UIView class]]) {
                UIView *rectBgView = (UIView *)lastView;
                rectBgView.hidden = YES;
            }
            
            // ②清除iOS14上选择器默认的内边距
            if (systemVersion.doubleValue < 15.0f) {
                [self setPickerAllSubViewsStyle:contentView];
            }
        }
    }
    
    // 3.设置选择器中间选中行的字体颜色/字体大小
    if (self.selectRowTextColor || self.selectRowTextFont) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 当前选中的 label
            UILabel *selectLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
            if (selectLabel) {
                if (self.selectRowTextColor) {
                    selectLabel.textColor = self.selectRowTextColor;
                }
                if (self.selectRowTextFont) {
                    selectLabel.font = self.selectRowTextFont;
                }
            }
        });
    }
}

// 遍历子视图，重新设置 frame（清空在 iOS14 上 UIPickerView 出现的内边距）
- (void)setPickerAllSubViewsStyle:(UIView *)view {
    NSArray *subViews = view.subviews;
    if (subViews.count == 0 || [view isKindOfClass:[UILabel class]]) return;
    for (UIView *subView in subViews) {
        NSString *className = NSStringFromClass([subView class]);
        if ([className isEqualToString:@"UIPickerColumnView"]) {
            CGRect rect = subView.frame;
            rect.origin.x = 0;
            rect.size.width = view.bounds.size.width;
            subView.frame = rect;
        }
        NSString *superClassName = NSStringFromClass([view class]);
        if ([superClassName isEqualToString:@"UIPickerColumnView"]) {
            CGRect rect = subView.frame;
            rect.size.width = view.bounds.size.width;
            subView.frame = rect;
        }
        if ([subView isKindOfClass:[UILabel class]]) {
            CGRect rect = subView.frame;
            rect.origin.x = 10;
            subView.frame = rect;
        }
        
        [self setPickerAllSubViewsStyle:subView];
    }
}

#pragma mark - 添加选择器中间行上下两条分割线（iOS14之后系统默认去掉，需要手动添加）
- (void)addSeparatorLineView:(UIView *)pickerView {
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 14.0) {
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, pickerView.bounds.size.height / 2 - self.rowHeight / 2, pickerView.bounds.size.width, 0.5f)];
        topLineView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        topLineView.backgroundColor = self.separatorColor;
        // 设置分割线高度
        if (self.separatorHeight > 0) {
            CGRect topRect = topLineView.frame;
            topRect.size.height = self.separatorHeight;
            topLineView.frame = topRect;
        }
        [pickerView addSubview:topLineView];
        
        UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, pickerView.bounds.size.height / 2 + self.rowHeight / 2, pickerView.bounds.size.width, 0.5f)];
        bottomLineView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        bottomLineView.backgroundColor = self.separatorColor;
        // 设置分割线高度
        if (self.separatorHeight > 0) {
            CGRect bottomRect = bottomLineView.frame;
            bottomRect.size.height = self.separatorHeight;
            bottomLineView.frame = bottomRect;
        }
        [pickerView addSubview:bottomLineView];
    }
}

#pragma mark - 设置 view 的部分圆角
// corners(枚举类型，可组合使用)：UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
+ (void)br_setView:(UIView *)view roundingCorners:(UIRectCorner)corners withRadius:(CGFloat)radius {
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *shape = [[CAShapeLayer alloc]init];
    [shape setPath:rounded.CGPath];
    view.layer.mask = shape;
}

@end
