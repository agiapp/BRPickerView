//
//  NSDate+BRAdd.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BRAdd)

/** 获取系统当前的时间戳，即当前时间距1970的秒数（以毫秒为单位） */
+ (NSString *)currentTimestamp;

/** 获取当前的时间 */
+ (NSString *)currentDateString;

/**
 *  按指定格式获取当前的时间
 *
 *  @param  formatterStr  设置格式：yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)currentDateStringWithFormat:(NSString *)formatterStr;

/**
 *  计算两个日期之间的天数
 *
 *  @param  beginDateString     设置格式：yyyy-MM-dd
 *  @param  endDateString       设置格式：yyyy-MM-dd
 */
+ (NSInteger)deltaDaysFrombeginDate:(NSString *)beginDateString endDate:(NSString *)endDateString;

/**
 *  返回指定时间差值的日期字符串
 *
 *  @param delta 时间差值
 *  @return 日期字符串，格式：yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)dateStringWithDelta:(NSTimeInterval)delta;

/**
 *  指定时间加指定天数
 *
 *  @param dateString  日期
 *  @param days        天数
 *  @return 日期字符串，格式：yyyy-MM-dd
 */
+ (NSString *)date:(NSString *)dateString formatter:(NSString *)formatterStr addDays:(NSInteger)days;

/**
 *  返回日期格式字符串
 *
 *  @param dateStr 需要转换的时间点
 *  @return 日期字符串
 *    返回具体格式如下：
 *      - 刚刚(一分钟内)
 *      - X分钟前(一小时内)
 *      - X小时前(当天)
 *      - MM-dd HH:mm(一年内)
 *      - yyyy-MM-dd HH:mm(更早期)
 */
+ (NSString *)dateDescriptionWithTargetDate:(NSString *)dateStr andTargetDateFormat:(NSString *)dateFormatStr;

@end
