//
//  BRResultModel.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2019/10/2.
//  Copyright © 2019年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import <Foundation/Foundation.h>
#import "BRPickerViewMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRResultModel : NSObject
/** 父级key */
@property (nullable, nonatomic, copy) NSString *parentKey;
/** 父级value */
@property (nullable, nonatomic, copy) NSString *parentValue;
/** key */
@property (nullable, nonatomic, copy) NSString *key;
/** value */
@property (nullable, nonatomic, copy) NSString *value;
/** 简称 */
@property (nullable, nonatomic, copy) NSString *shortName;
/** 备注 */
@property (nullable, nonatomic, copy) NSString *remark;
/** 索引 */
@property (nonatomic, assign) NSInteger index;

/// 其它扩展字段
@property (nonatomic, assign) BOOL boolField;
@property (nullable, nonatomic, strong) NSNumber *numberField;
@property (nullable, nonatomic, copy) NSArray *arrayField;
@property (nullable, nonatomic, copy) NSString *ID BRPickerViewDeprecated("请使用 key");

@end

NS_ASSUME_NONNULL_END
