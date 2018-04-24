//
//  NSDate+BRPickerView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2018/3/15.
//  Copyright © 2018年 renb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (BRPickerView)
/// 获取指定date的详细信息
@property (readonly) NSInteger year;    // 年
@property (readonly) NSInteger month;   // 月
@property (readonly) NSInteger day;     // 日
@property (readonly) NSInteger hour;    // 时
@property (readonly) NSInteger minute;  // 分
@property (readonly) NSInteger second;  // 秒
@property (readonly) NSInteger weekday; // 星期

/** 创建 date */
/** yyyy */
+ (nullable NSDate *)setYear:(NSInteger)year;
/** yyyy-MM */
+ (nullable NSDate *)setYear:(NSInteger)year month:(NSInteger)month;
/** yyyy-MM-dd */
+ (nullable NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
/** yyyy-MM-dd HH:mm */
+ (nullable NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
/** MM-dd HH:mm */
+ (nullable NSDate *)setMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
/** MM-dd */
+ (nullable NSDate *)setMonth:(NSInteger)month day:(NSInteger)day;
/** HH:mm */
+ (nullable NSDate *)setHour:(NSInteger)hour minute:(NSInteger)minute;

/** 日期和字符串之间的转换：NSDate --> NSString */
+ (nullable  NSString *)getDateString:(NSDate *)date format:(NSString *)format;
/** 日期和字符串之间的转换：NSString --> NSDate */
+ (nullable  NSDate *)getDate:(NSString *)dateString format:(NSString *)format;
/** 获取某个月的天数（通过年月求每月天数）*/
+ (NSUInteger)getDaysInYear:(NSInteger)year month:(NSInteger)month;

/** 获取系统当前的时间戳，即当前时间距1970的秒数（以毫秒为单位） */
+ (NSString *)currentTimestamp;

/** 获取当前的时间 */
+ (NSString *)currentDateString;

/**
 *  按指定格式获取当前的时间
 *
 *  @param  formatterStr  设置格式：yyyy-MM-dd HH:mm:ss
 */
+ (nullable NSString *)currentDateStringWithFormat:(NSString *)formatterStr;

/**
 *  计算两个日期之间的天数
 *
 *  @param  beginDateString    开始时间 设置格式：yyyy-MM-dd
 *  @param  endDateString      结束时间 设置格式：yyyy-MM-dd
 */
+ (NSInteger)deltaDays:(NSString *)beginDateString endDate:(NSString *)endDateString;

/**
 *  返回指定时间差值的日期字符串
 *
 *  @param delta 时间差值
 *  @return 日期字符串，格式：yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)dateStringWithDelta:(NSTimeInterval)delta;

/**
 *  计算 指定时间 加 指定天数
 *
 *  @param dateString  日期
 *  @param format      日期格式
 *  @param days        天数
 *  @return 日期字符串，格式：yyyy-MM-dd
 */
+ (nullable NSString *)date:(NSString *)dateString format:(NSString *)format addDays:(NSInteger)days;

/**
 *  比较两个时间大小（可以指定比较级数，即按指定格式进行比较）
 */
- (NSComparisonResult)br_compare:(NSDate *)targetDate format:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
