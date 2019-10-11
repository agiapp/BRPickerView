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

// 边框样式（左边取消按钮/右边确定按钮）
typedef NS_ENUM(NSUInteger, BRBorderStyle) {
    /** 无边框（默认） */
    BRBorderStyleNone = 0,
    /** 有圆角和边框，且圆角半径为6，边框宽度为1，边框颜色和文本颜色保持一致 */
    BRBorderStyleSolid,
    /** 仅有圆角，且圆角半径为6 */
    BRBorderStyleFill,
};

/// 选择器视图样式
@interface BRPickerStyle : NSObject

/** 背景遮罩视图颜色 */
@property (nonatomic, strong) UIColor *maskColor;

/** 标题栏背景颜色 */
@property (nonatomic, strong) UIColor *titleBarColor;
/** 标题栏下边框线颜色 */
@property (nonatomic, strong) UIColor *titleLineColor;

/** 左边取消按钮背景颜色 */
@property (nonatomic, strong) UIColor *leftColor;
/** 左边取消按钮文本颜色 */
@property (nonatomic, strong) UIColor *leftTextColor;
/** 左边取消按钮边框样式 */
@property (nonatomic, assign) BRBorderStyle leftBorderStyle;

/** 中间标题文本颜色 */
@property (nonatomic, strong) UIColor *titleTextColor;

/** 右边确定按钮背景颜色 */
@property (nonatomic, strong) UIColor *rightColor;
/** 右边确定按钮文本颜色 */
@property (nonatomic, strong) UIColor *rightTextColor;
/** 右边确定按钮边框样式 */
@property (nonatomic, assign) BRBorderStyle rightBorderStyle;

/** picker 选择器视图背景颜色 */
@property (nonatomic, strong) UIColor *pickerColor;
/** picker 中间分割线颜色 */
@property (nonatomic, strong) UIColor *separatorColor;
/** picker 中间选择文本颜色 */
@property (nonatomic, strong) UIColor *pickerTextColor;



/// 快捷设置自定义样式 - 取消/确定按钮圆角样式
/// @param themeColor 主题颜色
+ (instancetype)pickerStyleWithThemeColor:(UIColor *)themeColor;

/// 快捷设置自定义样式 - 适配默认深色模式样式
+ (instancetype)pickerStyleWithDarkModel;

@end
