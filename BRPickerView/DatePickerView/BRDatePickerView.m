//
//  BRDatePickerView.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRDatePickerView.h"
#import "NSBundle+BRPickerView.h"

/// 时间选择器的类型
typedef NS_ENUM(NSInteger, BRDatePickerStyle) {
    BRDatePickerStyleSystem,   // 系统样式：使用 UIDatePicker 类
    BRDatePickerStyleCustom    // 自定义样式：使用 UIPickerView 类
};

@interface BRDatePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIDatePickerMode _datePickerMode;
}
/** 时间选择器1 */
@property (nonatomic, strong) UIDatePicker *datePicker;
/** 时间选择器2 */
@property (nonatomic, strong) UIPickerView *pickerView;

/// 日期存储数组
@property(nonatomic, copy) NSArray *yearArr;
@property(nonatomic, copy) NSArray *monthArr;
@property(nonatomic, copy) NSArray *dayArr;
@property(nonatomic, copy) NSArray *hourArr;
@property(nonatomic, copy) NSArray *minuteArr;
@property(nonatomic, copy) NSArray *secondArr;

/// 记录 年、月、日、时、分、秒 当前选择的位置
@property(nonatomic, assign) NSInteger yearIndex;
@property(nonatomic, assign) NSInteger monthIndex;
@property(nonatomic, assign) NSInteger dayIndex;
@property(nonatomic, assign) NSInteger hourIndex;
@property(nonatomic, assign) NSInteger minuteIndex;
@property(nonatomic, assign) NSInteger secondIndex;

// 记录选择的值
@property (nonatomic, strong) NSDate *mSelectDate;
@property (nonatomic, copy) NSString *mSelectValue;

/** 显示类型 */
@property (nonatomic, assign) BRDatePickerMode showType;
/** 时间选择器的类型 */
@property (nonatomic, assign) BRDatePickerStyle style;
/** 选择的日期的格式 */
@property (nonatomic, copy) NSString *selectDateFormatter;

@end

@implementation BRDatePickerView

#pragma mark - 1.显示时间选择器
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(BRDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                    resultBlock:(BRDateResultBlock)resultBlock {
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithTitle:title dateType:dateType defaultSelValue:defaultSelValue minDate:nil maxDate:nil isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil];
    [datePickerView show];
}

