//
//  BRDatePickerView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRBaseView.h"
#import "NSDate+BRPickerView.h"

/// 日期选择器格式
typedef NS_ENUM(NSInteger, BRDatePickerMode) {
    // ----- 以下4种是系统自带的样式 -----
    /** 【HH:mm】UIDatePickerModeTime */
    BRDatePickerModeTime = 1,
    /** 【yyyy-MM-dd】UIDatePickerModeDate */
    BRDatePickerModeDate,
    /** 【yyyy-MM-dd HH:mm】 UIDatePickerModeDateAndTime */
    BRDatePickerModeDateAndTime,
    /** 【HH:mm】UIDatePickerModeCountDownTimer */
    BRDatePickerModeCountDownTimer,
    
    // ----- 以下11种是自定义样式 -----
    /** 【yyyy-MM-dd HH:mm:ss】年月日时分秒 */
    BRDatePickerModeYMDHMS,
    /** 【yyyy-MM-dd HH:mm】年月日时分 */
    BRDatePickerModeYMDHM,
    /** 【yyyy-MM-dd HH】年月日时 */
    BRDatePickerModeYMDH,
    /** 【MM-dd HH:mm】月日时分 */
    BRDatePickerModeMDHM,
    /** 【yyyy-MM-dd】年月日 */
    BRDatePickerModeYMD,
    /** 【yyyy-MM】年月 */
    BRDatePickerModeYM,
    /** 【yyyy】年 */
    BRDatePickerModeY,
    /** 【MM-dd】月日 */
    BRDatePickerModeMD,
    /** 【HH:mm:ss】时分秒 */
    BRDatePickerModeHMS,
    /** 【HH:mm】时分 */
    BRDatePickerModeHM,
    /** 【mm:ss】分秒 */
    BRDatePickerModeMS
};

typedef void (^BRDateResultBlock)(NSDate *selectDate, NSString *selectValue);

@interface BRDatePickerView : BRBaseView

/**
 //////////////////////////////////////////////////////////////////////////
 ///
 ///   【用法一】
 ///    特点：灵活，扩展性强（推荐使用！）
 ///    使用：
 ///         1. 初始化选择器（使用 initWithPickerMode: 方法）
 ///         2. 设置相关属性；一些公共的属性或方法参见基类文件 BRBaseView.h
 ///         3. 显示选择器（使用 show 方法）
 ///
 ////////////////////////////////////////////////////////////////////////*/

/** 设置默认选中的时间（不设置或为nil时，默认就选中当前时间）*/
@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, copy) NSString *selectValue;  // 推荐使用 selectDate

/** 最小时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）*/
@property (nonatomic, strong) NSDate *minDate;
/** 最大时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）*/
@property (nonatomic, strong) NSDate *maxDate;

/** 隐藏日期单位，默认为NO（值为YES时，配合 addSubViewToPicker: 方法，可以自定义单位的显示样式）*/
@property (nonatomic, assign) BOOL hiddenDateUnit;

/** 是否显示【星期】，默认为 NO  */
@property (nonatomic, assign, getter=isShowWeek) BOOL showWeek;

/** 是否显示【今天】，默认为 NO  */
@property (nonatomic, assign, getter=isShowToday) BOOL showToday;

/** 是否添加【至今】，默认为 NO */
@property (nonatomic, assign, getter=isAddToNow) BOOL addToNow;

/** 选择结果的回调 */
@property (nonatomic, copy) BRDateResultBlock resultBlock;

/// 初始化时间选择器
/// @param pickerMode  日期选择器类型
- (instancetype)initWithPickerMode:(BRDatePickerMode)pickerMode;

/// 弹出选择器视图
- (void)show;

/// 关闭选择器视图
- (void)dismiss;





//================================================= 华丽的分割线 =================================================





/**
 //////////////////////////////////////////////////////////////////////////
 ///
 ///   【用法二】：快捷使用，直接选择下面其中的一个方法进行使用
 ///    特点：快捷，方便
 ///
 ////////////////////////////////////////////////////////////////////////*/

/**
 *  1.显示时间选择器
 *
 *  @param mode             日期显示类型
 *  @param selectValue      默认选中的时间（值为空/值格式错误时，默认就选中现在的时间）
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithMode:(BRDatePickerMode)mode
                   selectValue:(NSString *)selectValue
                   resultBlock:(BRDateResultBlock)resultBlock;

/**
 *  2.显示时间选择器
 *
 *  @param mode             日期显示类型
 *  @param title            选择器标题
 *  @param selectValue      默认选中的时间（值为空/值格式错误时，默认就选中现在的时间）
 *  @param isAutoSelect     是否自动选择，即滚动选择器后就执行结果回调，默认为 NO
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithMode:(BRDatePickerMode)mode
                         title:(NSString *)title
                   selectValue:(NSString *)selectValue
                  isAutoSelect:(BOOL)isAutoSelect
                   resultBlock:(BRDateResultBlock)resultBlock;

/**
 *  3.显示时间选择器
 *
 *  @param mode             日期显示类型
 *  @param title            选择器标题
 *  @param selectValue      默认选中的时间（值为空/值格式错误时，默认就选中现在的时间）
 *  @param minDate          最小时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）
 *  @param maxDate          最大时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）
 *  @param isAutoSelect     是否自动选择，即滚动选择器后就执行结果回调，默认为 NO
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithMode:(BRDatePickerMode)mode
                         title:(NSString *)title
                   selectValue:(NSString *)selectValue
                       minDate:(NSDate *)minDate
                       maxDate:(NSDate *)maxDate
                  isAutoSelect:(BOOL)isAutoSelect
                   resultBlock:(BRDateResultBlock)resultBlock;

@end
