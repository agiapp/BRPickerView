//
//  BaseView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import <UIKit/UIKit.h>
#import "BRPickerStyle.h"

#define BRPickerViewDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

typedef void(^BRCancelBlock)(void);
typedef void(^BRResultBlock)(void);

@interface BRBaseView : UIView

/** 选择器标题 */
@property (nonatomic, strong) NSString *title;
/** 左边按钮标题 */
@property (nonatomic, strong) NSString *leftBtnTitle;
/** 右边按钮标题 */
@property (nonatomic, strong) NSString *rightBtnTitle;

/** 自定义UI样式（可为空，为nil时是默认样式） */
@property (nonatomic, strong) BRPickerStyle *pickerStyle;

/** 取消选择的回调 */
@property (nonatomic, copy) BRCancelBlock cancelBlock;


/** 选择结果的回调（框架内部使用，不推荐使用） */
@property (nonatomic, copy) BRResultBlock doneBlock;


/// 添加选择器到指定容器视图上
/// @param view 容器视图
- (void)addPickerToView:(UIView *)view;

/// 从指定容器视图上移除选择器
/// @param view 容器视图
- (void)removePickerFromView:(UIView *)view;



/// 设置选择器视图（框架内部使用，不推荐使用）
/// @param pickerView 选择器视图
/// @param view 容器视图
- (void)setPickerView:(UIView *)pickerView toView:(UIView *)view;


@end
