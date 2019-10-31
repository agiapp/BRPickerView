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
    /** 有圆角和边框 */
    BRBorderStyleSolid,
    /** 仅有圆角 */
    BRBorderStyleFill,
};

/// 选择器视图配置
@interface BRPickerStyle : NSObject

/** 背景遮罩视图颜色 */
@property (nonatomic, strong) UIColor *maskColor;

/** 选择器弹框顶部左右圆角的半径 */
@property (nonatomic, assign) NSInteger topCornerRadius;

/** 标题栏背景颜色 */
@property (nonatomic, strong) UIColor *titleBarColor;
/** 标题栏下边框线颜色 */
@property (nonatomic, strong) UIColor *titleLineColor;

/** 左边取消按钮背景颜色 */
@property (nonatomic, strong) UIColor *leftColor;
/** 左边取消按钮文本颜色 */
@property (nonatomic, strong) UIColor *leftTextColor;
/** 左边取消按钮文本字体 */
@property (nonatomic, strong) UIFont *leftTextFont;
/** 左边取消按钮边框样式 */
@property (nonatomic, assign) BRBorderStyle leftBorderStyle;
/** 左边取消按钮宽度 */
@property (nonatomic, assign) CGFloat leftBtnWidth;
/** 左边取消按钮图片 */
@property (nonatomic, strong) UIImage *leftBtnImage;
/** 左边取消按钮标题 */
@property (nonatomic, copy) NSString *leftBtnTitle;

/** 中间标题文本颜色 */
@property (nonatomic, strong) UIColor *titleTextColor;
/** 中间标题文本字体 */
@property (nonatomic, strong) UIFont *titleTextFont;

/** 右边确定按钮背景颜色 */
@property (nonatomic, strong) UIColor *rightColor;
/** 右边确定按钮文本颜色 */
@property (nonatomic, strong) UIColor *rightTextColor;
/** 右边确定按钮文本字体 */
@property (nonatomic, strong) UIFont *rightTextFont;
/** 右边确定按钮边框样式 */
@property (nonatomic, assign) BRBorderStyle rightBorderStyle;
/** 右边确定按钮宽度 */
@property (nonatomic, assign) CGFloat rightBtnWidth;
/** 右边确定按钮图片 */
@property (nonatomic, strong) UIImage *rightBtnImage;
/** 右边确定按钮标题 */
@property (nonatomic, copy) NSString *rightBtnTitle;

/** picker 选择器视图背景颜色 */
@property (nonatomic, strong) UIColor *pickerColor;
/** picker 中间分割线颜色 */
@property (nonatomic, strong) UIColor *separatorColor;
/** picker 中间选择文本颜色 */
@property (nonatomic, strong) UIColor *pickerTextColor;
/** picker 文本字体大小 */
@property (nonatomic, strong) UIFont *pickerTextFont;
/** picker 行高 */
@property (nonatomic, assign) CGFloat rowHeight;


/**
 *  设置语言（不设置或为nil时，将随系统的语言自动改变）
 *  language: zh-Hans（简体中文）、zh-Hant（繁体中文）、en（英语 ）
 */
@property(nonatomic, copy) NSString *language;


/// 快捷设置自定义样式 - 取消/确定按钮圆角样式
/// @param themeColor 主题颜色
+ (instancetype)pickerStyleWithThemeColor:(UIColor *)themeColor;


@end