#pragma mark - 2.显示时间选择器（支持 设置自动选择 和 自定义主题颜色）
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(BRDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(BRDateResultBlock)resultBlock {
    [self showDatePickerWithTitle:title dateType:dateType defaultSelValue:defaultSelValue minDate:minDate maxDate:maxDate isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 3.显示时间选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(BRDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(BRDateResultBlock)resultBlock
                    cancelBlock:(BRCancelBlock)cancelBlock {
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithTitle:title dateType:dateType defaultSelValue:defaultSelValue minDate:minDate maxDate:maxDate isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    [datePickerView show];
}

#pragma mark - 初始化时间选择器
- (instancetype)initWithPickerMode:(BRDatePickerMode)pickerMode {
    if (self = [super init]) {
        self.showType = pickerMode;
        self.isAutoSelect = NO;
        
        [self setupSelectDateFormatter:pickerMode];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                     dateType:(BRDatePickerMode)dateType
              defaultSelValue:(NSString *)defaultSelValue
                      minDate:(NSDate *)minDate
                      maxDate:(NSDate *)maxDate
                 isAutoSelect:(BOOL)isAutoSelect
                   themeColor:(UIColor *)themeColor
                  resultBlock:(BRDateResultBlock)resultBlock
                  cancelBlock:(BRCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.title = title;
        self.showType = dateType;
        self.mSelectValue = defaultSelValue;
        
        self.minDate = minDate;
        self.maxDate = maxDate;
        
        self.isAutoSelect = isAutoSelect;
        
        // 兼容旧版本，快速设置主题样式
        if (themeColor && [themeColor isKindOfClass:[UIColor class]]) {
            self.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:themeColor];
        }
        
        self.resultBlock = resultBlock;
        self.cancelBlock = cancelBlock;
        
        [self setupSelectDateFormatter:dateType];
    }
    return self;
}

- (void)handlerPickerData {
    // 1.最小日期限制
    if (!self.minDate) {
        if (self.showType == BRDatePickerModeTime || self.showType == BRDatePickerModeCountDownTimer || self.showType == BRDatePickerModeHM) {
            self.minDate = [NSDate br_setHour:0 minute:0];
        } else if (self.showType == BRDatePickerModeMDHM) {
            self.minDate = [NSDate br_setMonth:1 day:1 hour:0 minute:0];
        } else if (self.showType == BRDatePickerModeMD) {
            self.minDate = [NSDate br_setMonth:1 day:1];
        } else {
            self.minDate = [NSDate distantPast]; // 遥远的过去的一个时间点
        }
    }
    // 2.最大日期限制
    if (!self.maxDate) {
        if (self.showType == BRDatePickerModeTime || self.showType == BRDatePickerModeCountDownTimer || self.showType == BRDatePickerModeHM) {
            self.maxDate = [NSDate br_setHour:23 minute:59];
        } else if (self.showType == BRDatePickerModeMDHM) {
            self.maxDate = [NSDate br_setMonth:12 day:31 hour:23 minute:59];
        } else if (self.showType == BRDatePickerModeMD) {
            self.maxDate = [NSDate br_setMonth:12 day:31];
        } else {
            self.maxDate = [NSDate distantFuture]; // 遥远的未来的一个时间点
        }
    }
    BOOL minMoreThanMax = [self.minDate br_compare:self.maxDate format:self.selectDateFormatter] == NSOrderedDescending;
    NSAssert(!minMoreThanMax, @"最小日期不能大于最大日期！");
    if (minMoreThanMax) {
        // 如果最小日期大于了最大日期，就忽略两个值
        self.minDate = [NSDate distantPast];
        self.maxDate = [NSDate distantFuture];
    }
    
    // 3.默认选中的日期
    [self handlerValidSelectDate];
    
    if (self.style == BRDatePickerStyleCustom) {
        [self initDateArray];
    }
}

- (void)handlerValidSelectDate {
    if (!self.selectDate) {
        if (self.selectValue && self.selectValue.length > 0) {
            NSDate *defaultSelDate = [NSDate br_getDate:self.selectValue format:self.selectDateFormatter];
            if (!defaultSelDate) {
                BRErrorLog(@"参数异常！字符串 selectValue 的正确格式是：%@", self.selectDateFormatter);
                NSAssert(defaultSelDate, @"参数异常！请检查字符串 selectValue 的格式");
                defaultSelDate = [NSDate date]; // 默认值参数格式错误时，重置/忽略默认值，防止在 Release 环境下崩溃！
            }
            if (self.showType == BRDatePickerModeTime || self.showType == BRDatePickerModeCountDownTimer || self.showType == BRDatePickerModeHM) {
                self.mSelectDate = [NSDate br_setHour:defaultSelDate.br_hour minute:defaultSelDate.br_minute];
            } else if (self.showType == BRDatePickerModeMDHM) {
                self.mSelectDate = [NSDate br_setMonth:defaultSelDate.br_month day:defaultSelDate.br_day hour:defaultSelDate.br_hour minute:defaultSelDate.br_minute];
            } else if (self.showType == BRDatePickerModeMD) {
                self.mSelectDate = [NSDate br_setMonth:defaultSelDate.br_month day:defaultSelDate.br_day];
            } else if (self.showType == BRDatePickerModeHMS) {
               self.mSelectDate = [NSDate br_setHour:defaultSelDate.br_hour minute:defaultSelDate.br_minute second:defaultSelDate.br_second];
            } else {
                self.mSelectDate = defaultSelDate;
            }
        } else {
            // 不设置默认日期，就默认选中今天的日期
            self.mSelectDate = [NSDate date];
        }
    }
    BOOL selectLessThanMin = [self.mSelectDate br_compare:self.minDate format:self.selectDateFormatter] == NSOrderedAscending;
    BOOL selectMoreThanMax = [self.mSelectDate br_compare:self.maxDate format:self.selectDateFormatter] == NSOrderedDescending;
    if (selectLessThanMin) {
        BRErrorLog(@"默认选择的日期不能小于最小日期！");
        self.mSelectDate = self.minDate;
    }
    if (selectMoreThanMax) {
        BRErrorLog(@"默认选择的日期不能大于最大日期！");
        self.mSelectDate = self.maxDate;
    }
}

- (void)setupSelectDateFormatter:(BRDatePickerMode)model {
    switch (model) {
        case BRDatePickerModeTime:
        {
            self.selectDateFormatter = @"HH:mm";
            self.style = BRDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeTime;
        }
            break;
        case BRDatePickerModeDate:
        {
            self.selectDateFormatter = @"yyyy-MM-dd";
            self.style = BRDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeDate;
        }
            break;
        case BRDatePickerModeDateAndTime:
        {
            self.selectDateFormatter = @"yyyy-MM-dd HH:mm";
            self.style = BRDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeDateAndTime;
        }
            break;
        case BRDatePickerModeCountDownTimer:
        {
            self.selectDateFormatter = @"HH:mm";
            self.style = BRDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeCountDownTimer;
        }
            break;
            
        case BRDatePickerModeYMDHMS:
        {
            self.selectDateFormatter = @"yyyy-MM-dd HH:mm:ss";
            self.style = BRDatePickerStyleCustom;
        }
            break;
        case BRDatePickerModeYMDHM:
        {
            self.selectDateFormatter = @"yyyy-MM-dd HH:mm";
            self.style = BRDatePickerStyleCustom;
        }
            break;
        case BRDatePickerModeYMDH:
        {
            self.selectDateFormatter = @"yyyy-MM-dd HH";
            self.style = BRDatePickerStyleCustom;
        }
            break;
        case BRDatePickerModeMDHM:
        {
            self.selectDateFormatter = @"MM-dd HH:mm";
            self.style = BRDatePickerStyleCustom;
        }
            break;
        case BRDatePickerModeYMDE:
        case BRDatePickerModeYMD:
        {
            self.selectDateFormatter = @"yyyy-MM-dd";
            self.style = BRDatePickerStyleCustom;
        }
            break;
        case BRDatePickerModeYM:
        {
            self.selectDateFormatter = @"yyyy-MM";
            self.style = BRDatePickerStyleCustom;
        }
            break;
        case BRDatePickerModeY:
        {
            self.selectDateFormatter = @"yyyy";
            self.style = BRDatePickerStyleCustom;
        }
            break;
        case BRDatePickerModeMD:
        {
            self.selectDateFormatter = @"MM-dd";
            self.style = BRDatePickerStyleCustom;
        }
            break;
        case BRDatePickerModeHMS:
        {
            self.selectDateFormatter = @"HH:mm:ss";
            self.style = BRDatePickerStyleCustom;
        }
            break;
        case BRDatePickerModeHM:
        {
            self.selectDateFormatter = @"HH:mm";
            self.style = BRDatePickerStyleCustom;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置默认日期数据源
- (void)initDateArray {
    self.yearArr = [self getYearArr];
    self.monthArr = [self getMonthArr:self.mSelectDate.br_year];
    self.dayArr = [self getDayArr:self.mSelectDate.br_year month:self.mSelectDate.br_month];
    self.hourArr = [self getHourArr:self.mSelectDate.br_year month:self.mSelectDate.br_month day:self.mSelectDate.br_day];
    self.minuteArr = [self getMinuteArr:self.mSelectDate.br_year month:self.mSelectDate.br_month day:self.mSelectDate.br_day hour:self.mSelectDate.br_hour];
    self.secondArr = [self getSecondArr:self.mSelectDate.br_year month:self.mSelectDate.br_month day:self.mSelectDate.br_day hour:self.mSelectDate.br_hour minute:self.mSelectDate.br_minute];
    
    // 根据 默认选择的日期 计算出 对应的索引
    self.yearIndex = self.mSelectDate.br_year - self.minDate.br_year;
    self.monthIndex = self.mSelectDate.br_month - ((self.yearIndex == 0) ? self.minDate.br_month : 1);
    self.dayIndex = self.mSelectDate.br_day - ((self.yearIndex == 0 && self.monthIndex == 0) ? self.minDate.br_day : 1);
    self.hourIndex = self.mSelectDate.br_hour - ((self.yearIndex == 0 && self.monthIndex == 0 && self.dayIndex == 0) ? self.minDate.br_hour : 0);
    self.minuteIndex = self.mSelectDate.br_minute - ((self.yearIndex == 0 && self.monthIndex == 0 && self.dayIndex == 0 && self.hourIndex == 0) ? self.minDate.br_minute : 0);
    self.secondIndex = self.mSelectDate.br_second - ((self.yearIndex == 0 && self.monthIndex == 0 && self.dayIndex == 0 && self.hourIndex == 0 && self.minuteIndex == 0) ? self.minDate.br_second : 0);
}

#pragma mark - 更新日期数据源数组
- (void)reloadDateArrayWithUpdateMonth:(BOOL)updateMonth updateDay:(BOOL)updateDay updateHour:(BOOL)updateHour updateMinute:(BOOL)updateMinute updateSecond:(BOOL)updateSecond {
    // 1.更新 monthArr
    if (self.yearArr.count == 0) {
        return;
    }
    NSString *yearString = self.yearArr[self.yearIndex];
    // 如果 yearString = 至今
    if (self.isAddToNow && [yearString isEqualToString:[self getNowString]]) {
        self.monthArr = nil;
        self.dayArr = nil;
        self.hourArr = nil;
        self.minuteArr = nil;
        self.secondArr = nil;
        
        return;
    }
    if (updateMonth) {
        self.monthArr = [self getMonthArr:[yearString integerValue]];
    }
    
    // 2.更新 dayArr
    if (self.monthArr.count == 0) {
        return;
    }
    NSString *monthString = self.monthArr[self.monthIndex];
    // 如果 monthString = 至今
    if (self.isAddToNow && [monthString isEqualToString:[self getNowString]]) {
        self.dayArr = nil;
        self.hourArr = nil;
        self.minuteArr = nil;
        self.secondArr = nil;
        
        return;
    }
    if (updateDay) {
        self.dayArr = [self getDayArr:[yearString integerValue] month:[monthString integerValue]];
    }
    
    // 3.更新 hourArr
    if (self.dayArr.count == 0) {
        return;
    }
    NSInteger day = [self.dayArr[self.dayIndex] integerValue];
    if (updateHour) {
        self.hourArr = [self getHourArr:[yearString integerValue] month:[monthString integerValue] day:day];
    }
    
    // 4.更新 hourArr
    if (self.hourArr.count == 0) {
        return;
    }
    NSString *hourString = self.hourArr[self.hourIndex];
    // 如果 hourString = 至今
    if (self.isAddToNow && [hourString isEqualToString:[self getNowString]]) {
        self.minuteArr = nil;
        self.secondArr = nil;
        
        return;
    }
    if (updateMinute) {
        self.minuteArr = [self getMinuteArr:[yearString integerValue] month:[monthString integerValue] day:day hour:[hourString integerValue]];
    }
    
    // 5.更新 secondArr
    if (self.minuteArr.count == 0) {
        return;
    }
    NSInteger minute = [self.minuteArr[self.minuteIndex] integerValue];
    if (updateSecond) {
        self.secondArr = [self getSecondArr:[yearString integerValue] month:[monthString integerValue] day:day hour:[hourString integerValue] minute:minute];
    }
}

// 获取 yearArr 数组
- (NSArray *)getYearArr {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = self.minDate.br_year; i <= self.maxDate.br_year; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    
    // 判断是否需要添加“至今”
    if (self.isAddToNow) {
        switch (self.showType) {
            case BRDatePickerModeYMDHMS:
            case BRDatePickerModeYMDHM:
            case BRDatePickerModeYMDH:
            case BRDatePickerModeYMDE:
            case BRDatePickerModeYMD:
            case BRDatePickerModeYM:
            case BRDatePickerModeY:
            {
                [tempArr addObject:[self getNowString]];
            }
                break;
                
            default:
                break;
        }
    }

    return [tempArr copy];
}

// 获取 monthArr 数组
- (NSArray *)getMonthArr:(NSInteger)year {
    NSInteger startMonth = 1;
    NSInteger endMonth = 12;
    if (year == self.minDate.br_year) {
        startMonth = self.minDate.br_month;
    }
    if (year == self.maxDate.br_year) {
        endMonth = self.maxDate.br_month;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endMonth - startMonth + 1)];
    for (NSInteger i = startMonth; i <= endMonth; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    
    // 判断是否需要添加“至今”
    if (self.isAddToNow) {
        switch (self.showType) {
            case BRDatePickerModeMDHM:
            case BRDatePickerModeMD:
            {
                [tempArr addObject:[self getNowString]];
            }
                break;
                
            default:
                break;
        }
    }
    
    return [tempArr copy];
}

// 获取 dayArr 数组
- (NSArray *)getDayArr:(NSInteger)year month:(NSInteger)month {
    NSInteger startDay = 1;
    NSInteger endDay = [NSDate br_getDaysInYear:year month:month];
    if (year == self.minDate.br_year && month == self.minDate.br_month) {
        startDay = self.minDate.br_day;
    }
    if (year == self.maxDate.br_year && month == self.maxDate.br_month) {
        endDay = self.maxDate.br_day;
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = startDay; i <= endDay; i++) {
        [tempArr addObject:[NSString stringWithFormat:@"%@", @(i)]];
    }
    return [tempArr copy];
}

// 获取 hourArr 数组
- (NSArray *)getHourArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSInteger startHour = 0;
    NSInteger endHour = 23;
    if (year == self.minDate.br_year && month == self.minDate.br_month && day == self.minDate.br_day) {
        startHour = self.minDate.br_hour;
    }
    if (year == self.maxDate.br_year && month == self.maxDate.br_month && day == self.maxDate.br_day) {
        endHour = self.maxDate.br_hour;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endHour - startHour + 1)];
    for (NSInteger i = startHour; i <= endHour; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    
    // 判断是否需要添加“至今”
    if (self.isAddToNow) {
        switch (self.showType) {
            case BRDatePickerModeHMS:
            case BRDatePickerModeHM:
            {
                [tempArr addObject:[self getNowString]];
            }
                break;
                
            default:
                break;
        }
    }
    return [tempArr copy];
}

// 获取 minuteArr 数组
- (NSArray *)getMinuteArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
    NSInteger startMinute = 0;
    NSInteger endMinute = 59;
    if (year == self.minDate.br_year && month == self.minDate.br_month && day == self.minDate.br_day && hour == self.minDate.br_hour) {
        startMinute = self.minDate.br_minute;
    }
    if (year == self.maxDate.br_year && month == self.maxDate.br_month && day == self.maxDate.br_day && hour == self.maxDate.br_hour) {
        endMinute = self.maxDate.br_minute;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endMinute - startMinute + 1)];
    for (NSInteger i = startMinute; i <= endMinute; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    return [tempArr copy];
}

// 获取 secondArr 数组
- (NSArray *)getSecondArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    NSInteger startSecond = 0;
    NSInteger endSecond = 59;
    if (year == self.minDate.br_year && month == self.minDate.br_month && day == self.minDate.br_day && hour == self.minDate.br_hour && minute == self.minDate.br_minute) {
        startSecond = self.minDate.br_second;
    }
    if (year == self.maxDate.br_year && month == self.maxDate.br_month && day == self.maxDate.br_day && hour == self.maxDate.br_hour && minute == self.maxDate.br_minute) {
        endSecond = self.maxDate.br_second;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endSecond - startSecond + 1)];
    for (NSInteger i = startSecond; i <= endSecond; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    return [tempArr copy];
}

#pragma mark - 滚动到指定时间的位置
- (void)scrollToSelectDate:(NSDate *)selectDate animated:(BOOL)animated {
    // 根据 当前选择的日期 计算出 对应的索引
    NSInteger yearIndex = selectDate.br_year - self.minDate.br_year;
    NSInteger monthIndex = selectDate.br_month - ((yearIndex == 0) ? self.minDate.br_month : 1);
    NSInteger dayIndex = selectDate.br_day - ((yearIndex == 0 && monthIndex == 0) ? self.minDate.br_day : 1);
    NSInteger hourIndex = selectDate.br_hour - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0) ? self.minDate.br_hour : 0);
    NSInteger minuteIndex = selectDate.br_minute - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0 && hourIndex == 0) ? self.minDate.br_minute : 0);
    NSUInteger secondIndex = selectDate.br_second - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0 && hourIndex == 0 && minuteIndex == 0) ? self.minDate.br_second : 0);
    
    NSArray *indexArr = [NSArray array];
    if (self.showType == BRDatePickerModeYMDHMS) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex), @(secondIndex)];
    } else if (self.showType == BRDatePickerModeYMDHM) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex)];
    } else if (self.showType == BRDatePickerModeYMDH) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex), @(hourIndex)];
    } else if (self.showType == BRDatePickerModeMDHM) {
        indexArr = @[@(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex)];
    } else if (self.showType == BRDatePickerModeYMD || self.showType == BRDatePickerModeYMDE) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex)];
    } else if (self.showType == BRDatePickerModeYM) {
        indexArr = @[@(yearIndex), @(monthIndex)];
    } else if (self.showType == BRDatePickerModeY) {
        indexArr = @[@(yearIndex)];
    } else if (self.showType == BRDatePickerModeMD) {
        indexArr = @[@(monthIndex), @(dayIndex)];
    } else if (self.showType == BRDatePickerModeHMS) {
        indexArr = @[@(hourIndex), @(minuteIndex), @(secondIndex)];
    } else if (self.showType == BRDatePickerModeHM) {
        indexArr = @[@(hourIndex), @(minuteIndex)];
    }
    for (NSInteger i = 0; i < indexArr.count; i++) {
        [self.pickerView selectRow:[indexArr[i] integerValue] inComponent:i animated:animated];
    }
}

