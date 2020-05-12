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
    UIView *_containerView;
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

/** 时间选择器的类型 */
@property (nonatomic, assign) BRDatePickerStyle style;
/** 日期的格式 */
@property (nonatomic, copy) NSString *dateFormatter;
/** 单位数组 */
@property (nonatomic, copy) NSArray *unitArr;
/** 单位label数组 */
@property (nonatomic, copy) NSArray <UILabel *> *unitLabelArr;
/** 获取所有月份名称 */
@property (nonatomic, copy) NSArray <NSString *> *monthNames;

@end

@implementation BRDatePickerView

#pragma mark - 1.显示时间选择器
+ (void)showDatePickerWithMode:(BRDatePickerMode)mode
                         title:(NSString *)title
                   selectValue:(NSString *)selectValue
                   resultBlock:(BRDateResultBlock)resultBlock {
    [self showDatePickerWithMode:mode title:title selectValue:selectValue minDate:nil maxDate:nil isAutoSelect:NO resultBlock:resultBlock];
}

#pragma mark - 2.显示时间选择器
+ (void)showDatePickerWithMode:(BRDatePickerMode)mode
                         title:(NSString *)title
                   selectValue:(NSString *)selectValue
                  isAutoSelect:(BOOL)isAutoSelect
                   resultBlock:(BRDateResultBlock)resultBlock {
    [self showDatePickerWithMode:mode title:title selectValue:selectValue minDate:nil maxDate:nil isAutoSelect:isAutoSelect resultBlock:resultBlock];
}

#pragma mark - 3.显示时间选择器
+ (void)showDatePickerWithMode:(BRDatePickerMode)mode
                         title:(NSString *)title
                   selectValue:(NSString *)selectValue
                       minDate:(NSDate *)minDate
                       maxDate:(NSDate *)maxDate
                  isAutoSelect:(BOOL)isAutoSelect
                   resultBlock:(BRDateResultBlock)resultBlock {
    // 创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    datePickerView.pickerMode = mode;
    datePickerView.title = title;
    datePickerView.selectValue = selectValue;
    datePickerView.minDate = minDate;
    datePickerView.maxDate = maxDate;
    datePickerView.isAutoSelect = isAutoSelect;
    datePickerView.resultBlock = resultBlock;
    // 显示
    [datePickerView show];
}

#pragma mark - 初始化时间选择器
- (instancetype)initWithPickerMode:(BRDatePickerMode)pickerMode {
    if (self = [super init]) {
        self.pickerMode = pickerMode;
    }
    return self;
}

#pragma mark - 处理选择器数据
- (void)handlerPickerData {
    // 1.最小日期限制
    if (!self.minDate) {
        if (self.pickerMode == BRDatePickerModeMDHM) {
            self.minDate = [NSDate br_setMonth:1 day:1 hour:0 minute:0];
        } else if (self.pickerMode == BRDatePickerModeMD) {
            self.minDate = [NSDate br_setMonth:1 day:1];
        } else if (self.pickerMode == BRDatePickerModeTime || self.pickerMode == BRDatePickerModeCountDownTimer || self.pickerMode == BRDatePickerModeHM) {
            self.minDate = [NSDate br_setHour:0 minute:0];
        } else if (self.pickerMode == BRDatePickerModeHMS) {
            self.minDate = [NSDate br_setHour:0 minute:0 second:0];
        } else if (self.pickerMode == BRDatePickerModeMS) {
            self.minDate = [NSDate br_setMinute:0 second:0];
        } else {
            self.minDate = [NSDate distantPast]; // 遥远的过去的一个时间点
        }
    }
    // 2.最大日期限制
    if (!self.maxDate) {
        if (self.pickerMode == BRDatePickerModeMDHM) {
            self.maxDate = [NSDate br_setMonth:12 day:31 hour:23 minute:59];
        } else if (self.pickerMode == BRDatePickerModeMD) {
            self.maxDate = [NSDate br_setMonth:12 day:31];
        } else if (self.pickerMode == BRDatePickerModeTime || self.pickerMode == BRDatePickerModeCountDownTimer || self.pickerMode == BRDatePickerModeHM) {
            self.maxDate = [NSDate br_setHour:23 minute:59];
        } else if (self.pickerMode == BRDatePickerModeHMS) {
            self.maxDate = [NSDate br_setHour:23 minute:59 second:59];
        } else if (self.pickerMode == BRDatePickerModeMS) {
            self.maxDate = [NSDate br_setMinute:59 second:59];
        } else {
            self.maxDate = [NSDate distantFuture]; // 遥远的未来的一个时间点
        }
    }
    BOOL minMoreThanMax = [self.minDate br_compare:self.maxDate format:self.dateFormatter] == NSOrderedDescending;
    NSAssert(!minMoreThanMax, @"最小日期不能大于最大日期！");
    if (minMoreThanMax) {
        // 如果最小日期大于了最大日期，就忽略两个值
        self.minDate = [NSDate distantPast];
        self.maxDate = [NSDate distantFuture];
    }
    
    // 3.默认选中的日期
    [self handlerDefaultSelectDate];
    
    if (self.style == BRDatePickerStyleCustom) {
        
        // 4.初始化选择器日期列表数据
        [self initDateArray];
        
        // 5.默认选中的索引
        self.yearIndex = [self.yearArr indexOfObject:[self getYearNumber:self.mSelectDate.br_year]];
        self.monthIndex = [self.monthArr indexOfObject:[self getMDHMSNumber:self.mSelectDate.br_month]];
        self.dayIndex = [self.dayArr indexOfObject:[self getMDHMSNumber:self.mSelectDate.br_day]];
        NSInteger hourIndex = 0;
        if (self.pickerMode == BRDatePickerModeYMDH && self.isShowAMAndPM) {
            hourIndex = (self.mSelectDate.br_hour < 12 ? 0 : 1);
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %@", (int)self.mSelectDate.br_year, (int)self.mSelectDate.br_month, (int)self.mSelectDate.br_day, self.hourArr[hourIndex]];
        } else {
            hourIndex = [self.hourArr indexOfObject:[self getMDHMSNumber:self.mSelectDate.br_hour]];
        }
        self.hourIndex = hourIndex;
        self.minuteIndex = [self.minuteArr indexOfObject:[self getMDHMSNumber:self.mSelectDate.br_minute]];
        self.secondIndex = [self.secondArr indexOfObject:[self getMDHMSNumber:self.mSelectDate.br_second]];
    }
}

