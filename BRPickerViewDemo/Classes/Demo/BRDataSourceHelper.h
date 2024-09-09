//
//  BRDataSourceHelper.h
//  BRPickerViewDemo
//
//  Created by renbo on 2024/7/4.
//  Copyright © 2024 irenb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRDataSourceHelper : NSObject
/** 获取本地文件（.plist/.json）数据 */
+ (id)getLocalFileData:(NSString *)fileName;
/** 加载高德行政区划省市区模型数组 */
+ (void)loadAMapRegionModelArr:(void (^)(NSArray *dataArr))completionBlock;

@end

NS_ASSUME_NONNULL_END
