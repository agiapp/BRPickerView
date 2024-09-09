//
//  BRTextModel.h
//  BRPickerViewDemo
//
//  Created by renbo on 2019/10/2.
//  Copyright © 2019 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRTextModel : NSObject
/** code */
@property (nullable, nonatomic, copy) NSString *code;
/** text */
@property (nullable, nonatomic, copy) NSString *text;
/** 子级 list */
@property (nullable, nonatomic, copy) NSArray<BRTextModel *> *children;
/** 父级 code */
@property (nonatomic, strong) NSString *parentCode;
/** 其它扩展字段 */
@property (nullable, nonatomic, strong) id extras;
/** 记录选择的索引位置 */
@property (nonatomic, assign) NSInteger index;

/** 字典 转 模型 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end


/// 工具方法
@interface NSArray (BRPickerView)

/// 数组 转 模型数组
/// - Parameters:
///   - dataArr: 字典数组
///   - mapper: 指定 BRTextModel模型的属性 与 字典key 的映射关系
+ (NSArray *)br_modelArrayWithJson:(NSArray *)dataArr mapper:(nullable NSDictionary *)mapper;

/// 获取模型数组元素，指定属性的值组成新数组
/// - Parameter propertyName: 模型的属性名称
- (NSArray *)br_getValueArr:(NSString *)propertyName;

/// 将模型数组元素，指定属性连接成字符串
/// - Parameters:
///   - propertyName: 模型的属性名称
///   - separator: 分隔符
- (NSString *)br_joinValue:(NSString *)propertyName separator:(NSString *)separator;

/// 将模型数组元素的 text 属性，连接成字符串
/// - Parameter separator: 分隔符
- (NSString *)br_joinText:(NSString *)separator;

/// 将扁平结构模型数组 转换成 树状结构模型数组
- (NSArray<BRTextModel *> *)br_buildTreeArray;

@end

NS_ASSUME_NONNULL_END
