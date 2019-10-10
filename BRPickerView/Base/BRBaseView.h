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

@interface BRBaseView : UIView

/** 选择器标题 */
@property (nonatomic, strong) NSString *title;

/** 自定义UI样式（可为空，为nil时是默认样式） */
@property (nonatomic, strong) BRPickerStyle *pickerStyle;

/** 取消选择的回调 */
@property (nonatomic, copy) BRCancelBlock cancelBlock;

/** 确定按钮的点击事件 */
- (void)clickRightBtn;

/// 弹出视图方法
/// @param animation 是否开启动画
- (void)showWithAnimation:(BOOL)animation;

/// 关闭视图方法
/// @param animation 是否开启动画
- (void)dismissWithAnimation:(BOOL)animation;

- (void)addPickerView:(UIView *)view;

@end
