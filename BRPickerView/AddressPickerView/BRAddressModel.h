//
//  BRAddressModel.h
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 省
@interface BRProvinceModel : NSObject
/** 省对应的code或id */
@property (nullable, nonatomic, copy) NSString *code;
/** 省的名称 */
@property (nullable, nonatomic, copy) NSString *name;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;
/** 城市数组 */
@property (nullable, nonatomic, copy) NSArray *citylist;

@end

/// 市
@interface BRCityModel : NSObject
/** 市对应的code或id */
@property (nullable, nonatomic, copy) NSString *code;
/** 市的名称 */
@property (nullable, nonatomic, copy) NSString *name;
/** 市的索引 */
@property (nonatomic, assign) NSInteger index;
/** 地区数组 */
@property (nullable, nonatomic, copy) NSArray *arealist;

@end

/// 区
@interface BRAreaModel : NSObject
/** 区对应的code或id */
@property (nullable, nonatomic, copy) NSString *code;
/** 区的名称 */
@property (nullable, nonatomic, copy) NSString *name;
/** 区的索引 */
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
