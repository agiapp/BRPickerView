//
//  BRMutableDatePickerView.h
//  BRPickerViewDemo
//
//  Created by renbo on 2019/12/5.
//  Copyright © 2019 irenb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BRDateResultBlock)(NSDate *selectDate, NSString *selectValue, BOOL hiddenMonth, BOOL hiddenDay);

@interface BRMutableDatePickerView : UIView

/** 选择器标题 */
@property (nonatomic, copy) NSString *title;

/** 是否自动选择，即滚动选择器后就执行结果回调，默认为 NO */
@property (nonatomic, assign) BOOL isAutoSelect;

/** 设置默认选中的日期（不设置或为nil时，默认就选中当前日期）*/
@property (nonatomic, strong) NSDate *selectDate;

/** 最小日期（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）*/
@property (nonatomic, strong) NSDate *minDate;
/** 最大日期（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）*/
@property (nonatomic, strong) NSDate *maxDate;

/** 隐藏日期单位，默认为NO */
@property (nonatomic, assign) BOOL hiddenDateUnit;

/** 是否隐藏【月】，默认为 NO */
@property (nonatomic, assign) BOOL hiddenMonth;
/** 是否隐藏【日】，默认为 NO */
@property (nonatomic, assign) BOOL hiddenDay;

/** 选择结果的回调 */
@property (nonatomic, copy) BRDateResultBlock resultBlock;

/// 弹出选择器视图
- (void)show;

/// 关闭选择器视图
- (void)dismiss;

@end