- (void)handlerDefaultSelectDate {
    // selectDate 优先级高于 selectValue（推荐使用 selectDate 设置默认选中的时间）
    if (!self.selectDate) {
        if (self.selectValue && self.selectValue.length > 0) {
            if (self.pickerMode == BRDatePickerModeYMDH && self.isShowAMAndPM) {
                NSString *firstString = [[self.selectValue componentsSeparatedByString:@" "] firstObject];
                NSString *lastString = [[self.selectValue componentsSeparatedByString:@" "] lastObject];
                if ([lastString isEqualToString:[self getAMText]]) {
                    self.selectValue = [NSString stringWithFormat:@"%@ 00", firstString];
                }
                if ([lastString isEqualToString:[self getPMText]]) {
                    self.selectValue = [NSString stringWithFormat:@"%@ 12", firstString];
                }
            }
            
            NSDate *defaultSelDate = [self.selectValue isEqualToString:[self getNowString]] ? [NSDate date] : [NSDate br_getDate:self.selectValue format:self.dateFormatter];
            if (!defaultSelDate) {
                BRErrorLog(@"参数异常！字符串 selectValue 的正确格式是：%@", self.dateFormatter);
                NSAssert(defaultSelDate, @"参数异常！请检查字符串 selectValue 的格式");
                defaultSelDate = [NSDate date]; // 默认值参数格式错误时，重置/忽略默认值，防止在 Release 环境下崩溃！
            }
            if (self.pickerMode == BRDatePickerModeMDHM) {
                self.mSelectDate = [NSDate br_setMonth:defaultSelDate.br_month day:defaultSelDate.br_day hour:defaultSelDate.br_hour minute:defaultSelDate.br_minute];
            } else if (self.pickerMode == BRDatePickerModeMD) {
                self.mSelectDate = [NSDate br_setMonth:defaultSelDate.br_month day:defaultSelDate.br_day];
            } else if (self.pickerMode == BRDatePickerModeTime || self.pickerMode == BRDatePickerModeCountDownTimer || self.pickerMode == BRDatePickerModeHM) {
                self.mSelectDate = [NSDate br_setHour:defaultSelDate.br_hour minute:defaultSelDate.br_minute];
            } else if (self.pickerMode == BRDatePickerModeHMS) {
                self.mSelectDate = [NSDate br_setHour:defaultSelDate.br_hour minute:defaultSelDate.br_minute second:defaultSelDate.br_second];
            } else if (self.pickerMode == BRDatePickerModeMS) {
                self.mSelectDate = [NSDate br_setMinute:defaultSelDate.br_minute second:defaultSelDate.br_second];
            } else {
                self.mSelectDate = defaultSelDate;
            }
        } else {
            // 不设置默认日期，就默认选中今天的日期
            self.mSelectDate = [NSDate date];
        }
    }
    BOOL selectLessThanMin = [self.mSelectDate br_compare:self.minDate format:self.dateFormatter] == NSOrderedAscending;
    BOOL selectMoreThanMax = [self.mSelectDate br_compare:self.maxDate format:self.dateFormatter] == NSOrderedDescending;
    if (selectLessThanMin) {
        BRErrorLog(@"默认选择的日期不能小于最小日期！");
        self.mSelectDate = self.minDate;
    }
    if (selectMoreThanMax) {
        BRErrorLog(@"默认选择的日期不能大于最大日期！");
        self.mSelectDate = self.maxDate;
    }
    if (!self.selectValue || ![self.selectValue isEqualToString:[self getNowString]]) {
        self.mSelectValue = [NSDate br_getDateString:self.mSelectDate format:self.dateFormatter];
    }
}

