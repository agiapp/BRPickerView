//
//  NSDate+BRPickerView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2018/3/15.
//  Copyright © 2018年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (BRPickerView)
/// 获取指定date的详细信息
@property (readonly) NSInteger br_year;    // 年
@property (readonly) NSInteger br_month;   // 月
@property (readonly) NSInteger br_day;     // 日
@property (readonly) NSInteger br_hour;    // 时
@property (readonly) NSInteger br_minute;  // 分
@property (readonly) NSInteger br_second;  // 秒
@property (readonly) NSInteger br_weekday; // 星期

/** 创建 date */
/** yyyy */
+ (nullable NSDate *)br_setYear:(NSInteger)year;
/** yyyy-MM */
+ (nullable NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month;
/** yyyy-MM-dd */
+ (nullable NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
/** yyyy-MM-dd HH */
+ (nullable NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour;
/** yyyy-MM-dd HH:mm */
+ (nullable NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
/** yyyy-MM-dd HH:mm:ss */
+ (nullable NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
/** MM-dd HH:mm */
+ (nullable NSDate *)br_setMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
/** MM-dd */
+ (nullable NSDate *)br_setMonth:(NSInteger)month day:(NSInteger)day;
/** HH:mm:ss */
+ (nullable NSDate *)br_setHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
/** HH:mm */
+ (nullable NSDate *)br_setHour:(NSInteger)hour minute:(NSInteger)minute;


/** 日期和字符串之间的转换：NSDate --> NSString */
+ (nullable  NSString *)br_getDateString:(NSDate *)date format:(NSString *)format;
/** 日期和字符串之间的转换：NSString --> NSDate */
+ (nullable  NSDate *)br_getDate:(NSString *)dateString format:(NSString *)format;
/** 获取某个月的天数（通过年月求每月天数）*/
+ (NSUInteger)br_getDaysInYear:(NSInteger)year month:(NSInteger)month;

/**  获取 日期加上/减去某天数后的新日期 */
- (nullable NSDate *)br_getNewDate:(NSDate *)date addDays:(NSTimeInterval)days;

/**
 *  比较两个时间大小（可以指定比较级数，即按指定格式进行比较）
 */
- (NSComparisonResult)br_compare:(NSDate *)targetDate format:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
