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

@interface BRAddressPickerView : BRBaseView

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
                                 resultBlock:(BRAddressResultBlock)resultBlock;

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
                          cancelBlock:(BRAddressCancelBlock)cancelBlock;

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
                          cancelBlock:(BRAddressCancelBlock)cancelBlock;

@end
