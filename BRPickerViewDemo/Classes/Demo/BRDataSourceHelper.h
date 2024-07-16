//
//  BRDataSourceHelper.h
//  BRPickerViewDemo
//
//  Created by 筑龙股份 on 2024/7/4.
//  Copyright © 2024 irenb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRTextModel.h"
#import "BRResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRDataSourceHelper : NSObject
/** 加载高德行政区划省市区模型数组 */
+ (void)loadAMapRegionModelArr:(void (^)(NSArray *modeArr))completionBlock;

/** 获取本地省市区模型数组 */
+ (NSArray<BRTextModel *> *)getRegionTreeModelArr;

/** 获取学生年级数据源 */
+ (NSArray <BRTextModel *>*)getStudentGradeTreeDataSource;

/** 获取省市区数据源 */
+ (NSArray <BRTextModel *>*)getProvinceCityAreaListDataSource;

@end

NS_ASSUME_NONNULL_END
