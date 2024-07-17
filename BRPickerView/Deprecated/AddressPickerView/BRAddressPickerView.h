//
//  BRAddressPickerView.h
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import "BRBaseView.h"
#import "BRAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 地址选择器类型
typedef NS_ENUM(NSInteger, BRAddressPickerMode) {
    /** 显示【省市区】（默认） */
    BRAddressPickerModeArea,
    /** 显示【省市】 */
    BRAddressPickerModeCity,
    /** 显示【省】 */
    BRAddressPickerModeProvince
};

typedef void(^BRAddressResultBlock)(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area);

// BRAddressPickerView 组件已废弃，请使用 BRTextPickerView 组件进行替换，具体使用请参见 README.md
//__attribute__((deprecated("Use 'BRTextPickerView' instead.")))
@interface BRAddressPickerView : BRBaseView

/**
 //////////////////////////////////////////////////////////////////////////
 ///
 ///   【用法一】
 ///    特点：灵活，扩展性强（推荐使用！）
 ///
 ////////////////////////////////////////////////////////////////////////*/

/** 地址选择器显示类型 */
@property (nonatomic, assign) BRAddressPickerMode pickerMode;

/** 默认选中的位置(1.传索引数组，如：@[@10, @0, @4]) */
@property (nullable, nonatomic, copy) NSArray <NSNumber *> *selectIndexs;
/** 默认选中的位置(2.传值数组，如：@[@"浙江省", @"杭州市", @"西湖区"]) */
@property (nullable, nonatomic, copy) NSArray <NSString *> *selectValues;

/** 选择结果的回调 */
@property (nullable, nonatomic, copy) BRAddressResultBlock resultBlock;

/** 滚动选择时触发的回调 */
@property (nullable, nonatomic, copy) BRAddressResultBlock changeBlock;

/** 判断选择器是否处于滚动中。可以用于解决快速滑动选择器，在滚动结束前秒选确定按钮，出现显示不对的问题。*/
@property (nonatomic, readonly, assign, getter=isRolling) BOOL rolling;

/**
 *  地区数据源（不传或为nil，默认就获取本地 BRCity.json 文件的数据）
 *  本地 BRCity.json 文件的数据来源于高德地图：https://restapi.amap.com/v3/config/district?key=xxxxxxxxxxxxx&subdistrict=3
 *
 *  1.可以传 JSON数组，要注意 层级结构 和 key 要与 BRCity.json 保持一致
 *  2.可以传 模型数组(NSArray <BRProvinceModel *> * 类型)，自己解析数据源 只需要注意层级结构就行
 */
@property (nullable, nonatomic, copy) NSArray *dataSourceArr;

/// 初始化地址选择器
/// @param pickerMode 地址选择器显示类型
- (instancetype)initWithPickerMode:(BRAddressPickerMode)pickerMode;

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
 *  1.显示地址选择器
 *
 *  @param selectIndexs             默认选中的值(传索引数组，如：@[@10, @0, @4])
 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithSelectIndexs:(nullable NSArray <NSNumber *> *)selectIndexs
                              resultBlock:(nullable BRAddressResultBlock)resultBlock;

/**
 *  2.显示地址选择器
 *
 *  @param mode                     地址选择器显示类型
 *  @param selectIndexs             默认选中的值(传索引数组，如：@[@10, @0, @4])
 *  @param isAutoSelect             是否自动选择，即滚动选择器后就执行结果回调，默认为 NO
 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithMode:(BRAddressPickerMode)mode
                     selectIndexs:(nullable NSArray <NSNumber *> *)selectIndexs
                     isAutoSelect:(BOOL)isAutoSelect
                      resultBlock:(nullable BRAddressResultBlock)resultBlock;

/**
 *  3.显示地址选择器
 *
 *  @param mode                     地址选择器显示类型
 *  @param dataSource               地区数据源
 *  @param selectIndexs             默认选中的值(传索引数组，如：@[@10, @0, @4])
 *  @param isAutoSelect             是否自动选择，即滚动选择器后就执行结果回调，默认为 NO
 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithMode:(BRAddressPickerMode)mode
                       dataSource:(nullable NSArray *)dataSource
                     selectIndexs:(nullable NSArray <NSNumber *> *)selectIndexs
                     isAutoSelect:(BOOL)isAutoSelect
                      resultBlock:(nullable BRAddressResultBlock)resultBlock;


@end

NS_ASSUME_NONNULL_END
