//
//  BRDatePickerView+BR.h
//  BRPickerViewDemo
//
//  Created by renbo on 2020/6/16.
//  Copyright © 2020 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import "BRDatePickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRDatePickerView (BR)

/** 最小日期 */
- (NSDate *)handlerMinDate:(nullable NSDate *)minDate;

/** 最大日期 */
- (NSDate *)handlerMaxDate:(nullable NSDate *)maxDate;

/** 默认选中的日期 */
- (NSDate *)handlerSelectDate:(nullable NSDate *)selectDate dateFormat:(NSString *)dateFormat;

/** NSDate 转 NSString */
- (NSString *)br_stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

/** NSString 转 NSDate */
- (NSDate *)br_dateFromString:(NSString *)dateString dateFormat:(NSString *)dateFormat;

/** 比较两个日期大小（可以指定比较级数，即按指定格式进行比较） */
- (NSComparisonResult)br_compareDate:(NSDate *)date targetDate:(NSDate *)targetDate dateFormat:(NSString *)dateFormat;

/** 获取 yearArr 数组 */
- (NSArray *)getYearArr;

/** 获取 monthArr 数组 */
- (NSArray *)getMonthArr:(NSInteger)year;

/** 获取 dayArr 数组 */
- (NSArray *)getDayArr:(NSInteger)year month:(NSInteger)month;

/** 获取 hourArr 数组 */
- (NSArray *)getHourArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/** 获取 minuteArr 数组 */
- (NSArray *)getMinuteArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour;

/** 获取 secondArr 数组 */
- (NSArray *)getSecondArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;

/**  获取 monthWeekArr 数组 */
- (NSArray *)getMonthWeekArr:(NSInteger)year month:(NSInteger)month;

/**  获取 yearWeekArr 数组 */
- (NSArray *)getYearWeekArr:(NSInteger)year;

 /**  获取 quarterArr 数组 */
- (NSArray *)getQuarterArr:(NSInteger)year;

/** 添加 pickerView */
- (void)setupPickerView:(UIView *)pickerView toView:(UIView *)view;

/** 设置日期单位 */
- (NSArray *)setupPickerUnitLabel:(UIPickerView *)pickerView unitArr:(NSArray *)unitArr;

- (NSString *)getYearNumber:(NSInteger)year;

- (NSString *)getMDHMSNumber:(NSInteger)number;

- (NSString *)getYearText:(NSArray *)yearArr row:(NSInteger)row;

- (NSString *)getMonthText:(NSArray *)monthArr row:(NSInteger)row;

- (NSString *)getDayText:(NSArray *)dayArr row:(NSInteger)row mSelectDate:(NSDate *)mSelectDate;

- (NSString *)getHourText:(NSArray *)hourArr row:(NSInteger)row;

- (NSString *)getMinuteText:(NSArray *)minuteArr row:(NSInteger)row;

- (NSString *)getSecondText:(NSArray *)secondArr row:(NSInteger)row;

- (NSString *)getWeekText:(NSArray *)weekArr row:(NSInteger)row;

- (NSString *)getQuarterText:(NSArray *)quarterArr row:(NSInteger)row;

- (NSString *)getAMText;

- (NSString *)getPMText;

- (NSString *)getYearUnit;

- (NSString *)getMonthUnit;

- (NSString *)getDayUnit;

- (NSString *)getHourUnit;

- (NSString *)getMinuteUnit;

- (NSString *)getSecondUnit;

- (NSString *)getWeekUnit;

- (NSString *)getQuarterUnit;

- (NSInteger)getIndexWithArray:(NSArray *)array object:(NSString *)obj;

@end

NS_ASSUME_NONNULL_END
