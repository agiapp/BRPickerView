//
//  NSDate+BRPickerView.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2018/3/15.
//  Copyright © 2018年 91renb. All rights reserved.
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
        // 创建日历对象：返回当前客户端的逻辑日历(当每次修改系统日历设定，其实例化的对象也会随之改变)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
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

///// 提示：除了使用 NSDateComponents 获取年月日等信息，还可以通过格式化日期获取日期的详细的信息 //////

#pragma mark - 创建date
+ (NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSCalendar *calendar = [NSDate calendar];
    // 初始化日期组件
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    if (year > 0) {
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

#pragma mark - NSDate时间 和 字符串时间 之间的转换：NSDate 转 NSString
+ (NSString *)br_getDateString:(NSDate *)date format:(NSString *)format {
    if (!date) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 不设置会默认使用当前所在的时区
    // dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    // 设置日期格式
    dateFormatter.dateFormat = format;
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

#pragma mark - NSDate时间 和 字符串时间 之间的转换：NSString 转 NSDate
+ (NSDate *)br_getDate:(NSString *)dateString format:(NSString *)format {
    if (!dateString || dateString.length == 0) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    dateFormatter.dateFormat = format;
    // 一些夏令时时间（如：1949-05-01等），会导致 NSDateFormatter 格式化失败，返回null
    NSDate *date = [dateFormatter dateFromString:dateString];
    if (!date) {
        date = [NSDate date];
    }
    
    // 设置转换后的目标日期时区
    NSTimeZone *toTimeZone = [NSTimeZone localTimeZone];
    // 转换后源日期与世界标准时间的偏移量（解决8小时时间差问题）
    NSInteger toGMTOffset = [toTimeZone secondsFromGMTForDate:date];
    // 设置时区：字符串时间是当前时区的时间，NSDate存储的是世界标准时间(零时区的时间)
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:toGMTOffset];
    
    date = [dateFormatter dateFromString:dateString];
    
    return date;
}

#pragma mark - 获取某个月的天数（通过年月求每月天数）
+ (NSUInteger)br_getDaysInYear:(NSInteger)year month:(NSInteger)month {
    BOOL isLeapYear = year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? YES : NO) : YES) : NO;
    switch (month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:
        {
            return 31;
            break;
        }
        case 4:case 6:case 9:case 11:
        {
            return 30;
            break;
        }
        case 2:
        {
            if (isLeapYear) {
                return 29;
                break;
            } else {
                return 28;
                break;
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

#pragma mark - 比较两个时间大小（可以指定比较级数，即按指定格式进行比较）
- (NSComparisonResult)br_compare:(NSDate *)targetDate format:(NSString *)format {
    NSString *dateString1 = [NSDate br_getDateString:self format:format];
    NSString *dateString2 = [NSDate br_getDateString:targetDate format:format];
    NSDate *date1 = [NSDate br_getDate:dateString1 format:format];
    NSDate *date2 = [NSDate br_getDate:dateString2 format:format];
    if ([date1 compare:date2] == NSOrderedDescending) {
        return 1;
    } else if ([date1 compare:date2] == NSOrderedAscending) {
        return -1;
    } else {
        return 0;
    }
}

@end