- (void)setupDateFormatter:(BRDatePickerMode)mode {
    switch (mode) {
        case BRDatePickerModeDate:
        {
            self.dateFormatter = @"yyyy-MM-dd";
            self.style = BRDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeDate;
        }
            break;
        case BRDatePickerModeDateAndTime:
        {
            self.dateFormatter = @"yyyy-MM-dd HH:mm";
            self.style = BRDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeDateAndTime;
        }
            break;
        case BRDatePickerModeTime:
        {
            self.dateFormatter = @"HH:mm";
            self.style = BRDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeTime;
        }
            break;
        case BRDatePickerModeCountDownTimer:
        {
            self.dateFormatter = @"HH:mm";
            self.style = BRDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeCountDownTimer;
        }
            break;
            
        case BRDatePickerModeYMDHMS:
        {
            self.dateFormatter = @"yyyy-MM-dd HH:mm:ss";
            self.style = BRDatePickerStyleCustom;
            self.unitArr = @[[self getYearUnit], [self getMonthUnit], [self getDayUnit], [self getHourUnit], [self getMinuteUnit], [self getSecondUnit]];
        }
            break;
        case BRDatePickerModeYMDHM:
        {
            self.dateFormatter = @"yyyy-MM-dd HH:mm";
            self.style = BRDatePickerStyleCustom;
            self.unitArr = @[[self getYearUnit], [self getMonthUnit], [self getDayUnit], [self getHourUnit], [self getMinuteUnit]];
        }
            break;
        case BRDatePickerModeYMDH:
        {
            self.dateFormatter = @"yyyy-MM-dd HH";
            self.style = BRDatePickerStyleCustom;
            self.unitArr = @[[self getYearUnit], [self getMonthUnit], [self getDayUnit], self.pickerMode == BRDatePickerModeYMDH && self.isShowAMAndPM ? @"" : [self getHourUnit]];
        }
            break;
        case BRDatePickerModeMDHM:
        {
            self.dateFormatter = @"MM-dd HH:mm";
            self.style = BRDatePickerStyleCustom;
            self.unitArr = @[[self getMonthUnit], [self getDayUnit], [self getHourUnit], [self getMinuteUnit]];
        }
            break;
        case BRDatePickerModeYMD:
        {
            self.dateFormatter = @"yyyy-MM-dd";
            self.style = BRDatePickerStyleCustom;
            self.unitArr = @[[self getYearUnit], [self getMonthUnit], [self getDayUnit]];
        }
            break;
        case BRDatePickerModeYM:
        {
            self.dateFormatter = @"yyyy-MM";
            self.style = BRDatePickerStyleCustom;
            self.unitArr = @[[self getYearUnit], [self getMonthUnit]];
        }
            break;
        case BRDatePickerModeY:
        {
            self.dateFormatter = @"yyyy";
            self.style = BRDatePickerStyleCustom;
            self.unitArr = @[[self getYearUnit]];
        }
            break;
        case BRDatePickerModeMD:
        {
            self.dateFormatter = @"MM-dd";
            self.style = BRDatePickerStyleCustom;
            self.unitArr = @[[self getMonthUnit], [self getDayUnit]];
        }
            break;
        case BRDatePickerModeHMS:
        {
            self.dateFormatter = @"HH:mm:ss";
            self.style = BRDatePickerStyleCustom;
            self.unitArr = @[[self getHourUnit], [self getMinuteUnit], [self getSecondUnit]];
        }
            break;
        case BRDatePickerModeHM:
        {
            self.dateFormatter = @"HH:mm";
            self.style = BRDatePickerStyleCustom;
            self.unitArr = @[[self getHourUnit], [self getMinuteUnit]];
        }
            break;
        case BRDatePickerModeMS:
        {
            self.dateFormatter = @"mm:ss";
            self.style = BRDatePickerStyleCustom;
            self.unitArr = @[[self getMinuteUnit], [self getSecondUnit]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置默认日期数据源
- (void)initDateArray {
    if (self.selectValue && [self.selectValue isEqualToString:[self getNowString]]) {
        switch (self.pickerMode) {
            case BRDatePickerModeYMDHMS:
            case BRDatePickerModeYMDHM:
            case BRDatePickerModeYMDH:
            case BRDatePickerModeYMD:
            case BRDatePickerModeYM:
            case BRDatePickerModeY:
            {
                self.yearArr = [self getYearArr];
                self.monthArr = nil;
                self.dayArr = nil;
                self.hourArr = nil;
                self.minuteArr = nil;
                self.secondArr = nil;
            }
                break;
            case BRDatePickerModeMDHM:
            case BRDatePickerModeMD:
            {
                self.yearArr = [self getYearArr];
                self.monthArr = [self getMonthArr:self.mSelectDate.br_year];
                self.dayArr = nil;
                self.hourArr = nil;
                self.minuteArr = nil;
                self.secondArr = nil;
            }
                break;
            case BRDatePickerModeHMS:
            case BRDatePickerModeHM:
            {
                self.yearArr = [self getYearArr];
                self.monthArr = [self getMonthArr:self.mSelectDate.br_year];
                self.dayArr = [self getDayArr:self.mSelectDate.br_year month:self.mSelectDate.br_month];
                self.hourArr = [self getHourArr:self.mSelectDate.br_year month:self.mSelectDate.br_month day:self.mSelectDate.br_day];
                self.minuteArr = nil;
                self.secondArr = nil;
            }
                break;
            case BRDatePickerModeMS:
            {
                self.yearArr = [self getYearArr];
                self.monthArr = [self getMonthArr:self.mSelectDate.br_year];
                self.dayArr = [self getDayArr:self.mSelectDate.br_year month:self.mSelectDate.br_month];
                self.hourArr = [self getHourArr:self.mSelectDate.br_year month:self.mSelectDate.br_month day:self.mSelectDate.br_day];
                self.minuteArr = [self getMinuteArr:self.mSelectDate.br_year month:self.mSelectDate.br_month day:self.mSelectDate.br_day hour:self.mSelectDate.br_hour];
                self.secondArr = nil;
            }
                break;
                
            default:
                break;
        }
    } else {
        self.yearArr = [self getYearArr];
        self.monthArr = [self getMonthArr:self.mSelectDate.br_year];
        self.dayArr = [self getDayArr:self.mSelectDate.br_year month:self.mSelectDate.br_month];
        self.hourArr = [self getHourArr:self.mSelectDate.br_year month:self.mSelectDate.br_month day:self.mSelectDate.br_day];
        self.minuteArr = [self getMinuteArr:self.mSelectDate.br_year month:self.mSelectDate.br_month day:self.mSelectDate.br_day hour:self.mSelectDate.br_hour];
        self.secondArr = [self getSecondArr:self.mSelectDate.br_year month:self.mSelectDate.br_month day:self.mSelectDate.br_day hour:self.mSelectDate.br_hour minute:self.mSelectDate.br_minute];
    }
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
    
    // 4.更新 minuteArr
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
    NSString *minuteString = self.minuteArr[self.minuteIndex];
    // 如果 minuteString = 至今
    if (self.isAddToNow && [minuteString isEqualToString:[self getNowString]]) {
        self.secondArr = nil;
        return;
    }
    if (updateSecond) {
        self.secondArr = [self getSecondArr:[yearString integerValue] month:[monthString integerValue] day:day hour:[hourString integerValue] minute:[minuteString integerValue]];
    }
}

// 获取 yearArr 数组
- (NSArray *)getYearArr {
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = self.minDate.br_year; i <= self.maxDate.br_year; i++) {
        [tempArr addObject:[self getYearNumber:i]];
    }
    // 判断是否需要添加【至今】
    if (self.isAddToNow) {
        switch (self.pickerMode) {
            case BRDatePickerModeYMDHMS:
            case BRDatePickerModeYMDHM:
            case BRDatePickerModeYMDH:
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
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
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
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = startMonth; i <= endMonth; i++) {
        [tempArr addObject:[self getMDHMSNumber:i]];
    }
    // 判断是否需要添加【至今】
    if (self.isAddToNow) {
        switch (self.pickerMode) {
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
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
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
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = startDay; i <= endDay; i++) {
        [tempArr addObject:[self getMDHMSNumber:i]];
    }
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
    }
    
    return [tempArr copy];
}

// 获取 hourArr 数组
- (NSArray *)getHourArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    if (self.pickerMode == BRDatePickerModeYMDH && self.isShowAMAndPM) {
        return @[[self getAMText], [self getPMText]];
    }
    
    NSInteger startHour = 0;
    NSInteger endHour = 23;
    if (year == self.minDate.br_year && month == self.minDate.br_month && day == self.minDate.br_day) {
        startHour = self.minDate.br_hour;
    }
    if (year == self.maxDate.br_year && month == self.maxDate.br_month && day == self.maxDate.br_day) {
        endHour = self.maxDate.br_hour;
    }
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = startHour; i <= endHour; i++) {
        [tempArr addObject:[self getMDHMSNumber:i]];
    }
    // 判断是否需要添加【至今】
    if (self.isAddToNow) {
        switch (self.pickerMode) {
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
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
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
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = startMinute; i <= endMinute; i += self.minuteInterval) {
        [tempArr addObject:[self getMDHMSNumber:i]];
    }
    // 判断是否需要添加【至今】
    if (self.isAddToNow) {
        switch (self.pickerMode) {
            case BRDatePickerModeMS:
            {
                [tempArr addObject:[self getNowString]];
            }
                break;
                
            default:
                break;
        }
    }
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
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
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = startSecond; i <= endSecond; i += self.secondInterval) {
        [tempArr addObject:[self getMDHMSNumber:i]];
    }
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
    }
    
    return [tempArr copy];
}

#pragma mark - 滚动到指定时间的位置
- (void)scrollToSelectDate:(NSDate *)selectDate animated:(BOOL)animated {
    NSInteger yearIndex = [self.yearArr indexOfObject:[self getYearNumber:selectDate.br_year]];
    NSInteger monthIndex = [self.monthArr indexOfObject:[self getMDHMSNumber:selectDate.br_month]];
    NSInteger dayIndex = [self.dayArr indexOfObject:[self getMDHMSNumber:selectDate.br_day]];
    NSInteger hourIndex = 0;
    if (self.pickerMode == BRDatePickerModeYMDH && self.isShowAMAndPM) {
        hourIndex = selectDate.br_hour < 12 ? 0 : 1;
    } else {
        hourIndex = [self.hourArr indexOfObject:[self getMDHMSNumber:selectDate.br_hour]];
    }
    NSInteger minuteIndex = [self.minuteArr indexOfObject:[self getMDHMSNumber:selectDate.br_minute]];
    NSInteger secondIndex = [self.secondArr indexOfObject:[self getMDHMSNumber:selectDate.br_second]];
    NSArray *indexArr = [NSArray array];
    if (self.pickerMode == BRDatePickerModeYMDHMS) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex), @(secondIndex)];
    } else if (self.pickerMode == BRDatePickerModeYMDHM) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex)];
    } else if (self.pickerMode == BRDatePickerModeYMDH) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex), @(hourIndex)];
    } else if (self.pickerMode == BRDatePickerModeMDHM) {
        indexArr = @[@(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex)];
    } else if (self.pickerMode == BRDatePickerModeYMD) {
        if ([self.pickerStyle.language hasPrefix:@"zh"]) {
            indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex)];
        } else {
            indexArr = @[@(dayIndex), @(monthIndex), @(yearIndex)];
        }
    } else if (self.pickerMode == BRDatePickerModeYM) {
        if ([self.pickerStyle.language hasPrefix:@"zh"]) {
            indexArr = @[@(yearIndex), @(monthIndex)];
        } else {
            indexArr = @[@(monthIndex), @(yearIndex)];
        }
    } else if (self.pickerMode == BRDatePickerModeY) {
        indexArr = @[@(yearIndex)];
    } else if (self.pickerMode == BRDatePickerModeMD) {
        indexArr = @[@(monthIndex), @(dayIndex)];
    } else if (self.pickerMode == BRDatePickerModeHMS) {
        indexArr = @[@(hourIndex), @(minuteIndex), @(secondIndex)];
    } else if (self.pickerMode == BRDatePickerModeHM) {
        indexArr = @[@(hourIndex), @(minuteIndex)];
    } else if (self.pickerMode == BRDatePickerModeMS) {
        indexArr = @[@(minuteIndex), @(secondIndex)];
    }
    for (NSInteger i = 0; i < indexArr.count; i++) {
        [self.pickerView selectRow:[indexArr[i] integerValue] inComponent:i animated:animated];
    }
}

