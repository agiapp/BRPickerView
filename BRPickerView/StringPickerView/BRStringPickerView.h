//
//  BRStringPickerView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRBaseView.h"
#import "BRResultModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 字符串选择器类型
typedef NS_ENUM(NSInteger, BRStringPickerMode) {
    /** 单列字符串选择 */
    BRStringPickerComponentSingle,
    /** 多列字符串选择（两列及两列以上） */
    BRStringPickerComponentMulti
};

typedef void(^BRStringResultModelBlock)(BRResultModel * _Nullable resultModel);

typedef void(^BRStringResultModelArrayBlock)(NSArray <BRResultModel *> * _Nullable resultModelArr);

@interface BRStringPickerView : BRBaseView

/**
 //////////////////////////////////////////////////////////////////////////
 ///
 ///   【用法一】
 ///    特点：灵活，扩展性强（推荐使用！）
 ///
 ////////////////////////////////////////////////////////////////////////*/

/** 字符串选择器显示类型 */
@property (nonatomic, assign) BRStringPickerMode pickerMode;

/**
 *  1.设置数据源
 *    单列：@[@"男", @"女", @"其他"]，或直接传模型数组（NSArray <BRResultModel *>* dataSourceArr）
 *    两列：@[@[@"语文", @"数学", @"英语"], @[@"优秀", @"良好", @"及格"]]，或直接传模型数组
 *    多列：... ...
 */
@property (nullable, nonatomic, copy) NSArray *dataSourceArr;
/**
 *  2.设置数据源
 *    直接传plist文件名：NSString类型（如：@"test.plist"），要带后缀名
 *    场景：可以将数据源数据（数组类型）放到plist文件中，直接传plist文件名更加简单
 */
@property (nullable, nonatomic, copy) NSString *plistName;

/** 设置默认选中的位置【单列】 */
@property (nonatomic, assign) NSInteger selectIndex;
@property (nullable, nonatomic, copy) NSString *selectValue BRPickerViewDeprecated("Use `selectIndex` instead");

/** 设置默认选中的位置【多列】 */
@property (nullable, nonatomic, copy) NSArray <NSNumber *> *selectIndexs;
@property (nullable, nonatomic, copy) NSArray <NSString *> *selectValues BRPickerViewDeprecated("Use `selectIndexs` instead");

/** 选择结果的回调【单列】 */
@property (nullable, nonatomic, copy) BRStringResultModelBlock resultModelBlock;
/** 选择结果的回调【多列】 */
@property (nullable, nonatomic, copy) BRStringResultModelArrayBlock resultModelArrayBlock;

/** 滚动选择时触发的回调【单列】 */
@property (nullable, nonatomic, copy) BRStringResultModelBlock changeModelBlock;
/** 滚动选择时触发的回调【多列】 */
@property (nullable, nonatomic, copy) BRStringResultModelArrayBlock changeModelArrayBlock;

/// 初始化字符串选择器
/// @param pickerMode 字符串选择器显示类型
- (instancetype)initWithPickerMode:(BRStringPickerMode)pickerMode;

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
 *  1.显示【单列】字符串选择器
 *
 *  @param title               选择器标题
 *  @param dataSourceArr       数据源（如：@[@"男", @"女", @"其他"]，或直接传模型数组）
 *  @param selectIndex         默认选中的位置
 *  @param resultBlock         选择后的回调
 *
 */
+ (void)showPickerWithTitle:(nullable NSString *)title
              dataSourceArr:(nullable NSArray *)dataSourceArr
                selectIndex:(NSInteger)selectIndex
                resultBlock:(nullable BRStringResultModelBlock)resultBlock;

/**
 *  2.显示【单列】字符串选择器
 *
 *  @param title               选择器标题
 *  @param dataSourceArr       数据源（如：@[@"男", @"女", @"其他"]，或直接传模型数组）
 *  @param selectIndex         默认选中的位置
 *  @param isAutoSelect        是否自动选择，即滚动选择器后就执行结果回调，默认为 NO
 *  @param resultBlock         选择后的回调
 *
 */
+ (void)showPickerWithTitle:(nullable NSString *)title
              dataSourceArr:(nullable NSArray *)dataSourceArr
                selectIndex:(NSInteger)selectIndex
               isAutoSelect:(BOOL)isAutoSelect
                resultBlock:(nullable BRStringResultModelBlock)resultBlock;

/**
 *  3.显示【多列】字符串选择器
 *
 *  @param title               选择器标题
 *  @param dataSourceArr       数据源（如：@[@[@"语文", @"数学", @"英语"], @[@"优秀", @"良好", @"及格"]]，或直接传模型数组）
 *  @param selectIndexs        默认选中的位置（传索引数组，如：@[@2, @1]）
 *  @param resultBlock         选择后的回调
 *
 */
+ (void)showMultiPickerWithTitle:(nullable NSString *)title
                   dataSourceArr:(nullable NSArray *)dataSourceArr
                    selectIndexs:(nullable NSArray <NSNumber *> *)selectIndexs
                     resultBlock:(nullable BRStringResultModelArrayBlock)resultBlock;

/**
 *  4.显示【多列】字符串选择器
 *
 *  @param title               选择器标题
 *  @param dataSourceArr       数据源（如：@[@[@"语文", @"数学", @"英语"], @[@"优秀", @"良好", @"及格"]]，或直接传模型数组）
 *  @param selectIndexs        默认选中的位置（传索引数组，如：@[@2, @1]）
 *  @param isAutoSelect        是否自动选择，即滚动选择器后就执行结果回调，默认为 NO
 *  @param resultBlock         选择后的回调
 *
 */
+ (void)showMultiPickerWithTitle:(nullable NSString *)title
                   dataSourceArr:(nullable NSArray *)dataSourceArr
                    selectIndexs:(nullable NSArray <NSNumber *> *)selectIndexs
                    isAutoSelect:(BOOL)isAutoSelect
                     resultBlock:(nullable BRStringResultModelArrayBlock)resultBlock;


@end

NS_ASSUME_NONNULL_END
