//
//  NSDate+BRPickerView.m
//  BRPickerViewDemo
//
//  Created by renbo on 2018/3/15.
//  Copyright © 2018 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "NSDate+BRPickerView.h"
#import "BRPickerViewMacro.h"

BRSYNTH_DUMMY_CLASS(NSDate_BRPickerView)

static const NSCalendarUnit unitFlags = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (BRPickerView)

#pragma mark - 获取日历单例对象
+ (NSCalendar *)calendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar) {
        // 创建日历对象，指定日历的算法（公历）
        sharedCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return sharedCalendar;
}

#pragma mark - 获取指定日期的年份
- (NSInteger)br_year {
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.year;
}

#pragma mark - 获取指定日期的月份
- (NSInteger)br_month {
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.month;
}

#pragma mark - 获取指定日期的天
- (NSInteger)br_day {
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.day;
}

#pragma mark - 获取指定日期的小时
- (NSInteger)br_hour {
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.hour;
}

#pragma mark - 获取指定日期的分钟
- (NSInteger)br_minute {
    NSDateComponents *comps = [[NSDate calendar] components:unitFlags fromDate:self];
    return comps.minute;
}

#pragma mark - 获取指定日期的秒
- (NSInteger)br_second {
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.second;
}

#pragma mark - 获取指定日期的星期
- (NSInteger)br_weekday {
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.weekday;
}

#pragma mark - 获取指定日期的星期
- (NSString *)br_weekdayString {
    switch (self.br_weekday - 1) {
        case 0:
        {
            return @"周日";
        }
            break;
        case 1:
        {
            return @"周一";
        }
            break;
        case 2:
        {
            return @"周二";
        }
            break;
        case 3:
        {
            return @"周三";
        }
            break;
        case 4:
        {
            return @"周四";
        }
            break;
        case 5:
        {
            return @"周五";
        }
            break;
        case 6:
        {
            return @"周六";
        }
            break;
            
        default:
            break;
    }
    
    return @"";
}

#pragma mark - 创建date（通过 NSCalendar 类来创建日期）
+ (NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSCalendar *calendar = [self calendar];
    // 获取当前日期组件
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    if (year > 0) {
        // 初始化日期组件
        components = [[NSDateComponents alloc]init];
        components.year = year;
    }
    if (month > 0) {
        components.month = month;
    }
    if (day > 0) {
        components.day = day;
    }
    if (hour >= 0) {
        components.hour = hour;
    }
    if (minute >= 0) {
        components.minute = minute;
    }
    if (second >= 0) {
        components.second = second;
    }
    
    NSDate *date = [calendar dateFromComponents:components];
    
    return date;
}

+ (NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    return [self br_setYear:year month:month day:day hour:hour minute:minute second:0];
}

+ (NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
    return [self br_setYear:year month:month day:day hour:hour minute:0 second:0];
}

+ (NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [self br_setYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month {
    return [self br_setYear:year month:month day:0 hour:0 minute:0 second:0];
}

+ (NSDate *)br_setYear:(NSInteger)year {
    return [self br_setYear:year month:0 day:0 hour:0 minute:0 second:0];
}

+ (NSDate *)br_setMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    return [self br_setYear:0 month:month day:day hour:hour minute:minute second:0];
}

+ (NSDate *)br_setMonth:(NSInteger)month day:(NSInteger)day {
    return [self br_setYear:0 month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)br_setHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    return [self br_setYear:0 month:0 day:0 hour:hour minute:minute second:second];
}

+ (NSDate *)br_setHour:(NSInteger)hour minute:(NSInteger)minute {
    return [self br_setYear:0 month:0 day:0 hour:hour minute:minute second:0];
}

+ (NSDate *)br_setMinute:(NSInteger)minute second:(NSInteger)second {
    return [self br_setYear:0 month:0 day:0 hour:0 minute:minute second:second];
}

#pragma mark - 获取某个月的天数（通过年月求每月天数）
+ (NSUInteger)br_getDaysInYear:(NSInteger)year month:(NSInteger)month {
    BOOL isLeapYear = year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? YES : NO) : YES) : NO;
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
        {
            return 31;
        }
        case 4:
        case 6:
        case 9:
        case 11:
        {
            return 30;
        }
        case 2:
        {
            if (isLeapYear) {
                return 29;
            } else {
                return 28;
            }
        }
        default:
            break;
    }
    
    return 0;
}

#pragma mark - 获取 日期加上/减去某天数后的新日期
- (NSDate *)br_getNewDate:(NSDate *)date addDays:(NSTimeInterval)days {
    // days 为正数时，表示几天之后的日期；负数表示几天之前的日期
    return [self dateByAddingTimeInterval:60 * 60 * 24 * days];
}

#pragma mark - NSDate 转 NSString
+ (NSString *)br_stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat {
    return [self br_stringFromDate:date dateFormat:dateFormat timeZone:nil language:nil];
}
#pragma mark - NSDate 转 NSString
+ (NSString *)br_stringFromDate:(NSDate *)date
                     dateFormat:(NSString *)dateFormat
                       timeZone:(NSTimeZone *)timeZone
                       language:(NSString *)language {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    dateFormatter.dateFormat = dateFormat;
    // 设置时区，不设置默认为系统时区
    if (timeZone) {
        dateFormatter.timeZone = timeZone;
    }
    if (!language) {
        language = [NSLocale preferredLanguages].firstObject;
    }
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:language];
    NSString *dateString = [dateFormatter stringFromDate:date];

    return dateString;
}

#pragma mark - NSString 转 NSDate
+ (NSDate *)br_dateFromString:(NSString *)dateString dateFormat:(NSString *)dateFormat {
    return [self br_dateFromString:dateString dateFormat:dateFormat timeZone:nil language:nil];
}
#pragma mark - NSString 转 NSDate
+ (NSDate *)br_dateFromString:(NSString *)dateString
                   dateFormat:(NSString *)dateFormat
                     timeZone:(NSTimeZone *)timeZone
                     language:(NSString *)language {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    dateFormatter.dateFormat = dateFormat;
    // 设置时区
    if (!timeZone) {
        timeZone = [self currentTimeZone];
    }
    if (!language) {
        language = [NSLocale preferredLanguages].firstObject;
    }
    dateFormatter.timeZone = timeZone;
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:language];
    // 如果当前时间不存在，就获取距离最近的整点时间
    dateFormatter.lenient = YES;
    
    return [dateFormatter dateFromString:dateString];
}

#pragma mark - 获取当前时区(不使用夏时制)
+ (NSTimeZone *)currentTimeZone {
    // 当前时区
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    // 当前时区相对于GMT(零时区)的偏移秒数
    NSInteger interval = [localTimeZone secondsFromGMTForDate:[NSDate date]];
    // 当前时区(不使用夏时制)：由偏移量获得对应的NSTimeZone对象
    // 注意：一些夏令时时间 NSString 转 NSDate 时，默认会导致 NSDateFormatter 格式化失败，返回 null
    return [NSTimeZone timeZoneForSecondsFromGMT:interval];
}

#pragma mark - NSDate 转 NSString（已弃用）
+ (NSString *)br_getDateString:(NSDate *)date format:(NSString *)format {
    return [self br_stringFromDate:date dateFormat:format];
}

#pragma mark - NSString 转 NSDate（已弃用）
+ (NSDate *)br_getDate:(NSString *)dateString format:(NSString *)format {
    return [self br_dateFromString:dateString dateFormat:format];
}

@end