#pragma mark - 时间选择器1
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight, SCREEN_WIDTH, self.pickerStyle.pickerHeight)];
        _datePicker.backgroundColor = self.pickerStyle.pickerColor;
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _datePicker.datePickerMode = _datePickerMode;
        // 设置该 UIDatePicker 的国际化 Locale
        _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:self.pickerStyle.language];
        // textColor 隐藏属性，使用KVC赋值
        [_datePicker setValue:self.pickerStyle.pickerTextColor forKey:@"textColor"];
        
    /*
         // 通过 NSInvocation 来改变默认选中字体的状态
         SEL selector= NSSelectorFromString(@"setHighlightsToday:");
         // 创建NSInvocation
         NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
         BOOL no = NO;
         [invocation setSelector:selector];
         [invocation setArgument:&no atIndex:2];
         // 让invocation执行setHighlightsToday方法
         [invocation invokeWithTarget:_datePicker];
         
         
         // 设置分割线颜色
         for (UIView *view in _datePicker.subviews) {
                 if ([view isKindOfClass:[UIView class]]) {
                     for (UIView *subView in view.subviews) {
                     if (subView.frame.size.height < 1) {
                        subView.backgroundColor = self.pickerStyle.separatorColor;
                     }
                 }
             }
         }
    */
        
        // 设置时间范围
        if (self.minDate) {
            _datePicker.minimumDate = self.minDate;
        }
        if (self.maxDate) {
            _datePicker.maximumDate = self.maxDate;
        }
        // 滚动改变值的响应事件
        [_datePicker addTarget:self action:@selector(didSelectValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - 时间选择器2
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight, SCREEN_WIDTH, self.pickerStyle.pickerHeight)];
        _pickerView.backgroundColor = self.pickerStyle.pickerColor;
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource
// 1. 设置 picker 的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.showType == BRDatePickerModeYMDHMS) {
        return 6;
    } else if (self.showType == BRDatePickerModeYMDHM) {
        return 5;
    } else if (self.showType == BRDatePickerModeYMDH) {
        return 4;
    } else if (self.showType == BRDatePickerModeMDHM) {
        return 4;
    } else if (self.showType == BRDatePickerModeYMD || self.showType == BRDatePickerModeYMDE) {
        return 3;
    } else if (self.showType == BRDatePickerModeYM) {
        return 2;
    } else if (self.showType == BRDatePickerModeY) {
        return 1;
    } else if (self.showType == BRDatePickerModeMD) {
        return 2;
    } else if (self.showType == BRDatePickerModeHMS) {
        return 3;
    } else if (self.showType == BRDatePickerModeHM) {
        return 2;
    }
    return 0;
}

