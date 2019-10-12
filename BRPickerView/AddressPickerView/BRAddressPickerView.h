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
    /** 显示【省市区】（默认） */
    BRAddressPickerModeArea = 1,
    /** 显示【省市】 */
    BRAddressPickerModeCity,
    /** 显示【省】 */
    BRAddressPickerModeProvince
};

typedef void(^BRAddressResultBlock)(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area);

@interface BRAddressPickerView : BRBaseView

/**
 //////////////////////////////////////////////////////////////////////////
 ///   【使用方式一】：传统的创建对象设置属性方式，好处是避免使用方式二导致方法参数过多
 ///    1. 初始化选择器（使用 initWithPickerMode: 方法）
 ///    2. 设置相关属性；一些公共的属性参见基类文件 BRBaseView.h
 ///    3. 显示选择器（使用 show 方法）
 ////////////////////////////////////////////////////////////////////////*/

/** 默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"]) */
@property (nonatomic, strong) NSArray *defaultSelectedArr;
/** 是否自动选择，即选择完(滚动完)执行结果回调，默认为NO */
@property (nonatomic, assign) BOOL isAutoSelect;

/** 选择结果的回调 */
@property (nonatomic, copy) BRAddressResultBlock resultBlock;

/**
 *  地区数据源（不传默认就获取框架内 BRCity.json 文件的数据）
 *  可以传 JSON数组 或 模型数组(NSArray <BRProvinceModel *>*)，要注意JSON结构与BRCity.json保持一致
 */
@property (nonatomic, strong) NSArray *dataSourceArr;


/// 初始化地址选择器
/// @param pickerMode 地址选择器类型
- (instancetype)initWithPickerMode:(BRAddressPickerMode)pickerMode;

/// 弹出选择器视图
- (void)show;

/// 关闭选择器视图
- (void)dismiss;

/// 添加选择器到指定容器视图上
/// @param view 容器视图
- (void)addPickerToView:(UIView *)view;

/// 从指定容器视图上移除选择器
/// @param view 容器视图
- (void)removePickerFromView:(UIView *)view;



/**
//////////////////////////////////////////////////////////////////
///   【使用方式二】：快捷使用，直接选择下面其中的一个方法进行使用
////////////////////////////////////////////////////////////////*/

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
                          cancelBlock:(BRCancelBlock)cancelBlock BRPickerViewDeprecated("过期提醒：推荐【使用方式一】，支持自定义UI样式");

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
                          cancelBlock:(BRCancelBlock)cancelBlock BRPickerViewDeprecated("过期提醒：推荐【使用方式一】，支持自定义UI样式");


@end
