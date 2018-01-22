//
//  BRAddressModel.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRProvinceModel, BRCityModel, BRTownModel;

@interface BRProvinceModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, strong) NSArray *citylist;

@end

@interface BRCityModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, strong) NSArray *arealist;

@end


@interface BRTownModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *areaName;

@end
