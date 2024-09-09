//
//  BRResultModel.h
//  BRPickerViewDemo
//
//  Created by renbo on 2019/10/2.
//  Copyright © 2019 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRResultModel : NSObject

/** key */
@property (nullable, nonatomic, copy) NSString *key;
/** value */
@property (nullable, nonatomic, copy) NSString *value;;
/** 父级key（提示：联动时第一级数据，parentKey设置为：@"-1"） */
@property (nullable, nonatomic, copy) NSString *parentKey;
/** 父级value */
@property (nullable, nonatomic, copy) NSString *parentValue;
/** 子级list */
@property (nullable, nonatomic, copy) NSArray<BRResultModel *> *children;
/** 记录选择的索引位置 */
@property (nonatomic, assign) NSInteger index;

/// 其它扩展字段
@property (nullable, nonatomic, strong) id extras;
@property (nullable, nonatomic, copy) NSString *level;
@property (nullable, nonatomic, copy) NSString *remark;

@end

NS_ASSUME_NONNULL_END
