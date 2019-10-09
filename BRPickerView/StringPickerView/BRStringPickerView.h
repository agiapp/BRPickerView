//
//  BRStringPickerView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRBaseView.h"

typedef void(^BRStringResultBlock)(id selectValue);
typedef void(^BRStringCancelBlock)(void);

@interface BRStringPickerView : BRBaseView

/**
 ////////////////////////////////////////////////////////////////////////
 ///   【使用方式一】：传统的创建对象设置属性方式，好处是避免使用方式二导致参数过多
 ///    1. 初始化选择器（使用 initWithDataSource: 方法）
 ///    2. 设置相关属性
 ///    3. 显示选择器（使用 showWithAnimation: 方法）
 //////////////////////////////////////////////////////////////////////*/

/** 选择器标题 */
@property (nonatomic, strong) NSString *title;
/** 默认选中的行(单列传字符串，多列传一维数组) */
@property (nonatomic, strong) id defaultSelValue;
/** 是否自动选择，即选择完(滚动完)执行结果回调，默认为NO */
@property (nonatomic, assign) BOOL isAutoSelect;

/** 选择结果的回调 */
@property (nonatomic, copy) BRStringResultBlock resultBlock;
/** 取消选择的回调 */
@property (nonatomic, copy) BRStringCancelBlock cancelBlock;

/// 初始化字符串选择器
/// @param dataSource 数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
/// @param customStyle 自定义UI样式（可为空，为nil时是默认样式）
- (instancetype)initWithDataSource:(id)dataSource customStyle:(BRPickerStyle *)customStyle;


/// 弹出视图方法
/// @param animation 是否开启动画
- (void)showWithAnimation:(BOOL)animation;

/// 关闭视图方法
/// @param animation 是否开启动画
- (void)dismissWithAnimation:(BOOL)animation;


/**
//////////////////////////////////////////////////////////////
///   【使用方式二】：快捷使用，直接选择下面其中的一个方法进行使用
//////////////////////////////////////////////////////////////*/

/**
 *  1.显示自定义字符串选择器
 *
 *  @param title            标题
 *  @param dataSource       数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                      resultBlock:(BRStringResultBlock)resultBlock;

/**
 *  2.显示自定义字符串选择器（支持 设置自动选择 和 自定义主题颜色）
 *
 *  @param title            标题
 *  @param dataSource       数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                       themeColor:(UIColor *)themeColor
                      resultBlock:(BRStringResultBlock)resultBlock BRPickerViewDeprecated("过期提醒：推荐【使用方式一】，支持自定义UI样式");

/**
 *  3.显示自定义字符串选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param title            标题
 *  @param dataSource       数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择后的回调
 *  @param cancelBlock      取消选择的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                       themeColor:(UIColor *)themeColor
                      resultBlock:(BRStringResultBlock)resultBlock
                      cancelBlock:(BRStringCancelBlock)cancelBlock BRPickerViewDeprecated("过期提醒：推荐【使用方式一】，支持自定义UI样式");


@end
