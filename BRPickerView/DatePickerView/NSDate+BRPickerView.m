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

static const NSCalendarUnit unitFlags = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitQuarter);

@implementation NSDate (BRPickerView)

#pragma mark - 获取日历单例对象
+ (NSCalendar *)br_calendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar) {
        // 创建日历对象，指定日历的算法（公历/阳历）
        sharedCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // NSCalendar 设置时区
        //sharedCalendar.timeZone = [NSTimeZone timeZoneWithName:@"America/Chicago"];
    }
    return sharedCalendar;
}

#pragma mark - NSDate 转 NSDateComponents
+ (NSDateComponents *)br_componentsFromDate:(NSDate *)date {
    // 通过日历类 NSCalendar 进行转换
    NSCalendar *calendar = [self br_calendar];
    // NSDateComponents 可以获得日期的详细信息，即日期的组成
    return [calendar components:unitFlags fromDate:date];
}

#pragma mark - NSDateComponents 转 NSDate
+ (NSDate *)br_dateFromComponents:(NSDateComponents *)components {
    // 通过日历类 NSCalendar 进行转换
    NSCalendar *calendar = [self br_calendar];
    return [calendar dateFromComponents:components];
}

#pragma mark - 获取指定日期的年份
- (NSInteger)br_year {
    return [NSDate br_componentsFromDate:self].year;
}

#pragma mark - 获取指定日期的月份
- (NSInteger)br_month {
    return [NSDate br_componentsFromDate:self].month;
}

#pragma mark - 获取指定日期的天
- (NSInteger)br_day {
    return [NSDate br_componentsFromDate:self].day;
}

#pragma mark - 获取指定日期的小时
- (NSInteger)br_hour {
    return [NSDate br_componentsFromDate:self].hour;
}

#pragma mark - 获取指定日期的分钟
- (NSInteger)br_minute {
    return [NSDate br_componentsFromDate:self].minute;
}

#pragma mark - 获取指定日期的秒
- (NSInteger)br_second {
    return [NSDate br_componentsFromDate:self].second;
}

#pragma mark - 获取指定日期的星期
- (NSInteger)br_weekday {
    return [NSDate br_componentsFromDate:self].weekday;
}

#pragma mark - 获取指定日期的月周
- (NSInteger)br_monthWeek {
    return [NSDate br_componentsFromDate:self].weekOfMonth;
}

#pragma mark - 获取指定日期的年周
- (NSInteger)br_yearWeek {
    return [NSDate br_componentsFromDate:self].weekOfYear;
}

#pragma mark - 获取指定日期的季度
- (NSInteger)br_quarter {
//    [NSDate br_componentsFromDate:self].quarter; // 取到的季度值总是0?
    NSInteger quarter = 1;
    NSInteger month = self.br_month;
    if (month > 3) quarter = 2;
    if (month > 6) quarter = 3;
    if (month > 9) quarter = 4;
    
    return quarter;
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

/// ---------------- 创建 date ----------------
#pragma mark - 通过 NSDateComponents对象 来创建 NSDate对象（可以设置时区）
+ (nullable NSDate *)br_setDateFromComponents:(NSDateComponents *)components timeZone:(NSTimeZone *)timeZone {
    // 创建日历对象，指定日历的算法（公历/阳历）
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    if (timeZone) {
        // NSCalendar 设置时区
        calendar.timeZone = timeZone;
    }
    return [calendar dateFromComponents:components];
}

#pragma mark - 创建date（通过 NSCalendar 类来创建日期）
+ (NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    return [self br_setYear:year month:month day:day hour:hour minute:minute second:second weekOfMonth:0 weekOfYear:0 quarter:0];
}

+ (NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                  hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
           weekOfMonth:(NSInteger)weekOfMonth weekOfYear:(NSInteger)weekOfYear quarter:(NSInteger)quarter {
    NSDateComponents *components = [self br_componentsFromDate:[NSDate date]];
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
    if (weekOfMonth > 0) {
        components.weekOfMonth = weekOfMonth;
    }
    if (weekOfYear > 0) {
        components.weekOfYear = weekOfYear;
    }
    if (quarter > 0) {
        components.quarter = quarter;
    }
    
    return [self br_dateFromComponents:components];
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

+ (NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month weekOfMonth:(NSInteger)weekOfMonth {
    return [self br_setYear:year month:month day:0 hour:0 minute:0 second:0 weekOfMonth:weekOfMonth weekOfYear:0 quarter:0];
}

+ (NSDate *)br_setYear:(NSInteger)year weekOfYear:(NSInteger)weekOfYear {
    return [self br_setYear:year month:0 day:0 hour:0 minute:0 second:0 weekOfMonth:0 weekOfYear:weekOfYear quarter:0];
}

+ (NSDate *)br_setYear:(NSInteger)year quarter:(NSInteger)quarter {
    return [self br_setYear:year month:0 day:0 hour:0 minute:0 second:0 weekOfMonth:0 weekOfYear:0 quarter:quarter];
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

#pragma mark - 获取某个月的周数（通过年月求该月周数）
+ (NSUInteger)br_getWeeksOfMonthInYear:(NSInteger)year month:(NSInteger)month {
    NSUInteger lastDayOfMonth = [self br_getDaysInYear:year month:month];
    NSDate *endDate = [self br_setYear:year month:month day:lastDayOfMonth];
    return endDate.br_monthWeek;
}

#pragma mark - 获取某一年的周数（通过年求该年周数）
+ (NSUInteger)br_getWeeksOfYearInYear:(NSInteger)year {
    NSDate *endDate = [self br_setYear:year month:12 day:31];
    NSInteger weeks = endDate.br_yearWeek;
    if (weeks == 1) weeks = 52;
    return weeks;
}

#pragma mark - 获取某一年的季度数（通过年求该年季度数）
+ (NSUInteger)br_getQuartersInYear:(NSInteger)year {
    NSDate *endDate = [self br_setYear:year month:12 day:31];
    return endDate.br_quarter;
}

#pragma mark - 获取 日期加上/减去某天数后的新日期
- (NSDate *)br_getNewDateToDays:(NSTimeInterval)days {
    // days 为正数时，表示几天之后的日期；负数表示几天之前的日期
    return [self dateByAddingTimeInterval:60 * 60 * 24 * days];
}

#pragma mark - 获取 日期加上/减去某个月数后的新日期
- (nullable NSDate *)br_getNewDateToMonths:(NSTimeInterval)months {
    // months 为正数时，表示几个月之后的日期；负数表示几个月之前的日期
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calender dateByAddingComponents:components toDate:self options:0];
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
    // NSDateFormatter 设置时区 ，不设置默认为系统时区
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