// 2. 设置 picker 每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *rowsArr = [NSArray array];
    if (self.showType == BRDatePickerModeYMDHMS) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count), @(self.secondArr.count)];
    } else if (self.showType == BRDatePickerModeYMDHM) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count)];
    } else if (self.showType == BRDatePickerModeYMDH) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count)];
    } else if (self.showType == BRDatePickerModeMDHM) {
        rowsArr = @[@(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count)];
    } else if (self.showType == BRDatePickerModeYMD || self.showType == BRDatePickerModeYMDE) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count)];
    } else if (self.showType == BRDatePickerModeYM) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count)];
    } else if (self.showType == BRDatePickerModeY) {
        rowsArr = @[@(self.yearArr.count)];
    } else if (self.showType == BRDatePickerModeMD) {
        rowsArr = @[@(self.monthArr.count), @(self.dayArr.count)];
    } else if (self.showType == BRDatePickerModeHMS) {
        rowsArr = @[@(self.hourArr.count), @(self.minuteArr.count), @(self.secondArr.count)];
    } else if (self.showType == BRDatePickerModeHM) {
        rowsArr = @[@(self.hourArr.count), @(self.minuteArr.count)];
    }
    return [rowsArr[component] integerValue];
}

#pragma mark - UIPickerViewDelegate
// 3. 设置 picker 的 显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    // 设置分割线的颜色
    for (UIView *subView in pickerView.subviews) {
        if (subView && [subView isKindOfClass:[UIView class]] && subView.frame.size.height <= 1) {
            subView.backgroundColor = self.pickerStyle.separatorColor;
        }
    }
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.pickerStyle.pickerTextFont;
        label.textColor = self.pickerStyle.pickerTextColor;
        // 字体自适应属性
        label.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        label.minimumScaleFactor = 0.5f;
    }
    
    // 给选择器上的label赋值
    if (self.showType == BRDatePickerModeYMDHMS) {
        if (component == 0) {
            label.text = [self getYearText:row];
        } else if (component == 1) {
            label.text = [self getMonthText:row];
        } else if (component == 2) {
            label.text = [self getDayText:row];
        } else if (component == 3) {
            label.text = [self getHourText:row];
        } else if (component == 4) {
            label.text = [self getMinuteText:row];
        } else if (component == 5) {
            label.text = [self getSecondText:row];
        }
    } else if (self.showType == BRDatePickerModeYMDHM) {
        if (component == 0) {
            label.text = [self getYearText:row];
        } else if (component == 1) {
            label.text = [self getMonthText:row];
        } else if (component == 2) {
            label.text = [self getDayText:row];
        } else if (component == 3) {
            label.text = [self getHourText:row];
        } else if (component == 4) {
            label.text = [self getMinuteText:row];
        }
    } else if (self.showType == BRDatePickerModeYMDH) {
        if (component == 0) {
            label.text = [self getYearText:row];
        } else if (component == 1) {
            label.text = [self getMonthText:row];
        } else if (component == 2) {
            label.text = [self getDayText:row];
        } else if (component == 3) {
            label.text = [self getHourText:row];
        }
    } else if (self.showType == BRDatePickerModeMDHM) {
        if (component == 0) {
            label.text = [self getMonthText:row];
        } else if (component == 1) {
            label.text = [self getDayText:row];
        } else if (component == 2) {
            label.text = [self getHourText:row];
        } else if (component == 3) {
            label.text = [self getMinuteText:row];
        }
    } else if (self.showType == BRDatePickerModeYMDE) {
        if (component == 0) {
            label.text = [self getYearText:row];
        } else if (component == 1) {
            label.text = [self getMonthText:row];
        } else if (component == 2) {
            label.text = [self getDayText:row];
        }
    } else if (self.showType == BRDatePickerModeYMD) {
        if (component == 0) {
            label.text = [self getYearText:row];
        } else if (component == 1) {
            label.text = [self getMonthText:row];
        } else if (component == 2) {
            label.text = [self getDayText:row];
        }
    }  else if (self.showType == BRDatePickerModeYM) {
        if (component == 0) {
            label.text = [self getYearText:row];
        } else if (component == 1) {
            label.text = [self getMonthText:row];
        }
    } else if (self.showType == BRDatePickerModeY) {
        if (component == 0) {
            label.text = [self getYearText:row];
        }
    } else if (self.showType == BRDatePickerModeMD) {
        if (component == 0) {
            label.text = [self getMonthText:row];
        } else if (component == 1) {
            label.text = [self getDayText:row];
        }
    } else if (self.showType == BRDatePickerModeHMS) {
        if (component == 0) {
            label.text = [self getHourText:row];
        } else if (component == 1) {
            label.text = [self getMinuteText:row];
        } else if (component == 2) {
            label.text = [self getSecondText:row];
        }
    } else if (self.showType == BRDatePickerModeHM) {
        if (component == 0) {
            label.text = [self getHourText:row];
        } else if (component == 1) {
            label.text = [self getMinuteText:row];
        }
    }
    
    return label;
}

