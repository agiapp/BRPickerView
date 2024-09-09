//
//  BRPickerAlertView.h
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import <UIKit/UIKit.h>
#import "BRPickerStyle.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^BRPickerAlertCancelBlock)(void);
typedef void(^BRPickerAlertDoneBlock)(void);

@interface BRPickerAlertView : UIView

/** 选择器标题 */
@property (nullable, nonatomic, copy) NSString *title;

/** 自定义UI样式（不传或为nil时，是默认样式） */
@property (nullable, nonatomic, strong) BRPickerStyle *pickerStyle;

/** accessory view for above picker view. default is nil */
@property (nullable, nonatomic, strong) UIView *pickerHeaderView;

/** accessory view below picker view. default is nil */
@property (nullable, nonatomic, strong) UIView *pickerFooterView;

/** 取消选择的回调 */
@property (nullable, nonatomic, copy) BRPickerAlertCancelBlock cancelBlock;

/// 确定按钮点击事件的回调
/// 应用场景：如果是自定义确定按钮，需要在该按钮点击事件方法里，执行一下 doneBlock 回调。目的是触发组件内部执行 resultBlock 回调，回调选择的值
@property (nullable, nonatomic, copy) BRPickerAlertDoneBlock doneBlock;

/** 弹框视图(使用场景：可以在 alertView 上添加选择器的自定义背景视图) */
@property (nullable, nonatomic, strong) UIView *alertView;

/** 组件的父视图：可以传 自己获取的 keyWindow，或页面的 view */
@property (nullable, nonatomic, strong) UIView *keyView;


/// 刷新选择器数据
/// 应用场景：动态更新数据源、动态更新选择的值、选择器类型切换等
- (void)reloadData;

/// 扩展一：添加选择器到指定容器视图上
/// 应用场景：可将中间的滚轮选择器 pickerView 视图（不包含蒙层及标题栏）添加到任何自定义视图上（会自动填满容器视图），也方便自定义更多的弹框样式
/// 补充说明：如果是自定义确定按钮，需要回调默认选择的值：只需在自定义确定按钮的点击事件方法里执行一下 doneBlock 回调（目的是去触发组件内部执行 resultBlock 回调，进而回调默认选择的值）
/// @param view 容器视图
- (void)addPickerToView:(nullable UIView *)view NS_REQUIRES_SUPER;

/// 从指定容器视图上移除选择器
/// @param view 容器视图
- (void)removePickerFromView:(nullable UIView *)view;

/// 扩展二：添加自定义视图到选择器（pickerView）上
/// 应用场景：可以添加一些固定的标题、单位等到选择器中间
/// @param customView 自定义视图
- (void)addSubViewToPicker:(UIView *)customView;

/// 扩展三：添加自定义视图到标题栏（titleBarView）上
/// 应用场景：可以添加一些子控件到标题栏
/// @param customView 自定义视图
- (void)addSubViewToTitleBar:(UIView *)customView;


@end

NS_ASSUME_NONNULL_END
