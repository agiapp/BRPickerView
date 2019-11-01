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

/// view style
@interface BRPickerStyle : NSObject

/** maskView backgroundColor */
@property (nonatomic, strong) UIColor *maskColor;
/** hidden maskView */
@property (nonatomic, assign) BOOL hiddenMaskView;

/** alertView backgroundColor */
@property (nonatomic, strong) UIColor *alertViewColor;
/** alertView frame */
@property (nonatomic, assign) CGRect alertViewFrame;
/** alertView top cornerRadius  */
@property (nonatomic, assign) NSInteger topCornerRadius;

/** titleBarView backgroundColor */
@property (nonatomic, strong) UIColor *titleBarColor;
/** titleBarView frame */
@property (nonatomic, assign) CGRect titleBarFrame;
/** lineView(titleBarView border-bottom) backgroundColor */
@property (nonatomic, strong) UIColor *titleLineColor;
/** hidden lineView */
@property (nonatomic, assign) BOOL hiddenLineView;

/** titleLabel backgroundColor */
@property (nonatomic, strong) UIColor *titleLabelColor;
/** titleLabel textColor */
@property (nonatomic, strong) UIColor *titleTextColor;
/** titleLabel font */
@property (nonatomic, strong) UIFont *titleTextFont;
/** titleLabel frame */
@property (nonatomic, assign) CGRect titleLabelFrame;
/** hidden titleLabel */
@property (nonatomic, assign) BOOL hiddenTitleLabel;

/** cancel button backgroundColor */
@property (nonatomic, strong) UIColor *cancelColor;
/** cancel button titleColor */
@property (nonatomic, strong) UIColor *cancelTextColor;
/** cancel button font */
@property (nonatomic, strong) UIFont *cancelTextFont;
/** cancel button borderStyle */
@property (nonatomic, assign) BRBorderStyle cancelBorderStyle;
/** cancel button frame */
@property (nonatomic, assign) CGRect cancelBtnFrame;
/** cancel button image */
@property (nonatomic, strong) UIImage *cancelBtnImage;
/** cancel button title */
@property (nonatomic, copy) NSString *cancelBtnTitle;
/** hidden cancel button */
@property (nonatomic, assign) BOOL hiddenCancelBtn;

/** done button backgroundColor */
@property (nonatomic, strong) UIColor *doneColor;
/** done button titleColor */
@property (nonatomic, strong) UIColor *doneTextColor;
/** done button font */
@property (nonatomic, strong) UIFont *doneTextFont;
/** done button borderStyle */
@property (nonatomic, assign) BRBorderStyle doneBorderStyle;
/** done button frame */
@property (nonatomic, assign) CGRect doneBtnFrame;
/** done button image */
@property (nonatomic, strong) UIImage *doneBtnImage;
/** done button title */
@property (nonatomic, copy) NSString *doneBtnTitle;
/** hidden done button */
@property (nonatomic, assign) BOOL hiddenDoneBtn;

/** picker backgroundColor */
@property (nonatomic, strong) UIColor *pickerColor;
/** picker separatorColor */
@property (nonatomic, strong) UIColor *separatorColor;
/** picker center label textColor */
@property (nonatomic, strong) UIColor *pickerTextColor;
/** picker center label font */
@property (nonatomic, strong) UIFont *pickerTextFont;
/** picker rowHeight */
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