#pragma mark - 滚动到【至今】的位置
- (void)scrollToNowDate:(BOOL)animated {
    switch (self.pickerMode) {
        case BRDatePickerModeYMDHMS:
        case BRDatePickerModeYMDHM:
        case BRDatePickerModeYMDH:
        case BRDatePickerModeYMD:
        case BRDatePickerModeYM:
        case BRDatePickerModeY:
        {
            NSInteger yearIndex = self.yearArr.count > 0 ? self.yearArr.count - 1 : 0;
            NSInteger component = 0;
            if (self.pickerMode == BRDatePickerModeYMD && ![self.pickerStyle.language hasPrefix:@"zh"]) {
                component = 2;
            }
            if (self.pickerMode == BRDatePickerModeYM && ![self.pickerStyle.language hasPrefix:@"zh"]) {
                component = 1;
            }
            [self.pickerView selectRow:yearIndex inComponent:component animated:animated];
        }
            break;
        case BRDatePickerModeMDHM:
        case BRDatePickerModeMD:
        {
            NSInteger monthIndex = self.monthArr.count > 0 ? self.monthArr.count - 1 : 0;
            [self.pickerView selectRow:monthIndex inComponent:0 animated:animated];
        }
            break;
        case BRDatePickerModeHMS:
        case BRDatePickerModeHM:
        {
            NSInteger hourIndex = self.hourArr.count > 0 ? self.hourArr.count - 1 : 0;
            [self.pickerView selectRow:hourIndex inComponent:0 animated:animated];
        }
            break;
        case BRDatePickerModeMS:
        {
            NSInteger minuteIndex = self.minuteArr.count > 0 ? self.minuteArr.count - 1 : 0;
            [self.pickerView selectRow:minuteIndex inComponent:0 animated:animated];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 时间选择器1
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight + pickerHeaderViewHeight, SCREEN_WIDTH, self.pickerStyle.pickerHeight)];
        _datePicker.backgroundColor = self.pickerStyle.pickerColor;
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        // 滚动改变值的响应事件
        [_datePicker addTarget:self action:@selector(didSelectValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - 时间选择器2
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight + pickerHeaderViewHeight, SCREEN_WIDTH, self.pickerStyle.pickerHeight)];
        _pickerView.backgroundColor = self.pickerStyle.pickerColor;
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource
// 1.设置 pickerView 的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.pickerMode == BRDatePickerModeYMDHMS) {
        return 6;
    } else if (self.pickerMode == BRDatePickerModeYMDHM) {
        return 5;
    } else if (self.pickerMode == BRDatePickerModeYMDH) {
        return 4;
    } else if (self.pickerMode == BRDatePickerModeMDHM) {
        return 4;
    } else if (self.pickerMode == BRDatePickerModeYMD) {
        return 3;
    } else if (self.pickerMode == BRDatePickerModeYM) {
        return 2;
    } else if (self.pickerMode == BRDatePickerModeY) {
        return 1;
    } else if (self.pickerMode == BRDatePickerModeMD) {
        return 2;
    } else if (self.pickerMode == BRDatePickerModeHMS) {
        return 3;
    } else if (self.pickerMode == BRDatePickerModeHM) {
        return 2;
    } else if (self.pickerMode == BRDatePickerModeMS) {
        return 2;
    }
    return 0;
}

// 2.设置 pickerView 每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *rowsArr = [NSArray array];
    if (self.pickerMode == BRDatePickerModeYMDHMS) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count), @(self.secondArr.count)];
    } else if (self.pickerMode == BRDatePickerModeYMDHM) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count)];
    } else if (self.pickerMode == BRDatePickerModeYMDH) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count)];
    } else if (self.pickerMode == BRDatePickerModeMDHM) {
        rowsArr = @[@(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count)];
    } else if (self.pickerMode == BRDatePickerModeYMD) {
        if ([self.pickerStyle.language hasPrefix:@"zh"]) {
            rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count)];
        } else {
            rowsArr = @[@(self.dayArr.count), @(self.monthArr.count), @(self.yearArr.count)];
        }
    } else if (self.pickerMode == BRDatePickerModeYM) {
        if ([self.pickerStyle.language hasPrefix:@"zh"]) {
            rowsArr = @[@(self.yearArr.count), @(self.monthArr.count)];
        } else {
            rowsArr = @[@(self.monthArr.count), @(self.yearArr.count)];
        }
    } else if (self.pickerMode == BRDatePickerModeY) {
        rowsArr = @[@(self.yearArr.count)];
    } else if (self.pickerMode == BRDatePickerModeMD) {
        rowsArr = @[@(self.monthArr.count), @(self.dayArr.count)];
    } else if (self.pickerMode == BRDatePickerModeHMS) {
        rowsArr = @[@(self.hourArr.count), @(self.minuteArr.count), @(self.secondArr.count)];
    } else if (self.pickerMode == BRDatePickerModeHM) {
        rowsArr = @[@(self.hourArr.count), @(self.minuteArr.count)];
    } else if (self.pickerMode == BRDatePickerModeMS) {
        rowsArr = @[@(self.minuteArr.count), @(self.secondArr.count)];
    }
    return [rowsArr[component] integerValue];
}

#pragma mark - UIPickerViewDelegate
// 3. 设置 pickerView 的显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    // 1.自定义 row 的内容视图
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
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    // 2.设置选择器中间选中行的样式
    [self setPickerSelectRowStyle:pickerView titleForRow:row forComponent:component];

    return label;
}

