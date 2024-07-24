//
//  BRTextPickerView.h
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import "BRPickerAlertView.h"
#import "BRTextModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 文本选择器类型
typedef NS_ENUM(NSInteger, BRTextPickerMode) {
    /** 单列选择器 */
    BRTextPickerComponentSingle,
    /** 多列选择器 */
    BRTextPickerComponentMulti,
    /** 多列联动选择器 */
    BRTextPickerComponentCascade
};

typedef void(^BRSingleResultBlock)(BRTextModel * _Nullable model, NSInteger index);

typedef void(^BRMultiResultBlock)(NSArray <BRTextModel *> * _Nullable models, NSArray<NSNumber *> * _Nullable indexs);

@interface BRTextPickerView : BRPickerAlertView

/**
 ////////////////////////////////////////////////////////////////////////// *
 ///
 ///   【用法一】
 ///    特点：灵活，扩展性强（推荐使用！）
 ///
 ////////////////////////////////////////////////////////////////////////*/

/** 文本选择器显示类型 */
@property (nonatomic, assign) BRTextPickerMode pickerMode;

/**
 *  1.设置数据源
 *    单列：@[@"男", @"女", @"其他"]，或直接传一维模型数组(NSArray <BRTextModel *>*)
 *    多列：@[@[@"语文", @"数学", @"英语"], @[@"优秀", @"良好"]]，或直接传多维模型数组
 *
 *    联动：传树状结构模型数组(NSArray <BRTextModel *>*)，对应的 JSON 基本数据格式如下：
 
     [
       {
         "text" : "北京市",
         "children" : [
             { "text": "北京城区", "children": [{ "text": "东城区" }, { "text": "西城区" }] }
         ]
       },
       {
         "text" : "浙江省",
         "children" : [
             { "text": "杭州市", "children": [{ "text": "西湖区" }, { "text": "滨江区" }] },
             { "text": "宁波市", "children": [{ "text": "海曙区" }, { "text": "江北区" }] }
         ]
       }
     ]

    提示：可以使用下面方法，把上面的 JSON 数据 转成 模型数组
    dataSourceArr = [NSArray br_modelArrayWithJson:dataArr mapper:nil];
 */
@property (nullable, nonatomic, copy) NSArray *dataSourceArr;
/**
 *  2.设置数据源（传本地文件名，支持 plist/json 文件）
 *    ① 对于单列/多列选择器：可以直接传 plist 文件名（如：@"education_data.plist"，要带后缀名）
 *    ② 对于多列联动选择器：可以直接传 JSON 文件名（如：@"region_tree_data.json"，要带后缀名），另外要注意JSON数据源的格式（参考上面设置数据源）
 *
 *    场景：可以将数据源数据（数组/JSON格式数据）放到 plist/json 文件中，直接传文件名更加简单
 */
@property (nullable, nonatomic, copy) NSString *fileName;

/** 设置默认选中的位置【单列】*/
@property (nonatomic, assign) NSInteger selectIndex;
/** 设置默认选中的位置【多列】*/
@property (nullable, nonatomic, copy) NSArray <NSNumber *> *selectIndexs;

/** 滚动选择时，触发的回调【单列】 */
@property (nullable, nonatomic, copy) BRSingleResultBlock singleChangeBlock;
/** 滚动选择时，触发的回调【多列】 */
@property (nullable, nonatomic, copy) BRMultiResultBlock multiChangeBlock;

/** 点击确定时，触发的回调【单列】 */
@property (nullable, nonatomic, copy) BRSingleResultBlock singleResultBlock;
/** 点击确定时，触发的回调【多列】 */
@property (nullable, nonatomic, copy) BRMultiResultBlock multiResultBlock;

/** 判断选择器是否处于滚动中。可以用于解决快速滑动选择器，在滚动结束前秒选确定按钮，出现显示不对的问题 */
@property (nonatomic, readonly, assign, getter=isRolling) BOOL rolling;

/** 设置选择器显示的列数(即层级数)，默认是根据数据源层级动态计算显示 */
@property (nonatomic, assign) NSUInteger showColumnNum;

/** 滚动至选择行动画，默认为 NO */
@property (nonatomic, assign) BOOL selectRowAnimated;

/// 初始化文本选择器
/// @param pickerMode 文本选择器显示类型
- (instancetype)initWithPickerMode:(BRTextPickerMode)pickerMode;

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
 *  1.显示【单列】选择器
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
                 resultBlock:(nullable BRSingleResultBlock)resultBlock;

/**
 *  2.显示【多列】选择器
 *
 *  @param title               选择器标题
 *  @param dataSourceArr       数据源，格式：@[@[@"语文", @"数学", @"英语"], @[@"优秀", @"良好"]]，或直接传多维模型数组
 *  @param selectIndexs        默认选中的位置（传索引数组，如：@[@2, @1]）
 *  @param resultBlock         选择后的回调
 *
 */
+ (void)showMultiPickerWithTitle:(nullable NSString *)title
                   dataSourceArr:(nullable NSArray *)dataSourceArr
                    selectIndexs:(nullable NSArray <NSNumber *> *)selectIndexs
                     resultBlock:(nullable BRMultiResultBlock)resultBlock;

/**
 *  3.显示【联动】选择器
 *
 *  @param title               选择器标题
 *  @param dataSourceArr       数据源，格式：直接传一维模型数组(NSArray <BRTextModel *>*)
 *  @param selectIndexs        默认选中的位置（传索引数组，如：@[@2, @1]）
 *  @param resultBlock         选择后的回调
 *
 */
+ (void)showCascadePickerWithTitle:(nullable NSString *)title
                     dataSourceArr:(nullable NSArray *)dataSourceArr
                      selectIndexs:(nullable NSArray <NSNumber *> *)selectIndexs
                       resultBlock:(nullable BRMultiResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
