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

typedef void(^BRCancelBlock)(void);
typedef void(^BRResultBlock)(void);

@interface BRBaseView : UIView

/** 选择器标题 */
@property (nonatomic, copy) NSString *title;

/** 是否自动选择，即滚动选择器后就执行结果回调，默认为 NO */
@property (nonatomic, assign) BOOL isAutoSelect;

/** 自定义UI样式（不传或为nil时，是默认样式） */
@property (nonatomic, strong) BRPickerStyle *pickerStyle;

/** 取消选择的回调 */
@property (nonatomic, copy) BRCancelBlock cancelBlock;

/** 选择结果的回调（框架内部使用） */
@property (nonatomic, copy) BRResultBlock doneBlock;


/// 扩展一：添加选择器到指定容器视图上
/// 应用场景：可将选择器（pickerView，不包含标题栏）添加到任何自定义视图上，也支持自定义更多的弹框样式
/// @param view 容器视图
- (void)addPickerToView:(UIView *)view;

/// 从指定容器视图上移除选择器
/// @param view 容器视图
- (void)removePickerFromView:(UIView *)view;

/// 扩展二：添加自定义视图到选择器（pickerView）上
/// 应用场景：可以添加一些固定的标题、数值的单位等到选择器中间
/// @param customView 自定义视图
- (void)addSubViewToPicker:(UIView *)customView;

/// 扩展三：添加自定义视图到标题栏（titleBarView）上
/// 应用场景：先自定义标题栏高度，再添加一些固定的标题等到标题栏底部
/// @param customView 自定义视图
- (void)addSubViewToTitleBar:(UIView *)customView;

/// 添加 pickerView 到 alertView（框架内部使用）
/// @param pickerView 选择器视图
/// @param view 容器视图
- (void)setPickerView:(UIView *)pickerView toView:(UIView *)view;


@end