#pragma mark - 设置选择器中间选中行的样式
- (void)setPickerSelectRowStyle:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // 1.设置分割线的颜色
    for (UIView *subView in pickerView.subviews) {
        if (subView && [subView isKindOfClass:[UIView class]] && subView.frame.size.height <= 1) {
            subView.backgroundColor = self.pickerStyle.separatorColor;
        }
    }
    
    // 2.设置选择器中间选中行的背景颜色
    if (self.pickerStyle.selectRowColor) {
        UIView *contentView = nil;
        NSArray *subviews = pickerView.subviews;
        if (subviews.count > 0) {
            id obj = subviews.firstObject;
            if (obj && [obj isKindOfClass:[UIView class]]) {
                contentView = (UIView *)obj;
            }
        }
        UIView *columnView = nil;
        if (contentView) {
            id obj = [contentView valueForKey:@"subviewCache"];
            if (obj && [obj isKindOfClass:[NSArray class]]) {
                NSArray *columnViews = (NSArray *)obj;
                if (columnViews.count > 0) {
                    id columnObj = columnViews.firstObject;
                    if (columnObj && [columnObj isKindOfClass:[UIView class]]) {
                        columnView = (UIView *)columnObj;
                    }
                }
            }
        }
        if (columnView) {
            id obj = [columnView valueForKey:@"middleContainerView"];
            if (obj && [obj isKindOfClass:[UIView class]]) {
                UIView *selectRowView = (UIView *)obj;
                selectRowView.backgroundColor = self.pickerStyle.selectRowColor;
            }
        }
    }
    
    // 3.设置选择器中间选中行的字体颜色/字体大小
    if (self.pickerStyle.selectRowTextColor || self.pickerStyle.selectRowTextFont) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 当前选中的 label
            UILabel *selectLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
            if (selectLabel) {
                if (self.pickerStyle.selectRowTextColor) {
                    selectLabel.textColor = self.pickerStyle.selectRowTextColor;
                }
                if (self.pickerStyle.selectRowTextFont) {
                    selectLabel.font = self.pickerStyle.selectRowTextFont;
                }
                // 上一个选中的 label
                UILabel *lastLabel = (UILabel *)[pickerView viewForRow:row - 1 forComponent:component];
                if (lastLabel) {
                    lastLabel.textColor = self.pickerStyle.pickerTextColor;
                    lastLabel.font = self.pickerStyle.pickerTextFont;
                }
                // 下一个选中的 label
                UILabel *nextLabel = (UILabel*)[pickerView viewForRow:row + 1 forComponent:component];
                if (nextLabel) {
                    nextLabel.textColor = self.pickerStyle.pickerTextColor;
                    nextLabel.font = self.pickerStyle.pickerTextFont;
                }
            }
        });
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *titleString = @"";
    if (self.pickerMode == BRDatePickerModeYMDHMS) {
        if (component == 0) {
            titleString = [self getYearText:row];
        } else if (component == 1) {
            titleString = [self getMonthText:row];
        } else if (component == 2) {
            titleString = [self getDayText:row];
        } else if (component == 3) {
            titleString = [self getHourText:row];
        } else if (component == 4) {
            titleString = [self getMinuteText:row];
        } else if (component == 5) {
            titleString = [self getSecondText:row];
        }
    } else if (self.pickerMode == BRDatePickerModeYMDHM) {
        if (component == 0) {
            titleString = [self getYearText:row];
        } else if (component == 1) {
            titleString = [self getMonthText:row];
        } else if (component == 2) {
            titleString = [self getDayText:row];
        } else if (component == 3) {
            titleString = [self getHourText:row];
        } else if (component == 4) {
            titleString = [self getMinuteText:row];
        }
    } else if (self.pickerMode == BRDatePickerModeYMDH) {
        if (component == 0) {
            titleString = [self getYearText:row];
        } else if (component == 1) {
            titleString = [self getMonthText:row];
        } else if (component == 2) {
            titleString = [self getDayText:row];
        } else if (component == 3) {
            titleString = [self getHourText:row];
        }
    } else if (self.pickerMode == BRDatePickerModeMDHM) {
        if (component == 0) {
            titleString = [self getMonthText:row];
        } else if (component == 1) {
            titleString = [self getDayText:row];
        } else if (component == 2) {
            titleString = [self getHourText:row];
        } else if (component == 3) {
            titleString = [self getMinuteText:row];
        }
    } else if (self.pickerMode == BRDatePickerModeYMD) {
        if (component == 0) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getYearText:row] : [self getDayText:row];
        } else if (component == 1) {
            titleString = [self getMonthText:row];
        } else if (component == 2) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getDayText:row] : [self getYearText:row];
        }
    } else if (self.pickerMode == BRDatePickerModeYM) {
        if (component == 0) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getYearText:row] : [self getMonthText:row];
        } else if (component == 1) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getMonthText:row] : [self getYearText:row];
        }
    } else if (self.pickerMode == BRDatePickerModeY) {
        if (component == 0) {
            titleString = [self getYearText:row];
        }
    } else if (self.pickerMode == BRDatePickerModeMD) {
        if (component == 0) {
            titleString = [self getMonthText:row];
        } else if (component == 1) {
            titleString = [self getDayText:row];
        }
    } else if (self.pickerMode == BRDatePickerModeHMS) {
        if (component == 0) {
            titleString = [self getHourText:row];
        } else if (component == 1) {
            titleString = [self getMinuteText:row];
        } else if (component == 2) {
            titleString = [self getSecondText:row];
        }
    } else if (self.pickerMode == BRDatePickerModeHM) {
        if (component == 0) {
            titleString = [self getHourText:row];
        } else if (component == 1) {
            titleString = [self getMinuteText:row];
        }
    } else if (self.pickerMode == BRDatePickerModeMS) {
        if (component == 0) {
            titleString = [self getMinuteText:row];
        } else if (component == 1) {
            titleString = [self getSecondText:row];
        }
    }
    
    return titleString;
}

