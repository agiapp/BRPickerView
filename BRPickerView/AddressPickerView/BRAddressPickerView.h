//
//  BRAddressPickerView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRBaseView.h"
#import "BRAddressModel.h"

typedef NS_ENUM(NSInteger, BRAddressPickerMode) {
    // 只显示省
    BRAddressPickerModeProvince = 1,
    // 显示省市
    BRAddressPickerModeCity,
    // 显示省市区（默认）
    BRAddressPickerModeArea
};

typedef void(^BRAddressResultBlock)(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area);
typedef void(^BRAddressCancelBlock)(void);

@class BRPickerStyle;
@interface BRAddressPickerView : BRBaseView

/**
 ////////////////////////////////////////////////////////////////////////
 ///   【使用方式一】：传统的创建对象设置属性方式，好处是避免使用方式二导致参数过多
 ///    1. 初始化选择器（使用 initWithPickerMode: 方法）
 ///    2. 设置相关属性
 ///    3. 显示选择器（使用 showWithAnimation: 方法）
 //////////////////////////////////////////////////////////////////////*/

/** 选择器标题 */
@property (nonatomic, strong) NSString *title;
/** 地区数据源 */
@property (nonatomic, strong) NSArray *dataSource;
/** 默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"]) */
@property (nonatomic, strong) NSArray *defaultSelectedArr;
/** 是否自动选择，即选择完(滚动完)执行结果回调 */
@property (nonatomic, assign) BOOL isAutoSelect;

/** 自定义UI样式 */
@property (nonatomic, strong) BRPickerStyle *pickerStyle;

/** 选择结果的回调 */
@property (nonatomic, copy) BRAddressResultBlock resultBlock;
/** 取消选择的回调 */
@property (nonatomic, copy) BRAddressCancelBlock cancelBlock;

/// 初始化方法
/// @param pickerMode 地址选择器类型
- (instancetype)initWithPickerMode:(BRAddressPickerMode)pickerMode;


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
 *  1.显示地址选择器
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                 resultBlock:(BRAddressResultBlock)resultBlock;

/**
 *  2.显示地址选择器（支持 设置自动选择 和 自定义主题颜色）
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor               自定义主题颜色
 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                  themeColor:(UIColor *)themeColor
                                 resultBlock:(BRAddressResultBlock)resultBlock BRPickerViewDeprecated("过期提醒：推荐【使用方式一】，支持自定义UI样式");

/**
 *  3.显示地址选择器（支持 设置选择器类型、设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param showType                 地址选择器显示类型
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor               自定义主题颜色
 *  @param resultBlock              选择后的回调
 *  @param cancelBlock              取消选择的回调
 *
 */
+ (void)showAddressPickerWithShowType:(BRAddressPickerMode)showType
                      defaultSelected:(NSArray *)defaultSelectedArr
                         isAutoSelect:(BOOL)isAutoSelect
                           themeColor:(UIColor *)themeColor
                          resultBlock:(BRAddressResultBlock)resultBlock
                          cancelBlock:(BRAddressCancelBlock)cancelBlock BRPickerViewDeprecated("过期提醒：推荐【使用方式一】，支持自定义UI样式");

/**
 *  4.显示地址选择器（支持 设置选择器类型、传入地区数据源、设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param showType                 地址选择器显示类型
 *  @param dataSource               地区数据源
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor               自定义主题颜色
 *  @param resultBlock              选择后的回调
 *  @param cancelBlock              取消选择的回调
 *
 */
+ (void)showAddressPickerWithShowType:(BRAddressPickerMode)showType
                           dataSource:(NSArray *)dataSource
                      defaultSelected:(NSArray *)defaultSelectedArr
                         isAutoSelect:(BOOL)isAutoSelect
                           themeColor:(UIColor *)themeColor
                          resultBlock:(BRAddressResultBlock)resultBlock
                          cancelBlock:(BRAddressCancelBlock)cancelBlock BRPickerViewDeprecated("过期提醒：推荐【使用方式一】，支持自定义UI样式");

@end
