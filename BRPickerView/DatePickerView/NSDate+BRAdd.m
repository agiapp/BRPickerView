//
//  NSDate+BRAdd.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2018/3/15.
//  Copyright © 2018年 renb. All rights reserved.
//

#import "NSDate+BRAdd.h"

static const NSCalendarUnit unitFlags = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (BRAdd)

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
- (NSInteger)year {
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.year;
}

#pragma mark - 获取指定日期的月份
- (NSInteger)month {
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.month;
}

#pragma mark - 获取指定日期的天
- (NSInteger)day {
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.day;
}

#pragma mark - 获取指定日期的小时
- (NSInteger)hour {
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.hour;
}

#pragma mark - 获取指定日期的分钟
- (NSInteger)minute {
    NSDateComponents *comps = [[NSDate calendar] components:unitFlags fromDate:self];
    return comps.minute;
}

#pragma mark - 获取指定日期的秒
- (NSInteger)second {
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.second;
}

#pragma mark - 获取指定日期的星期
- (NSInteger)weekday {
    NSDateComponents *components = [[NSDate calendar] components:unitFlags fromDate:self];
    return components.weekday;
}

///// 提示：除了使用 NSDateComponents 获取年月日等信息，还可以通过格式化日期获取日期的详细的信息 //////

#pragma mark - 创建date
+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSCalendar *calendar = [NSDate calendar];
    // 初始化日期组件
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    if (year >= 0) {
        components.year = year;
    }
    if (month >= 0) {
        components.month = month;
    }
    if (day >= 0) {
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

+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    return [self setYear:year month:month day:day hour:hour minute:minute second:-1];
}

+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [self setYear:year month:month day:day hour:-1 minute:-1 second:-1];
}

+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month {
    return [self setYear:year month:month day:-1 hour:-1 minute:-1 second:-1];
}

+ (NSDate *)setYear:(NSInteger)year {
    return [self setYear:year month:-1 day:-1 hour:-1 minute:-1 second:-1];
}

+ (NSDate *)setMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    return [self setYear:-1 month:month day:day hour:hour minute:minute second:-1];
}

+ (NSDate *)setMonth:(NSInteger)month day:(NSInteger)day {
    return [self setYear:-1 month:month day:day hour:-1 minute:-1 second:-1];
}

+ (NSDate *)setHour:(NSInteger)hour minute:(NSInteger)minute {
    return [self setYear:-1 month:-1 day:-1 hour:hour minute:minute second:-1];
}

#pragma mark - 日期和字符串之间的转换：NSDate --> NSString
+ (NSString *)getDateString:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = format;
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

#pragma mark - 日期和字符串之间的转换：NSString --> NSDate
+ (NSDate *)getDate:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = format;
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    
    return destDate;
}

#pragma mark - 算法1：获取某个月的天数（通过年月求每月天数）
+ (NSUInteger)getDaysInYear:(NSInteger)year month:(NSInteger)month {
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

#pragma mark - 算法2：获取某个月的天数（通过年月求每月天数）
+ (NSUInteger)getDaysInYear2:(NSInteger)year month:(NSInteger)month {
    NSDate *date = [NSDate getDate:[NSString stringWithFormat:@"%zi-%zi", year, month] format:@"yyyy-MM"];
    // 指定日历的算法(这里按公历)
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 只要给个时间给日历,就会帮你计算出来。
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate:date];
    return range.length;
}

// yyyy-MM-dd hh:mm:ss  12小时制
// yyyy-MM-dd HH:mm:ss  24小时制
// yyyy-MM-dd HH:mm:ss.SSS  (SSS毫秒)

#pragma mark - 获取系统当前的时间戳，即当前时间距1970的秒数（以毫秒为单位）
+ (NSString *)currentTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    /** 当前时间距1970的秒数。*1000 是精确到毫秒，不乘就是精确到秒 */
    NSTimeInterval interval = [date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];
    
    return timeString;
}

#pragma mark - 获取当前的时间
+ (NSString *)currentDateString {
    return [self currentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark - 按指定格式获取当前的时间
+ (NSString *)currentDateStringWithFormat:(NSString *)formatterStr {
    // 获取系统当前时间
    NSDate *currentDate = [NSDate date];
    // 用于格式化NSDate对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式：yyyy-MM-dd HH:mm:ss
    formatter.dateFormat = formatterStr;
    // 将 NSDate 按 formatter格式 转成 NSString
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    // 输出currentDateStr
    return currentDateStr;
}

#pragma mark - 返回指定时间差值的日期字符串
+ (NSString *)dateStringWithDelta:(NSTimeInterval)delta {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:delta];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

#pragma mark - 计算两个日期之间的天数
+ (NSInteger)deltaDays:(NSString *)beginDateString endDate:(NSString *)endDateString {
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *beginDate = [dateFormatter dateFromString:beginDateString];
    NSDate *endDate = [dateFormatter dateFromString:endDateString];
    //取两个日期对象的时间间隔
    NSTimeInterval deltaTime = [endDate timeIntervalSinceDate:beginDate];
    NSInteger days = (NSInteger)deltaTime / (24 * 60 * 60);
    //NSInteger hours = ((NSInteger)deltaTime - days * 24 * 60 * 60) / (60 * 60);
    //NSInteger minute = ((NSInteger)deltaTime - days * 24 * 60 * 60 - hours * 60 * 60) / 60;
    //NSInteger second = (NSInteger)deltaTime - days * 24 * 60 * 60 - hours * 60 * 60 - minute * 60;
    
    return days;
}

#pragma mark - 返回 指定时间加指定天数 结果日期字符串
+ (NSString *)date:(NSString *)dateString format:(NSString *)format addDays:(NSInteger)days {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = format;
    NSDate *myDate = [dateFormatter dateFromString:dateString];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * days];
    //NSDate *newDate = [NSDate dateWithTimeInterval:60 * 60 * 24 * days sinceDate:myDate];
    NSString *newDateString = [dateFormatter stringFromDate:newDate];
    return newDateString;
}

#pragma mark - 比较两个时间大小（可以指定比较级数，即按指定格式进行比较）
- (NSComparisonResult)br_compare:(NSDate *)targetDate format:(NSString *)format {
    NSString *dateString1 = [NSDate getDateString:self format:format];
    NSString *dateString2 = [NSDate getDateString:targetDate format:format];
    NSDate *date1 = [NSDate getDate:dateString1 format:format];
    NSDate *date2 = [NSDate getDate:dateString2 format:format];
    if ([date1 compare:date2] == NSOrderedDescending) {
        return 1;
    } else if ([date1 compare:date2] == NSOrderedAscending) {
        return -1;
    } else {
        return 0;
    }
}

@end
