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

/// 地址选择器类型
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
///
///   【用法一】：推荐使用！！！
///    1. 初始化选择器（使用 initWithPickerMode: 方法）
///    2. 设置相关属性；一些公共的属性或方法参见基类文件 BRBaseView.h
///    3. 显示选择器（使用 show 方法）
///
////////////////////////////////////////////////////////////////////////*/

/** 默认选中的位置(1.传索引数组，如：@[@10, @0, @4]) */
@property (nonatomic, copy) NSArray <NSNumber *>* selectIndexs;
/** 默认选中的位置(2.传值数组，如：@[@"浙江省", @"杭州市", @"西湖区"]) */
@property (nonatomic, copy) NSArray <NSString *>* defaultSelectedArr BRPickerViewDeprecated("推荐使用 selectIndexs");

/** 选择结果的回调 */
@property (nonatomic, copy) BRAddressResultBlock resultBlock;
/**
 *  地区数据源（不传或为nil，默认就获取框架内 BRCity.json 文件的数据）
 *  1.可以传 JSON数组，要注意 层级结构 和 key 要与 BRCity.json 保持一致
 *  2.可以传 模型数组(NSArray <BRProvinceModel *>* 类型)，自己解析数据源 只需要注意层级结构就行
 */
@property (nonatomic, copy) NSArray *dataSourceArr;

/// 初始化地址选择器
/// @param pickerMode 地址选择器类型
- (instancetype)initWithPickerMode:(BRAddressPickerMode)pickerMode;

/// 弹出选择器视图
- (void)show;

/// 关闭选择器视图
- (void)dismiss;




//======================================== 华丽的分割线（以下为旧版本用法） ========================================


/**
//////////////////////////////////////////////////////////////////////////
///
///   【用法二】：快捷使用，直接选择下面其中的一个方法进行使用
///
////////////////////////////////////////////////////////////////////////*/

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
                                 resultBlock:(BRAddressResultBlock)resultBlock BRPickerViewDeprecated("请使用【用法一】，支持更多的自定义样式");

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
                          cancelBlock:(BRCancelBlock)cancelBlock BRPickerViewDeprecated("请使用【用法一】，支持更多的自定义样式");

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
                          cancelBlock:(BRCancelBlock)cancelBlock BRPickerViewDeprecated("请使用【用法一】，支持更多的自定义样式");


@end
