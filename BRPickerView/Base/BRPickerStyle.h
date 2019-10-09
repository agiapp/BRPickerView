//
//  BRPickerStyle.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2019/10/2.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 选择器视图样式
@interface BRPickerStyle : NSObject

/** 背景遮罩视图颜色 */
@property (nonatomic, strong) UIColor *maskColor;
/** picker选择器视图颜色 */
@property (nonatomic, strong) UIColor *pickerColor;




/** 工具条标题颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineColor;

@end
