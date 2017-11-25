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
             @"name": @"v",
             @"city": @"n"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"city": [BRCityModel class]
             };
}

@end


@implementation BRCityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"name": @"v",
             @"town": @"n"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"town": [BRTownModel class]
             };
}

@end


@implementation BRTownModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"name": @"v"
             };
}

@end