// 4. 时间选择器2 每次滚动后的回调方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    BOOL isSelectNow = NO;
    if (self.showType == BRDatePickerModeYMDHMS) {
        if (component == 0) {
            self.yearIndex = row;
            [self reloadDateArrayWithUpdateMonth:YES updateDay:YES updateHour:YES updateMinute:YES updateSecond:YES];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
            [self.pickerView reloadComponent:5];
        } else if (component == 1) {
            self.monthIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:YES updateHour:YES updateMinute:YES updateSecond:YES];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
            [self.pickerView reloadComponent:5];
        } else if (component == 2) {
            self.dayIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:YES updateMinute:YES updateSecond:YES];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
            [self.pickerView reloadComponent:5];
        } else if (component == 3) {
            self.hourIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:NO updateMinute:YES updateSecond:YES];
            [self.pickerView reloadComponent:4];
            [self.pickerView reloadComponent:5];
        } else if (component == 4) {
            self.minuteIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:NO updateMinute:NO updateSecond:YES];
            [self.pickerView reloadComponent:5];
        } else if (component == 5) {
            self.secondIndex = row;
        }
        
        NSString *yearString = self.yearArr[self.yearIndex];
        if (![yearString isEqualToString:[self getNowString]]) {
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            int second = [self.secondArr[self.secondIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day hour:hour minute:minute second:second];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second];
        } else {
            isSelectNow = YES;
            self.mSelectDate = [NSDate date];
        }
        
    } else if (self.showType == BRDatePickerModeYMDHM) {
        if (component == 0) {
            self.yearIndex = row;
            [self reloadDateArrayWithUpdateMonth:YES updateDay:YES updateHour:YES updateMinute:YES updateSecond:NO];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        } else if (component == 1) {
            self.monthIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:YES updateHour:YES updateMinute:YES updateSecond:NO];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        } else if (component == 2) {
            self.dayIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:YES updateMinute:YES updateSecond:NO];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        } else if (component == 3) {
            self.hourIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:NO updateMinute:YES updateSecond:NO];
            [self.pickerView reloadComponent:4];
        } else if (component == 4) {
            self.minuteIndex = row;
        }
        
        NSString *yearString = self.yearArr[self.yearIndex];
        if (![yearString isEqualToString:[self getNowString]]) {
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day hour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute];
        } else {
            isSelectNow = YES;
            self.mSelectDate = [NSDate date];
        }
        
    } else if (self.showType == BRDatePickerModeYMDH) {
        if (component == 0) {
            self.yearIndex = row;
            [self reloadDateArrayWithUpdateMonth:YES updateDay:YES updateHour:YES updateMinute:NO updateSecond:NO];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
        } else if (component == 1) {
            self.monthIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:YES updateHour:YES updateMinute:NO updateSecond:NO];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
        } else if (component == 2) {
            self.dayIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:YES updateMinute:NO updateSecond:NO];
            [self.pickerView reloadComponent:3];
        } else if (component == 3) {
            self.hourIndex = row;
        }
        
        NSString *yearString = self.yearArr[self.yearIndex];
        if (![yearString isEqualToString:[self getNowString]]) {
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            int hour = [self.hourArr[self.hourIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day hour:hour];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %02d", year, month, day, hour];
        } else {
            isSelectNow = YES;
            self.mSelectDate = [NSDate date];
        }
        
    } else if (self.showType == BRDatePickerModeMDHM) {
        if (component == 0) {
            self.monthIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:YES updateHour:YES updateMinute:YES updateSecond:NO];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
        } else if (component == 1) {
            self.dayIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:YES updateMinute:YES updateSecond:NO];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
        } else if (component == 2) {
            self.hourIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:NO updateMinute:YES updateSecond:NO];
            [self.pickerView reloadComponent:3];
        } else if (component == 3) {
            self.minuteIndex = row;
        }
        
        NSString *monthString = self.monthArr[self.monthIndex];
        if (![monthString isEqualToString:[self getNowString]]) {
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            self.mSelectDate = [NSDate br_setMonth:month day:day hour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%02d-%02d %02d:%02d", month, day, hour, minute];
        } else {
            isSelectNow = YES;
            self.mSelectDate = [NSDate date];
        }
        
    } else if (self.showType == BRDatePickerModeYMD || self.showType == BRDatePickerModeYMDE) {
        if (component == 0) {
            self.yearIndex = row;
            [self reloadDateArrayWithUpdateMonth:YES updateDay:YES updateHour:NO updateMinute:NO updateSecond:NO];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
        } else if (component == 1) {
            self.monthIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:YES updateHour:NO updateMinute:NO updateSecond:NO];
            [self.pickerView reloadComponent:2];
        } else if (component == 2) {
            self.dayIndex = row;
        }
        
        NSString *yearString = self.yearArr[self.yearIndex];
        if (![yearString isEqualToString:[self getNowString]]) {
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d", year, month, day];
        } else {
            isSelectNow = YES;
            self.mSelectDate = [NSDate date];
        }
        
    } else if (self.showType == BRDatePickerModeYM) {
        if (component == 0) {
            self.yearIndex = row;
            [self reloadDateArrayWithUpdateMonth:YES updateDay:NO updateHour:NO updateMinute:NO updateSecond:NO];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            self.monthIndex = row;
        }
        
        NSString *yearString = self.yearArr[self.yearIndex];
        if (![yearString isEqualToString:[self getNowString]]) {
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d", year, month];
        } else {
            isSelectNow = YES;
            self.mSelectDate = [NSDate date];
        }
        
    } else if (self.showType == BRDatePickerModeY) {
        if (component == 0) {
            self.yearIndex = row;
        }
        
        NSString *yearString = self.yearArr[self.yearIndex];
        if (![yearString isEqualToString:[self getNowString]]) {
            int year = [self.yearArr[self.yearIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year];
            self.mSelectValue = [NSString stringWithFormat:@"%04d", year];
        } else {
            isSelectNow = YES;
            self.mSelectDate = [NSDate date];
        }
        
    } else if (self.showType == BRDatePickerModeMD) {
        if (component == 0) {
            self.monthIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:YES updateHour:NO updateMinute:NO updateSecond:NO];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            self.dayIndex = row;
        }
        
        NSString *monthString = self.monthArr[self.monthIndex];
        if (![monthString isEqualToString:[self getNowString]]) {
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            self.mSelectDate = [NSDate br_setMonth:month day:day];
            self.mSelectValue = [NSString stringWithFormat:@"%02d-%02d", month, day];
        } else {
            isSelectNow = YES;
            self.mSelectDate = [NSDate date];
        }
        
    } else if (self.showType == BRDatePickerModeHMS) {
        if (component == 0) {
            self.hourIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:NO updateMinute:YES updateSecond:YES];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
        } else if (component == 1) {
            self.minuteIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:NO updateMinute:NO updateSecond:YES];
            [self.pickerView reloadComponent:2];
        } else if (component == 2) {
            self.secondIndex = row;
        }
        
        NSString *hourString = self.hourArr[self.hourIndex];
        if (![hourString isEqualToString:[self getNowString]]) {
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            int second = [self.secondArr[self.secondIndex] intValue];
            self.mSelectDate = [NSDate br_setHour:hour minute:minute second:second];
            self.mSelectValue = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
        } else {
            isSelectNow = YES;
            self.mSelectDate = [NSDate date];
        }
        
    } else if (self.showType == BRDatePickerModeHM) {
        if (component == 0) {
            self.hourIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:NO updateMinute:YES updateSecond:NO];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            self.minuteIndex = row;
        }
        
        NSString *hourString = self.hourArr[self.hourIndex];
        if (![hourString isEqualToString:[self getNowString]]) {
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            self.mSelectDate = [NSDate br_setHour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%02d:%02d", hour, minute];
        } else {
            isSelectNow = YES;
            self.mSelectDate = [NSDate date];
        }
    }
    
    // 由 至今 滚动到 其它时间时，回滚到上次选择的位置
    if ([self.mSelectValue isEqualToString:[self getNowString]] && !isSelectNow) {
        [self scrollToSelectDate:self.mSelectDate animated:NO];
    }
    if (isSelectNow) {
        self.mSelectValue = [self getNowString];
    }
    
    // 设置是否开启自动回调
    if (self.isAutoSelect) {
        // 滚动完成后，执行block回调
        if (self.resultBlock) {
            self.resultBlock(self.mSelectDate, self.mSelectValue);
        }
    }
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.pickerStyle.rowHeight;
}

