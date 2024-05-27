//
//  NSDate+BRPickerView.h
//  BRPickerViewDemo
//
//  Created by renbo on 2018/3/15.
//  Copyright © 2018 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSDate (BRPickerView)

/// ---------------- 设置【日历对象】和【时区】 ----------------
/** 设置日历对象 */
+ (void)br_setCalendar:(NSCalendar *)calendar;
/** 获取日历对象 */
+ (NSCalendar *)br_getCalendar;

/** 设置时区 */
+ (void)br_setTimeZone:(NSTimeZone *)timeZone;
/** 获取当前时区 */
+ (NSTimeZone *)br_getTimeZone;

/// 获取指定date的详细信息
@property (readonly) NSInteger br_year;         // 年
@property (readonly) NSInteger br_month;        // 月
@property (readonly) NSInteger br_day;          // 日
@property (readonly) NSInteger br_hour;         // 时
@property (readonly) NSInteger br_minute;       // 分
@property (readonly) NSInteger br_second;       // 秒
@property (readonly) NSInteger br_weekday;      // 星期
@property (readonly) NSInteger br_monthWeek;    // 月周
@property (readonly) NSInteger br_yearWeek;     // 年周
@property (readonly) NSInteger br_quarter;      // 季度

/** 获取中文星期字符串 */
@property (nullable, nonatomic, readonly, copy) NSString *br_weekdayString;

/// ---------------- 创建 date ----------------
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

/** mm:ss */
+ (nullable NSDate *)br_setMinute:(NSInteger)minute second:(NSInteger)second;

/** yyyy-MM-ww */
+ (nullable NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month weekOfMonth:(NSInteger)weekOfMont;

/** yyyy-ww */
+ (nullable NSDate *)br_setYear:(NSInteger)year weekOfYear:(NSInteger)weekOfYear;

/** yyyy-qq */
+ (nullable NSDate *)br_setYear:(NSInteger)year quarter:(NSInteger)quarter;

/** 设置12小时制时的hour值 */
- (NSDate *)br_setTwelveHour:(NSInteger)hour;

/** 获取某个月的天数（通过年月求每月天数）*/
+ (NSUInteger)br_getDaysInYear:(NSInteger)year month:(NSInteger)month;

/** 获取某个月的周数（通过年月求该月周数）*/
+ (NSUInteger)br_getWeeksOfMonthInYear:(NSInteger)year month:(NSInteger)month;

/** 获取某一年的周数（通过年求该年周数）*/
+ (NSUInteger)br_getWeeksOfYearInYear:(NSInteger)year;

/** 获取某一年的季度数（通过年求该年季度数）*/
+ (NSUInteger)br_getQuartersInYear:(NSInteger)year;

/**  获取 日期加上/减去某天数后的新日期 */
- (nullable NSDate *)br_getNewDateToDays:(NSTimeInterval)days;

/**  获取 日期加上/减去某个月数后的新日期 */
- (nullable NSDate *)br_getNewDateToMonths:(NSTimeInterval)months;

/** NSDate 转 NSString（使用系统默认 时区 和 语言）*/
+ (nullable NSString *)br_stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;
/** NSDate 转 NSString */
+ (nullable NSString *)br_stringFromDate:(NSDate *)date
                              dateFormat:(NSString *)dateFormat
                                language:(nullable NSString *)language;

/** NSString 转 NSDate（使用系统默认 时区 和 语言）*/
+ (nullable NSDate *)br_dateFromString:(NSString *)dateString dateFormat:(NSString *)dateFormat;
/** NSString 转 NSDate */
+ (nullable NSDate *)br_dateFromString:(NSString *)dateString
                            dateFormat:(NSString *)dateFormat
                              language:(nullable NSString *)language;

@end

NS_ASSUME_NONNULL_END