// 4.滚动 pickerView 执行的回调方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *lastSelectValue = self.mSelectValue;
    if (self.pickerMode == BRDatePickerModeYMDHMS) {
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
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count * self.hourArr.count * self.minuteArr.count * self.secondArr.count == 0) return;
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            int second = [self.secondArr[self.secondIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day hour:hour minute:minute second:second];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second];
        } else {
            self.mSelectDate = [NSDate date];
            self.mSelectValue = [self getNowString];
        }
        
    } else if (self.pickerMode == BRDatePickerModeYMDHM) {
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
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count * self.hourArr.count * self.minuteArr.count == 0) return;
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day hour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute];
        } else {
            self.mSelectDate = [NSDate date];
            self.mSelectValue = [self getNowString];
        }
        
    } else if (self.pickerMode == BRDatePickerModeYMDH) {
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
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count * self.hourArr.count == 0) return;
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            int hour = 0;
            if (self.pickerMode == BRDatePickerModeYMDH && self.isShowAMAndPM) {
                hour = (self.hourIndex == 0 ? 0 : 12);
                self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %@", year, month, day, self.hourArr[self.hourIndex]];
            } else {
                hour = [self.hourArr[self.hourIndex] intValue];
                self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %02d", year, month, day, hour];
            }
            self.mSelectDate = [NSDate br_setYear:year month:month day:day hour:hour];
        } else {
            self.mSelectDate = [NSDate date];
            self.mSelectValue = [self getNowString];
        }
        
    } else if (self.pickerMode == BRDatePickerModeMDHM) {
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
            if (self.monthArr.count * self.dayArr.count * self.hourArr.count * self.minuteArr.count == 0) return;
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            self.mSelectDate = [NSDate br_setMonth:month day:day hour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%02d-%02d %02d:%02d", month, day, hour, minute];
        } else {
            self.mSelectDate = [NSDate date];
            self.mSelectValue = [self getNowString];
        }
        
    } else if (self.pickerMode == BRDatePickerModeYMD) {
        if (component == 0) {
            if ([self.pickerStyle.language hasPrefix:@"zh"]) {
                self.yearIndex = row;
                [self reloadDateArrayWithUpdateMonth:YES updateDay:YES updateHour:NO updateMinute:NO updateSecond:NO];
                [self.pickerView reloadComponent:1];
                [self.pickerView reloadComponent:2];
            } else {
                self.dayIndex = row;
            }
        } else if (component == 1) {
            self.monthIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:YES updateHour:NO updateMinute:NO updateSecond:NO];
            if ([self.pickerStyle.language hasPrefix:@"zh"]) {
                [self.pickerView reloadComponent:2];
            } else {
                [self.pickerView reloadComponent:0];
            }
        } else if (component == 2) {
            if ([self.pickerStyle.language hasPrefix:@"zh"]) {
                self.dayIndex = row;
            } else {
                self.yearIndex = row;
                [self reloadDateArrayWithUpdateMonth:YES updateDay:YES updateHour:NO updateMinute:NO updateSecond:NO];
                [self.pickerView reloadComponent:0];
                [self.pickerView reloadComponent:1];
            }
        }
        
        NSString *yearString = self.yearArr[self.yearIndex];
        if (![yearString isEqualToString:[self getNowString]]) {
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count == 0) return;
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d", year, month, day];
        } else {
            self.mSelectDate = [NSDate date];
            self.mSelectValue = [self getNowString];
        }
        
    } else if (self.pickerMode == BRDatePickerModeYM) {
        if (component == 0) {
            if ([self.pickerStyle.language hasPrefix:@"zh"]) {
                self.yearIndex = row;
                [self reloadDateArrayWithUpdateMonth:YES updateDay:NO updateHour:NO updateMinute:NO updateSecond:NO];
                [self.pickerView reloadComponent:1];
            } else {
                self.monthIndex = row;
            }
        } else if (component == 1) {
            if ([self.pickerStyle.language hasPrefix:@"zh"]) {
                self.monthIndex = row;
            } else {
                self.yearIndex = row;
                [self reloadDateArrayWithUpdateMonth:YES updateDay:NO updateHour:NO updateMinute:NO updateSecond:NO];
                [self.pickerView reloadComponent:0];
            }
        }
        
        NSString *yearString = self.yearArr[self.yearIndex];
        if (![yearString isEqualToString:[self getNowString]]) {
            if (self.yearArr.count * self.monthArr.count == 0) return;
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d", year, month];
        } else {
            self.mSelectDate = [NSDate date];
            self.mSelectValue = [self getNowString];
        }
    } else if (self.pickerMode == BRDatePickerModeY) {
        if (component == 0) {
            self.yearIndex = row;
        }
        
        NSString *yearString = self.yearArr[self.yearIndex];
        if (![yearString isEqualToString:[self getNowString]]) {
            if (self.yearArr.count == 0) return;
            int year = [self.yearArr[self.yearIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year];
            self.mSelectValue = [NSString stringWithFormat:@"%04d", year];
        } else {
            self.mSelectDate = [NSDate date];
            self.mSelectValue = [self getNowString];
        }
        
    } else if (self.pickerMode == BRDatePickerModeMD) {
        if (component == 0) {
            self.monthIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:YES updateHour:NO updateMinute:NO updateSecond:NO];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            self.dayIndex = row;
        }
        
        NSString *monthString = self.monthArr[self.monthIndex];
        if (![monthString isEqualToString:[self getNowString]]) {
            if (self.monthArr.count * self.dayArr.count == 0) return;
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            self.mSelectDate = [NSDate br_setMonth:month day:day];
            self.mSelectValue = [NSString stringWithFormat:@"%02d-%02d", month, day];
        } else {
            self.mSelectDate = [NSDate date];
            self.mSelectValue = [self getNowString];
        }
        
    } else if (self.pickerMode == BRDatePickerModeHMS) {
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
            if (self.hourArr.count * self.minuteArr.count * self.secondArr.count == 0) return;
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            int second = [self.secondArr[self.secondIndex] intValue];
            self.mSelectDate = [NSDate br_setHour:hour minute:minute second:second];
            self.mSelectValue = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
        } else {
            self.mSelectDate = [NSDate date];
            self.mSelectValue = [self getNowString];
        }
        
    } else if (self.pickerMode == BRDatePickerModeHM) {
        if (component == 0) {
            self.hourIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:NO updateMinute:YES updateSecond:NO];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            self.minuteIndex = row;
        }
        
        NSString *hourString = self.hourArr[self.hourIndex];
        if (![hourString isEqualToString:[self getNowString]]) {
            if (self.hourArr.count * self.minuteArr.count == 0) return;
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            self.mSelectDate = [NSDate br_setHour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%02d:%02d", hour, minute];
        } else {
            self.mSelectDate = [NSDate date];
            self.mSelectValue = [self getNowString];
        }
    } else if (self.pickerMode == BRDatePickerModeMS) {
        if (component == 0) {
            self.minuteIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:NO updateMinute:NO updateSecond:YES];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            self.secondIndex = row;
        }
        
        NSString *minuteString = self.minuteArr[self.minuteIndex];
        if (![minuteString isEqualToString:[self getNowString]]) {
            if (self.minuteArr.count * self.secondArr.count == 0) return;
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            int second = [self.secondArr[self.secondIndex] intValue];
            self.mSelectDate = [NSDate br_setMinute:minute second:second];
            self.mSelectValue = [NSString stringWithFormat:@"%02d:%02d", minute, second];
        } else {
            self.mSelectDate = [NSDate date];
            self.mSelectValue = [self getNowString];
        }
    }
    
    // 由 至今 滚动到 其它时间时，回滚到上次选择的位置
    if ([lastSelectValue isEqualToString:[self getNowString]] && ![self.mSelectValue isEqualToString:[self getNowString]]) {
        [self scrollToSelectDate:self.mSelectDate animated:NO];
    }
    
    // 滚动选择时执行 changeBlock 回调
    if (self.changeBlock) {
        self.changeBlock(self.mSelectDate, self.mSelectValue);
    }
    
    // 设置自动选择时，滚动选择时就执行 resultBlock
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
    
    BOOL selectLessThanMin = [self.mSelectDate br_compare:self.minDate format:self.dateFormatter] == NSOrderedAscending;
    BOOL selectMoreThanMax = [self.mSelectDate br_compare:self.maxDate format:self.dateFormatter] == NSOrderedDescending;
    if (selectLessThanMin) {
        self.mSelectDate = self.minDate;
    }
    if (selectMoreThanMax) {
        self.mSelectDate = self.maxDate;
    }
    [self.datePicker setDate:self.mSelectDate animated:YES];
    
    self.mSelectValue = [NSDate br_getDateString:self.mSelectDate format:self.dateFormatter];
    
    // 滚动选择时执行 changeBlock 回调
    if (self.changeBlock) {
        self.changeBlock(self.mSelectDate, self.mSelectValue);
    }
    
    // 设置自动选择时，滚动选择时就执行 resultBlock
    if (self.isAutoSelect) {
        // 滚动完成后，执行block回调
        if (self.resultBlock) {
            self.resultBlock(self.mSelectDate, self.mSelectValue);
        }
    }
}

