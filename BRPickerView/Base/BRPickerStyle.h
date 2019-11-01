//
//  BRPickerStyle.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2019/10/2.
//  Copyright © 2019年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BRPickerViewMacro.h"

// 边框样式（左边取消按钮/右边确定按钮）
typedef NS_ENUM(NSUInteger, BRBorderStyle) {
    /** 无边框（默认） */
    BRBorderStyleNone = 0,
    /** 有圆角和边框 */
    BRBorderStyleSolid,
    /** 仅有圆角 */
    BRBorderStyleFill,
};

/// 选择器配置
@interface BRPickerStyle : NSObject

/** 设置 maskView 的背景颜色（backgroundColor）*/
@property (nonatomic, strong) UIColor *maskColor;

/** 隐藏 maskView */
@property (nonatomic, assign) BOOL hiddenMaskView;


/** 设置 alertView 的背景颜色（backgroundColor）*/
@property (nonatomic, strong) UIColor *alertViewColor;

/** 设置 alertView 顶部左边和右边的圆角  */
@property (nonatomic, assign) NSInteger topCornerRadius;


/** 设置 titleBarView 的背景颜色（backgroundColor）*/
@property (nonatomic, strong) UIColor *titleBarColor;

/** 设置 titleBarView 的高度（height）*/
@property (nonatomic, assign) CGFloat titleBarHeight;

/** 设置 titleBarView 底部边框的背景颜色（border-bottom backgroundColor）*/
@property (nonatomic, strong) UIColor *titleLineColor;

/** 隐藏 titleBarView 底部边框（border-bottom） */
@property (nonatomic, assign) BOOL hiddenTitleBottomBorder;


/** 设置 titleLabel 的背景颜色（backgroundColor）*/
@property (nonatomic, strong) UIColor *titleLabelColor;

/** 设置 titleLabel 文本颜色（textColor）*/
@property (nonatomic, strong) UIColor *titleTextColor;

/** 设置 titleLabel 字体大小（font）*/
@property (nonatomic, strong) UIFont *titleTextFont;

/** 设置 titleLabel 的 frame */
@property (nonatomic, assign) CGRect titleLabelFrame;

/** 隐藏 titleLabel */
@property (nonatomic, assign) BOOL hiddenTitleLabel;


/** 设置 cancelBtn 的背景颜色（backgroundColor）*/
@property (nonatomic, strong) UIColor *cancelColor;

/** 设置 cancelBtn 标题的颜色（titleColor）*/
@property (nonatomic, strong) UIColor *cancelTextColor;

/** 设置 cancelBtn 标题的字体（font）*/
@property (nonatomic, strong) UIFont *cancelTextFont;

/** 设置 cancelBtn 的边框样式（borderStyle）*/
@property (nonatomic, assign) BRBorderStyle cancelBorderStyle;

/** 设置 cancelBtn 的 frame */
@property (nonatomic, assign) CGRect cancelBtnFrame;

/** 设置 cancelBtn 的 image */
@property (nonatomic, strong) UIImage *cancelBtnImage;

/** 设置 cancelBtn 的 title */
@property (nonatomic, copy) NSString *cancelBtnTitle;

/** 隐藏 cancelBtn */
@property (nonatomic, assign) BOOL hiddenCancelBtn;


/** 设置 doneBtn 的背景颜色（backgroundColor）*/
@property (nonatomic, strong) UIColor *doneColor;

/** 设置 doneBtn 标题的颜色（titleColor）*/
@property (nonatomic, strong) UIColor *doneTextColor;

/** 设置 doneBtn 标题的字体（font）*/
@property (nonatomic, strong) UIFont *doneTextFont;

/** 设置 doneBtn 的边框样式（borderStyle）*/
@property (nonatomic, assign) BRBorderStyle doneBorderStyle;

/** 设置 doneBtn 的 frame */
@property (nonatomic, assign) CGRect doneBtnFrame;

/** 设置 doneBtn 的 image */
@property (nonatomic, strong) UIImage *doneBtnImage;

/** 设置 doneBtn 的 title */
@property (nonatomic, copy) NSString *doneBtnTitle;

/** 隐藏 doneBtn */
@property (nonatomic, assign) BOOL hiddenDoneBtn;


/** 设置 picker 的背景颜色（backgroundColor）*/
@property (nonatomic, strong) UIColor *pickerColor;

/** 设置 picker 中间两条分割线的背景颜色（separatorColor）*/
@property (nonatomic, strong) UIColor *separatorColor;

/** 设置 picker 文本的颜色（textColor）*/
@property (nonatomic, strong) UIColor *pickerTextColor;

/** 设置 picker 文本的字体（font）*/
@property (nonatomic, strong) UIFont *pickerTextFont;

/** 设置 picker 的行高（rowHeight）*/
@property (nonatomic, assign) CGFloat rowHeight;


/**
 *  设置语言（不设置或为nil时，将随系统的语言自动改变）
 *  language: zh-Hans（简体中文）、zh-Hant（繁体中文）、en（英语 ）
 */
@property(nonatomic, copy) NSString *language;


//------------------------------------------ Deprecated properties ------------------------------------------

@property (nonatomic, strong) UIColor *leftColor BRPickerViewDeprecated("Use the cancelColor instead");
@property (nonatomic, strong) UIColor *leftTextColor BRPickerViewDeprecated("Use the cancelTextColor instead");
@property (nonatomic, strong) UIFont *leftTextFont BRPickerViewDeprecated("Use the cancelTextFont instead");
@property (nonatomic, assign) BRBorderStyle leftBorderStyle BRPickerViewDeprecated("Use the cancelBorderStyle instead");
@property (nonatomic, assign) CGFloat leftBtnWidth BRPickerViewDeprecated("Use the cancelBtnFrame instead");
@property (nonatomic, strong) UIImage *leftBtnImage BRPickerViewDeprecated("Use the cancelBtnImage instead");
@property (nonatomic, copy) NSString *leftBtnTitle BRPickerViewDeprecated("Use the cancelBtnTitle instead");

@property (nonatomic, strong) UIColor *rightColor BRPickerViewDeprecated("Use the doneColor instead");
@property (nonatomic, strong) UIColor *rightTextColor BRPickerViewDeprecated("Use the doneTextColor instead");
@property (nonatomic, strong) UIFont *rightTextFont BRPickerViewDeprecated("Use the doneTextFont instead");
@property (nonatomic, assign) BRBorderStyle rightBorderStyle BRPickerViewDeprecated("Use the doneBorderStyle instead");
@property (nonatomic, assign) CGFloat rightBtnWidth BRPickerViewDeprecated("Use the doneBtnFrame instead");
@property (nonatomic, strong) UIImage *rightBtnImage BRPickerViewDeprecated("Use the doneBtnImage instead");
@property (nonatomic, copy) NSString *rightBtnTitle BRPickerViewDeprecated("Use the doneBtnTitle instead");


/// 快捷设置自定义样式 - 取消/确定按钮圆角样式
/// @param themeColor 主题颜色
+ (instancetype)pickerStyleWithThemeColor:(UIColor *)themeColor;


@end