#pragma mark - 时间选择器1 滚动后的响应事件
- (void)didSelectValueChanged:(UIDatePicker *)sender {
    // 读取日期：datePicker.date
    self.mSelectDate = sender.date;
    
    BOOL selectLessThanMin = [self.mSelectDate br_compare:self.minDate format:self.selectDateFormatter] == NSOrderedAscending;
    BOOL selectMoreThanMax = [self.mSelectDate br_compare:self.maxDate format:self.selectDateFormatter] == NSOrderedDescending;
    if (selectLessThanMin) {
        self.mSelectDate = self.minDate;
    }
    if (selectMoreThanMax) {
        self.mSelectDate = self.maxDate;
    }
    [self.datePicker setDate:self.mSelectDate animated:YES];
    
    self.mSelectValue = [NSDate br_getDateString:self.mSelectDate format:self.selectDateFormatter];
    
    // 设置是否开启自动回调
    if (self.isAutoSelect) {
        // 滚动完成后，执行block回调
        if (self.resultBlock) {
            self.resultBlock(self.mSelectDate, self.mSelectValue);
        }
    }
}

#pragma mark - 重写父类方法
- (void)addPickerToView:(UIView *)view {
    [self handlerPickerData];
    // 添加时间选择器
    if (self.style == BRDatePickerStyleSystem) {
        [self setPickerView:self.datePicker toView:view];
    } else if (self.style == BRDatePickerStyleCustom) {
        [self setPickerView:self.pickerView toView:view];
    }
    
    // 默认滚动的行
    if (self.style == BRDatePickerStyleSystem) {
        [self.datePicker setDate:self.mSelectDate animated:NO];
    } else if (self.style == BRDatePickerStyleCustom) {
        [self scrollToSelectDate:self.mSelectDate animated:NO];
    }
    
    __weak typeof(self) weakSelf = self;
    self.doneBlock = ^{
        // 点击确定按钮后，执行block回调
        [weakSelf removePickerFromView:view];
        
        if (!weakSelf.isAutoSelect && weakSelf.resultBlock) {
            weakSelf.mSelectValue = weakSelf.mSelectValue ? weakSelf.mSelectValue : [NSDate br_getDateString:weakSelf.mSelectDate format:weakSelf.selectDateFormatter];
            weakSelf.resultBlock(weakSelf.mSelectDate, weakSelf.mSelectValue);
        }
    };
    
    [super addPickerToView:view];
}