#pragma mark - 重写父类方法
- (void)reloadData {
    // 1.处理数据源
    [self handlerPickerData];
    if (self.style == BRDatePickerStyleSystem) {
        // 2.刷新选择器（重新设置相关值）
        self.datePicker.datePickerMode = _datePickerMode;
        // 设置该 UIDatePicker 的国际化 Locale
        self.datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:self.pickerStyle.language];
        // textColor 隐藏属性，使用KVC赋值
        [self.datePicker setValue:self.pickerStyle.pickerTextColor forKey:@"textColor"];
        if (self.minDate) {
            self.datePicker.minimumDate = self.minDate;
        }
        if (self.maxDate) {
            self.datePicker.maximumDate = self.maxDate;
        }
        if (_datePickerMode == UIDatePickerModeCountDownTimer && self.countDownDuration > 0) {
            self.datePicker.countDownDuration = self.countDownDuration;
        }
        if (self.minuteInterval > 1) {
            self.datePicker.minuteInterval = self.minuteInterval;
        }
        // 3.滚动到选择的时间
        [self.datePicker setDate:self.mSelectDate animated:NO];
    } else if (self.style == BRDatePickerStyleCustom) {
        // 2.刷新选择器
        [self.pickerView reloadAllComponents];
        // 3.滚动到选择的时间
        if (self.selectValue && [self.selectValue isEqualToString:[self getNowString]]) {
            [self scrollToNowDate:NO];
        } else {
            [self scrollToSelectDate:self.mSelectDate animated:NO];
        }
    }
}

- (void)addPickerToView:(UIView *)view {
    _containerView = view;
    [self setupDateFormatter:self.pickerMode];
    // 1.添加时间选择器
    if (self.style == BRDatePickerStyleSystem) {
        [self setPickerView:self.datePicker toView:view];
    } else if (self.style == BRDatePickerStyleCustom) {
        [self setPickerView:self.pickerView toView:view];
        if (self.showUnitType == BRShowUnitTypeOnlyCenter) {
            // 添加时间单位到选择器
            [self addUnitLabel];
        }
    }
    
    // 2.绑定数据
    [self reloadData];
    
    __weak typeof(self) weakSelf = self;
    self.doneBlock = ^{
        // 点击确定按钮后，执行block回调
        [weakSelf removePickerFromView:view];
        
        if (weakSelf.resultBlock) {
            weakSelf.resultBlock(weakSelf.mSelectDate, weakSelf.mSelectValue);
        }
    };
    
    [super addPickerToView:view];
}

- (void)setPickerView:(UIView *)pickerView toView:(UIView *)view {
    if (view) {
        // 立即刷新容器视图 view 的布局（防止 view 使用自动布局时，选择器视图无法正常显示）
        [view setNeedsLayout];
        [view layoutIfNeeded];
        
        self.frame = view.bounds;
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        CGFloat pickerFooterViewHeight = self.pickerFooterView ? self.pickerFooterView.bounds.size.height : 0;
        pickerView.frame = CGRectMake(0, pickerHeaderViewHeight, view.bounds.size.width, view.bounds.size.height - pickerHeaderViewHeight - pickerFooterViewHeight);
        [self addSubview:pickerView];
    } else {
        [self.alertView addSubview:pickerView];
    }
}

#pragma mark - 添加时间单位到选择器
- (void)addUnitLabel {
    if (self.unitLabelArr.count > 0) {
        for (UILabel *unitLabel in self.unitLabelArr) {
            [unitLabel removeFromSuperview];
        }
        self.unitLabelArr = nil;
    }
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < self.pickerView.numberOfComponents; i++) {
        // label宽度
        CGFloat labelWidth = self.pickerView.bounds.size.width / self.pickerView.numberOfComponents;
        // 根据占位文本长度去计算宽度
        NSString *tempText = @"00";
        if (i == 0) {
            switch (self.pickerMode) {
                case BRDatePickerModeYMDHMS:
                case BRDatePickerModeYMDHM:
                case BRDatePickerModeYMDH:
                case BRDatePickerModeYMD:
                case BRDatePickerModeYM:
                case BRDatePickerModeY:
                {
                    tempText = @"0000";
                }
                    break;
                    
                default:
                    break;
            }
        }
        // 文本宽度
        CGFloat labelTextWidth = [tempText boundingRectWithSize:CGSizeMake(MAXFLOAT, self.pickerStyle.rowHeight)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:@{NSFontAttributeName: self.pickerStyle.pickerTextFont}
                                                        context:nil].size.width;
        // 单位label
        UILabel *unitLabel = [[UILabel alloc]init];
        unitLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        unitLabel.backgroundColor = [UIColor clearColor];
        unitLabel.textAlignment = NSTextAlignmentCenter;
        unitLabel.font = self.pickerStyle.dateUnitTextFont;
        unitLabel.textColor = self.pickerStyle.dateUnitTextColor;
        // 字体自适应属性
        unitLabel.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        unitLabel.minimumScaleFactor = 0.5f;
        unitLabel.text = (self.unitArr.count > 0 && i < self.unitArr.count) ? self.unitArr[i] : nil;
        
        CGFloat originX = i * labelWidth + labelWidth / 2.0 + labelTextWidth / 2.0 + self.pickerStyle.dateUnitOffsetX;
        CGFloat originY = (self.pickerView.frame.size.height - self.pickerStyle.rowHeight) / 2 + self.pickerStyle.dateUnitOffsetY;
        unitLabel.frame = CGRectMake(originX, originY, self.pickerStyle.rowHeight, self.pickerStyle.rowHeight);
        
        if (self.style == BRDatePickerStyleSystem) {
            [self.datePicker addSubview:unitLabel];
        } else if (self.style == BRDatePickerStyleCustom) {
            [self.pickerView addSubview:unitLabel];
        }
        
        [tempArr addObject:unitLabel];
    }
    
    self.unitLabelArr = [tempArr copy];
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
    NSString *yearUnit = self.showUnitType == BRShowUnitTypeAll ? [self getYearUnit] : @"";
    return [NSString stringWithFormat:@"%@%@", yearString, yearUnit];
}

- (NSString *)getMonthText:(NSInteger)row {
    if ([self.pickerStyle.language hasPrefix:@"zh"]) {
        self.monthNameType = BRMonthNameTypeNumber;
    }
    NSString *monthString = self.monthArr[row];
    if (self.monthNameType != BRMonthNameTypeNumber && (self.pickerMode == BRDatePickerModeYMD || self.pickerMode == BRDatePickerModeYM)) {
        NSInteger index = [monthString integerValue] - 1;
        monthString = (index >= 0 && index < self.monthNames.count) ? self.monthNames[index] : @"";
    }
    if ([monthString isEqualToString:[self getNowString]]) {
        return monthString;
    }
    NSString *monthUnit = self.showUnitType == BRShowUnitTypeAll ? [self getMonthUnit] : @"";
    return [NSString stringWithFormat:@"%@%@", monthString, monthUnit];
}

