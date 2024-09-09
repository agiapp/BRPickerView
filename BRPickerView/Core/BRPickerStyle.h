//
//  BRPickerStyle.h
//  BRPickerViewDemo
//
//  Created by renbo on 2019/10/2.
//  Copyright © 2019 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BRPickerViewMacro.h"

NS_ASSUME_NONNULL_BEGIN

// 边框样式（左边取消按钮/右边确定按钮）
typedef NS_ENUM(NSInteger, BRBorderStyle) {
    /** 无边框（默认） */
    BRBorderStyleNone = 0,
    /** 有圆角和边框 */
    BRBorderStyleSolid,
    /** 仅有圆角 */
    BRBorderStyleFill
};

@interface BRPickerStyle : NSObject


/////////////////////////////// 蒙层视图（maskView）///////////////////////////////

/** 设置背景颜色 */
@property (nullable, nonatomic, strong) UIColor *maskColor;

/** 隐藏 maskView，默认为 NO */
@property (nonatomic, assign) BOOL hiddenMaskView;


////////////////////////////// 弹框视图（alertView）///////////////////////////////

/** 设置 alertView 弹框视图的背景颜色 */
@property (nullable, nonatomic, strong) UIColor *alertViewColor;

/** 设置 alertView 弹框视图左上和右上的圆角半径  */
@property (nonatomic, assign) NSInteger topCornerRadius;

/** 设置 alertView 弹框视图顶部边框线颜色  */
@property (nullable, nonatomic, strong) UIColor *shadowLineColor;

/** 设置 alertView 弹框视图顶部边框线高度  */
@property (nonatomic, assign) CGFloat shadowLineHeight;

/** 隐藏 alertView 弹框视图顶部边框线，默认为 NO */
@property (nonatomic, assign) BOOL hiddenShadowLine;

/** 设置 alertView 弹框视图底部内边距，默认为安全区域底部距屏幕底部的高度  */
@property (nonatomic, assign) CGFloat paddingBottom;


//////////////////////////// 标题栏视图（titleBarView） ////////////////////////////

/** 设置 titleBarView 标题栏的背景颜色 */
@property (nullable, nonatomic, strong) UIColor *titleBarColor;

/** 设置 titleBarView 标题栏的高度 */
@property (nonatomic, assign) CGFloat titleBarHeight;

/** 设置 titleBarView 标题栏底部分割线颜色 */
@property (nullable, nonatomic, strong) UIColor *titleLineColor;

/** 隐藏 titleBarView 标题栏底部分割线，默认为 NO  */
@property (nonatomic, assign) BOOL hiddenTitleLine;

/** 隐藏 titleBarView，默认为 NO */
@property (nonatomic, assign) BOOL hiddenTitleBarView;


////////////////////////// 标题栏中间label（titleLabel）///////////////////////////

/** 设置 titleLabel 的背景颜色 */
@property (nullable, nonatomic, strong) UIColor *titleLabelColor;

/** 设置 titleLabel 文本颜色 */
@property (nullable, nonatomic, strong) UIColor *titleTextColor;

/** 设置 titleLabel 字体大小 */
@property (nullable, nonatomic, strong) UIFont *titleTextFont;

/** 设置 titleLabel 的 frame */
@property (nonatomic, assign) CGRect titleLabelFrame;

/** 隐藏 titleLabel，默认为 NO */
@property (nonatomic, assign) BOOL hiddenTitleLabel;


/////////////////////////////// 取消按钮（cancelBtn）//////////////////////////////

/** 设置 cancelBtn 的背景颜色 */
@property (nullable, nonatomic, strong) UIColor *cancelColor;

/** 设置 cancelBtn 标题的颜色 */
@property (nullable, nonatomic, strong) UIColor *cancelTextColor;

/** 设置 cancelBtn 标题的字体 */
@property (nullable, nonatomic, strong) UIFont *cancelTextFont;

/** 设置 cancelBtn 的 frame */
@property (nonatomic, assign) CGRect cancelBtnFrame;

/** 设置 cancelBtn 的边框样式 */
@property (nonatomic, assign) BRBorderStyle cancelBorderStyle;

/** 设置 cancelBtn 的圆角大小 */
@property (nonatomic, assign) CGFloat cancelCornerRadius;

/** 设置 cancelBtn 的边框宽度 */
@property (nonatomic, assign) CGFloat cancelBorderWidth;

/** 设置 cancelBtn 的 image */
@property (nullable, nonatomic, strong) UIImage *cancelBtnImage;

/** 设置 cancelBtn 的 title */
@property (nullable, nonatomic, copy) NSString *cancelBtnTitle;

/** 隐藏 cancelBtn，默认为 NO */
@property (nonatomic, assign) BOOL hiddenCancelBtn;


/////////////////////////////// 确定按钮（doneBtn）////////////////////////////////

/** 设置 doneBtn 的背景颜色 */
@property (nullable, nonatomic, strong) UIColor *doneColor;

/** 设置 doneBtn 标题的颜色 */
@property (nullable, nonatomic, strong) UIColor *doneTextColor;

/** 设置 doneBtn 标题的字体 */
@property (nullable, nonatomic, strong) UIFont *doneTextFont;

/** 设置 doneBtn 的 frame */
@property (nonatomic, assign) CGRect doneBtnFrame;