#pragma mark - 重写父类方法
- (void)addSubViewToPicker:(UIView *)customView {
    if (self.style == BRDatePickerStyleSystem) {
        [self.datePicker addSubview:customView];
    } else if (self.style == BRDatePickerStyleCustom) {
        [self.pickerView addSubview:customView];
    }
}

#pragma mark - 弹出选择器视图
- (void)show {
    [self addPickerToView:nil];
}

#pragma mark - 关闭选择器视图
- (void)dismiss {
    [self removePickerFromView:nil];
}

- (NSString *)getNowString {
    return [NSBundle br_localizedStringForKey:@"至今" language:self.pickerStyle.language];
}

- (NSString *)getYearText:(NSInteger)row {
    NSString *yearString = self.yearArr[row];
    if ([yearString isEqualToString:[self getNowString]]) {
        return yearString;
    }
    NSString *yearUnit = !self.hiddenDateUnit ? [NSBundle br_localizedStringForKey:@"年" language:self.pickerStyle.language] : @"";
    return [NSString stringWithFormat:@"%@%@", yearString, yearUnit];
}

- (NSString *)getMonthText:(NSInteger)row {
    NSString *monthString = self.monthArr[row];
    if ([monthString isEqualToString:[self getNowString]]) {
        return monthString;
    }
    NSString *monthUnit = !self.hiddenDateUnit ? [NSBundle br_localizedStringForKey:@"月" language:self.pickerStyle.language] : @"";
    return [NSString stringWithFormat:@"%@%@", monthString, monthUnit];
}

- (NSString *)getDayText:(NSInteger)row {
    NSString *dayString = self.dayArr[row];
    if (self.isShowToday && self.mSelectDate.br_year == [NSDate date].br_year && self.mSelectDate.br_month == [NSDate date].br_month && [dayString integerValue] == [NSDate date].br_day) {
        return [NSBundle br_localizedStringForKey:@"今天" language:self.pickerStyle.language];
    }
    NSString *dayUnit = !self.hiddenDateUnit ? [NSBundle br_localizedStringForKey:@"日" language:self.pickerStyle.language] : @"";
    dayString = [NSString stringWithFormat:@"%@%@", dayString, dayUnit];
    if (self.showType == BRDatePickerModeYMDE) {
        dayString = [NSString stringWithFormat:@"%@%@", dayString, [self getWeekday:row]];
    }
    return dayString;
}

