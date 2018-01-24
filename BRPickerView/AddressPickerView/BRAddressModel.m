//
//  BRAddressModel.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRAddressModel.h"
#import "MJExtension.h"

@implementation BRProvinceModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID": @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"citylist": [BRCityModel class]
             };
}

@end


@implementation BRCityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID": @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"arealist": [BRAreaModel class]
             };
}

@end


@implementation BRAreaModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID": @"id"
             };
}

@end