/** 设置 doneBtn 的边框样式 */
@property (nonatomic, assign) BRBorderStyle doneBorderStyle;

/** 设置 doneBtn 的圆角大小 */
@property (nonatomic, assign) CGFloat doneCornerRadius;

/** 设置 doneBtn 的边框宽度 */
@property (nonatomic, assign) CGFloat doneBorderWidth;

/** 设置 doneBtn 的 image */
@property (nullable, nonatomic, strong) UIImage *doneBtnImage;

/** 设置 doneBtn 的 title */
@property (nullable, nonatomic, copy) NSString *doneBtnTitle;

/** 隐藏 doneBtn，默认为 NO */
@property (nonatomic, assign) BOOL hiddenDoneBtn;


/////////////////////////////// 选择器（pickerView）///////////////////////////////

/** 设置 picker 的背景颜色 */
@property (nullable, nonatomic, strong) UIColor *pickerColor;

/** 设置 picker 中间两条分割线的背景颜色。暂不支持日期选择器前4种类型 */
@property (nullable, nonatomic, strong) UIColor *separatorColor;

/** 设置 picker 中间两条分割线的高度。暂不支持日期选择器前4种类型 */
@property (nonatomic, assign) CGFloat separatorHeight;

/** 设置 picker 文本的颜色。暂不支持日期选择器前4种类型 */
@property (nullable, nonatomic, strong) UIColor *pickerTextColor;

/** 设置 picker 文本的字体。暂不支持日期选择器前4种类型 */
@property (nullable, nonatomic, strong) UIFont *pickerTextFont;

/** 设置 picker 中间选中行的背景颜色。暂不支持日期选择器前4种类型 */
@property (nullable, nonatomic, strong) UIColor *selectRowColor;

/** 设置 picker 中间选中行文本的颜色。暂不支持日期选择器前4种类型 */
@property (nullable, nonatomic, strong) UIColor *selectRowTextColor;

/** 设置 picker 中间选中行文本的字体。暂不支持日期选择器前4种类型 */
@property (nullable, nonatomic, strong) UIFont *selectRowTextFont;

/** 设置 picker 的高度，系统默认高度为 216 */
@property (nonatomic, assign) CGFloat pickerHeight;

/** 设置 picker 的行高，默认为 35 */
@property (nonatomic, assign) CGFloat rowHeight;
/** 设置 picker 的列宽 */
@property (nonatomic, assign) CGFloat columnWidth;
/** 设置 picker 的列间隔，仅支持`BRStringPickerView` */
@property (nonatomic, assign) CGFloat columnSpacing;

/** 设置 picker 文本支持的最大行数，默认为 2 */
@property (nonatomic, assign) NSUInteger maxTextLines;

/**
 *  清除iOS14之后选择器默认自带的新样式。暂不支持日期选择器前4种类型
 *  主要是：①隐藏中间选择行的背景样式，②清除默认的内边距，③新增中间选择行的两条分割线；与iOS14之前的样式保持一致），默认为 YES
 */
@property (nonatomic, assign) BOOL clearPickerNewStyle;


/**
 *  设置语言（不设置或为nil时，将随系统的语言自动改变）
 *  language: zh-Hans（简体中文）、zh-Hant（繁体中文）、en（英语 ）
 */
@property(nullable, nonatomic, copy) NSString *language;


/////// 日期选择器单位样式（showUnitType == BRShowUnitTypeOnlyCenter 时生效。暂不支持日期选择器前4种类型 ）///////

/** 设置日期选择器单位文本的颜色 */
@property (nullable, nonatomic, strong) UIColor *dateUnitTextColor;

/** 设置日期选择器单位文本的字体 */
@property (nullable, nonatomic, strong) UIFont *dateUnitTextFont;

/** 设置日期选择器单位 label 的水平方向偏移量 */
@property (nonatomic, assign) CGFloat dateUnitOffsetX;

/** 设置日期选择器单位 label 的竖直方向偏移量 */
@property (nonatomic, assign) CGFloat dateUnitOffsetY;


//////////////////////////////// 常用的几种模板样式 ////////////////////////////////

/// 弹框模板样式1 - 取消/确定按钮圆角样式
/// @param themeColor 主题颜色
+ (instancetype)pickerStyleWithThemeColor:(nullable UIColor *)themeColor;

/// 弹框模板样式2 - 顶部圆角样式 + 完成按钮
/// @param doneTextColor 完成按钮标题的颜色
+ (instancetype)pickerStyleWithDoneTextColor:(nullable UIColor *)doneTextColor;

/// 弹框模板样式3 - 顶部圆角样式 + 图标按钮
/// @param doneBtnImage 完成按钮的 image
+ (instancetype)pickerStyleWithDoneBtnImage:(nullable UIImage *)doneBtnImage;


//////////////////////////////// 以下是组件内部使用的几个封装方法 ////////////////////////////////

/** 设置选择器中间选中行的样式 */
- (void)setupPickerSelectRowStyle:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

/** 添加选择器中间行上下两条分割线（iOS14之后系统默认去掉，需要手动添加）*/
- (void)addSeparatorLineView:(UIView *)pickerView;

/** 设置 view 的部分圆角 */
// corners(枚举类型，可组合使用)：UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
+ (void)br_setView:(UIView *)view roundingCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