- (NSString *)getHourText:(NSInteger)row {
    NSString *hourString = self.hourArr[row];
    if ([hourString isEqualToString:[self getNowString]]) {
        return hourString;
    }
    NSString *hourUnit = !self.hiddenDateUnit ? [NSBundle br_localizedStringForKey:@"时" language:self.pickerStyle.language] : @"";
    return [NSString stringWithFormat:@"%@%@", hourString, hourUnit];
}

- (NSString *)getMinuteText:(NSInteger)row {
    NSString *minuteUnit = !self.hiddenDateUnit ? [NSBundle br_localizedStringForKey:@"分" language:self.pickerStyle.language] : @"";
    return [NSString stringWithFormat:@"%@%@", self.minuteArr[row], minuteUnit];
}

- (NSString *)getSecondText:(NSInteger)row {
    NSString *secondUnit = !self.hiddenDateUnit ? [NSBundle br_localizedStringForKey:@"秒" language:self.pickerStyle.language] : @"";
    return [NSString stringWithFormat:@"%@%@", self.secondArr[row], secondUnit];
}

- (NSString *)getWeekday:(NSInteger)dayRow {
    NSInteger day = [self.dayArr[dayRow] integerValue];
    NSDate *date = [NSDate br_setYear:self.mSelectDate.br_year month:self.mSelectDate.br_month day:day];
    switch (date.br_weekday - 1) {
        case 0:
        {
            return [NSBundle br_localizedStringForKey:@"周日" language:self.pickerStyle.language];
        }
            break;
        case 1:
        {
            return [NSBundle br_localizedStringForKey:@"周一" language:self.pickerStyle.language];
        }
            break;
        case 2:
        {
            return [NSBundle br_localizedStringForKey:@"周二" language:self.pickerStyle.language];
        }
            break;
        case 3:
        {
            return [NSBundle br_localizedStringForKey:@"周三" language:self.pickerStyle.language];
        }
            break;
        case 4:
        {
            return [NSBundle br_localizedStringForKey:@"周四" language:self.pickerStyle.language];
        }
            break;
        case 5:
        {
            return [NSBundle br_localizedStringForKey:@"周五" language:self.pickerStyle.language];
        }
            break;
        case 6:
        {
            return [NSBundle br_localizedStringForKey:@"周六" language:self.pickerStyle.language];
        }
            break;
            
        default:
            break;
    }
    
    return @"";
}

#pragma mark - setter 方法
- (void)setAddToNow:(BOOL)addToNow {
    _addToNow = addToNow;
    if (addToNow) {
        _maxDate = [NSDate date];
    }
}

- (void)setMaxDate:(NSDate *)maxDate {
    // addToNow 为 YES 时，会默认设置 maxDate = [NSDate date];
    if (!self.isAddToNow) {
        _maxDate = maxDate;
    }
}

// 支持动态设置选择的值
- (void)setSelectDate:(NSDate *)selectDate {
    _selectDate = selectDate;
    _mSelectDate = selectDate;
    if (_datePicker || _pickerView) {
        // 处理选择的日期
        [self handlerValidSelectDate];
        if (self.style == BRDatePickerStyleCustom) {
            [self initDateArray];
        }
        [self.pickerView reloadAllComponents];
        // 更新选择的时间
        if (self.style == BRDatePickerStyleSystem) {
            [self.datePicker setDate:self.mSelectDate animated:NO];
        } else if (self.style == BRDatePickerStyleCustom) {
            [self scrollToSelectDate:self.mSelectDate animated:NO];
        }
    }
}

- (void)setSelectValue:(NSString *)selectValue {
    _selectValue = selectValue;
    _mSelectValue = selectValue;
    if (_datePicker || _pickerView) {
        // 处理选择的日期
        [self handlerValidSelectDate];
        if (self.style == BRDatePickerStyleCustom) {
            [self initDateArray];
        }
        [self.pickerView reloadAllComponents];
        // 更新选择的时间
        if (self.style == BRDatePickerStyleSystem) {
            [self.datePicker setDate:self.mSelectDate animated:NO];
        } else if (self.style == BRDatePickerStyleCustom) {
            [self scrollToSelectDate:self.mSelectDate animated:NO];
        }
    }
}

#pragma mark - getter 方法
- (NSArray *)yearArr {
    if (!_yearArr) {
        _yearArr = [NSArray array];
    }
    return _yearArr;
}

- (NSArray *)monthArr {
    if (!_monthArr) {
        _monthArr = [NSArray array];
    }
    return _monthArr;
}

- (NSArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSArray array];
    }
    return _dayArr;
}

- (NSArray *)hourArr {
    if (!_hourArr) {
        _hourArr = [NSArray array];
    }
    return _hourArr;
}

- (NSArray *)minuteArr {
    if (!_minuteArr) {
        _minuteArr = [NSArray array];
    }
    return _minuteArr;
}

- (NSArray *)secondArr {
    if (!_secondArr) {
        _secondArr = [NSArray array];
    }
    return _secondArr;
}

- (NSInteger)yearIndex {
    if (_yearIndex < 0) {
        return 0;
    }
    return MIN(_yearIndex, self.yearArr.count - 1);
}

- (NSInteger)monthIndex {
    if (_monthIndex < 0) {
        return 0;
    }
    return MIN(_monthIndex, self.monthArr.count - 1);
}

- (NSInteger)dayIndex {
    if (_dayIndex < 0) {
        return 0;
    }
    return MIN(_dayIndex, self.dayArr.count - 1);
}

- (NSInteger)hourIndex {
    if (_hourIndex < 0) {
        return 0;
    }
    return MIN(_hourIndex, self.hourArr.count - 1);
}

- (NSInteger)minuteIndex {
    if (_minuteIndex < 0) {
        return 0;
    }
    return MIN(_minuteIndex, self.minuteArr.count - 1);
}

- (NSInteger)secondIndex {
    if (_secondIndex < 0) {
        return 0;
    }
    return MIN(_secondIndex, self.secondArr.count - 1);
}

@end