- (NSString *)getDayText:(NSInteger)row {
    NSString *dayString = self.dayArr[row];
    if (self.isShowToday && self.mSelectDate.br_year == [NSDate date].br_year && self.mSelectDate.br_month == [NSDate date].br_month && [dayString integerValue] == [NSDate date].br_day) {
        return [NSBundle br_localizedStringForKey:@"今天" language:self.pickerStyle.language];
    }
    NSString *dayUnit = self.showUnitType == BRShowUnitTypeAll ? [self getDayUnit] : @"";
    dayString = [NSString stringWithFormat:@"%@%@", dayString, dayUnit];
    if (self.isShowWeek) {
        dayString = [NSString stringWithFormat:@"%@%@", dayString, [self getWeekday:row]];
    }
    return dayString;
}

- (NSString *)getHourText:(NSInteger)row {
    NSString *hourString = self.hourArr[row];
    if ([hourString isEqualToString:[self getNowString]]) {
        return hourString;
    }
    NSString *hourUnit = self.showUnitType == BRShowUnitTypeAll ? [self getHourUnit] : @"";
    return [NSString stringWithFormat:@"%@%@", hourString, hourUnit];
}

- (NSString *)getMinuteText:(NSInteger)row {
    NSString *minuteUnit = self.showUnitType == BRShowUnitTypeAll ? [self getMinuteUnit] : @"";
    return [NSString stringWithFormat:@"%@%@", self.minuteArr[row], minuteUnit];
}

- (NSString *)getSecondText:(NSInteger)row {
    NSString *secondUnit = self.showUnitType == BRShowUnitTypeAll ? [self getSecondUnit] : @"";
    return [NSString stringWithFormat:@"%@%@", self.secondArr[row], secondUnit];
}

- (NSString *)getWeekday:(NSInteger)dayRow {
    NSInteger day = [self.dayArr[dayRow] integerValue];
    NSDate *date = [NSDate br_setYear:self.mSelectDate.br_year month:self.mSelectDate.br_month day:day];
    return [NSBundle br_localizedStringForKey:[date br_weekdayString] language:self.pickerStyle.language];
}

- (NSString *)getYearNumber:(NSInteger)year {
    NSString *yearString = [NSString stringWithFormat:@"%@", @(year)];
    if (self.isNumberFullName) {
        yearString = [NSString stringWithFormat:@"%04d", [yearString intValue]];
    }
    return yearString;
}

- (NSString *)getMDHMSNumber:(NSInteger)number {
    NSString *string = [NSString stringWithFormat:@"%@", @(number)];
    if (self.isNumberFullName) {
        string = [NSString stringWithFormat:@"%02d", [string intValue]];
    }
    return string;
}

- (NSString *)getAMText {
    return [NSBundle br_localizedStringForKey:@"上午" language:self.pickerStyle.language];
}

- (NSString *)getPMText {
    return [NSBundle br_localizedStringForKey:@"下午" language:self.pickerStyle.language];
}

- (NSString *)getYearUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"年" language:self.pickerStyle.language];
}

- (NSString *)getMonthUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"月" language:self.pickerStyle.language];
}

- (NSString *)getDayUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"日" language:self.pickerStyle.language];
}

- (NSString *)getHourUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    if (self.pickerMode == BRDatePickerModeYMDH && self.isShowAMAndPM) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"时" language:self.pickerStyle.language];
}

- (NSString *)getMinuteUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"分" language:self.pickerStyle.language];
}

- (NSString *)getSecondUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"秒" language:self.pickerStyle.language];
}

#pragma mark - setter 方法
- (void)setPickerMode:(BRDatePickerMode)pickerMode {
    _pickerMode = pickerMode;
    // 非空，表示二次设置
    if (_datePicker || _pickerView) {
        BRDatePickerStyle lastStyle = self.style;
        [self setupDateFormatter:pickerMode];
        // 系统样式 切换到 自定义样式
        if (lastStyle == BRDatePickerStyleSystem && self.style == BRDatePickerStyleCustom) {
            [self.datePicker removeFromSuperview];
            [self setPickerView:self.pickerView toView:_containerView];
        }
        // 自定义样式 切换到 系统样式
        if (lastStyle == BRDatePickerStyleCustom && self.style == BRDatePickerStyleSystem) {
            [self.pickerView removeFromSuperview];
            [self setPickerView:self.datePicker toView:_containerView];
        }
        // 刷新选择器数据
        [self reloadData];
        if (self.style == BRDatePickerStyleCustom && self.showUnitType == BRShowUnitTypeOnlyCenter) {
            // 添加时间单位到选择器
            [self addUnitLabel];
        }
    }
}

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
        // 刷新选择器数据
        [self reloadData];
    }
}

- (void)setSelectValue:(NSString *)selectValue {
    _selectValue = selectValue;
    _mSelectValue = selectValue;
    if (_datePicker || _pickerView) {
        // 刷新选择器数据
        [self reloadData];
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
        _yearIndex = 0;
    } else {
        _yearIndex = MIN(_yearIndex, self.yearArr.count - 1);
    }
    return _yearIndex;
}

- (NSInteger)monthIndex {
    if (_monthIndex < 0) {
        _monthIndex = 0;
    } else {
        _monthIndex = MIN(_monthIndex, self.monthArr.count - 1);
    }
    return _monthIndex;
}

- (NSInteger)dayIndex {
    if (_dayIndex < 0) {
        _dayIndex = 0;
    } else {
        _dayIndex = MIN(_dayIndex, self.dayArr.count - 1);
    }
    return _dayIndex;
}

- (NSInteger)hourIndex {
    if (_hourIndex < 0) {
        _hourIndex = 0;
    } else {
        _hourIndex = MIN(_hourIndex, self.hourArr.count - 1);
    }
    return _hourIndex;
}

- (NSInteger)minuteIndex {
    if (_minuteIndex < 0) {
        _minuteIndex = 0;
    } else {
        _minuteIndex = MIN(_minuteIndex, self.minuteArr.count - 1);
    }
    return _minuteIndex;
}

- (NSInteger)secondIndex {
    if (_secondIndex < 0) {
        _secondIndex = 0;
    } else {
        _secondIndex = MIN(_secondIndex, self.secondArr.count - 1);
    }
    return _secondIndex;
}

- (NSInteger)minuteInterval {
    if (_minuteInterval < 1 || _minuteInterval > 30) {
        _minuteInterval = 1;
    }
    return _minuteInterval;
}

- (NSInteger)secondInterval {
    if (_secondInterval < 1 || _secondInterval > 30) {
        _secondInterval = 1;
    }
    return _secondInterval;
}

- (NSArray *)unitArr {
    if (!_unitArr) {
        _unitArr = [NSArray array];
    }
    return _unitArr;
}

- (NSArray<UILabel *> *)unitLabelArr {
    if (!_unitLabelArr) {
        _unitLabelArr = [NSArray array];
    }
    return _unitLabelArr;
}

- (NSArray<NSString *> *)monthNames {
    if (!_monthNames) {
        if (self.monthNameType == BRMonthNameTypeFullName) {
            _monthNames = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
        } else {
            _monthNames = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
        }
    }
    return _monthNames;
}

@end
