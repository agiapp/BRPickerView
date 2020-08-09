//
//  BRDatePickerView.m
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRDatePickerView.h"
#import "NSBundle+BRPickerView.h"
#import "BRDatePickerView+BR.h"

/// 时间选择器的类型
typedef NS_ENUM(NSInteger, BRDatePickerStyle) {
    BRDatePickerStyleSystem,   // 系统样式：使用 UIDatePicker
    BRDatePickerStyleCustom    // 自定义样式：使用 UIPickerView
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
    self.minDate = [self handlerMinDate:self.minDate];
    // 2.最大日期限制
    self.maxDate = [self handlerMaxDate:self.maxDate];
    
    BOOL minMoreThanMax = [self br_compareDate:self.minDate targetDate:self.maxDate dateFormat:self.dateFormatter] == NSOrderedDescending;
    NSAssert(!minMoreThanMax, @"最小日期不能大于最大日期！");
    if (minMoreThanMax) {
        // 如果最小日期大于了最大日期，就忽略两个值
        self.minDate = [NSDate distantPast];
        self.maxDate = [NSDate distantFuture];
    }
    
    // 3.默认选中的日期
    self.mSelectDate = [self handlerSelectDate:self.selectDate dateFormat:self.dateFormatter];
    
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
        NSInteger minuteIndex = 0;
        if ([self.minuteArr containsObject:[self getMDHMSNumber:self.mSelectDate.br_minute]]) {
            minuteIndex = [self.minuteArr indexOfObject:[self getMDHMSNumber:self.mSelectDate.br_minute]];
        }
        NSInteger secondIndex = 0;
        if ([self.secondArr containsObject:[self getMDHMSNumber:self.mSelectDate.br_second]]) {
            secondIndex = [self.secondArr indexOfObject:[self getMDHMSNumber:self.mSelectDate.br_second]];
        }
        self.minuteIndex = minuteIndex;
        self.secondIndex = secondIndex;
    }
    
    if (self.selectValue && [self.selectValue isEqualToString:self.addCustomString]) {
        self.mSelectDate = self.addToNow ? [NSDate date] : nil;
    } else {
        self.mSelectValue = [self br_stringFromDate:self.mSelectDate dateFormat:self.dateFormatter];
    }
}

#pragma mark - 设置默认日期数据源
- (void)initDateArray {
    if (self.selectValue && [self.selectValue isEqualToString:self.addCustomString]) {
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

#pragma mark - 更新日期数据源数组
- (void)reloadDateArrayWithUpdateMonth:(BOOL)updateMonth updateDay:(BOOL)updateDay updateHour:(BOOL)updateHour updateMinute:(BOOL)updateMinute updateSecond:(BOOL)updateSecond {
    // 1.更新 monthArr
    if (self.yearArr.count == 0) {
        return;
    }
    NSString *yearString = self.yearArr[self.yearIndex];
    if (self.addCustomString && [yearString isEqualToString:self.addCustomString]) {
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
    if (self.addCustomString && [monthString isEqualToString:self.addCustomString]) {
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
    if (self.addCustomString && [hourString isEqualToString:self.addCustomString]) {
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
    if (self.addCustomString && [minuteString isEqualToString:self.addCustomString]) {
        self.secondArr = nil;
        return;
    }
    if (updateSecond) {
        self.secondArr = [self getSecondArr:[yearString integerValue] month:[monthString integerValue] day:day hour:[hourString integerValue] minute:[minuteString integerValue]];
    }
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
    NSInteger minuteIndex = 0;
    if ([self.minuteArr containsObject:[self getMDHMSNumber:selectDate.br_minute]]) {
        minuteIndex = [self.minuteArr indexOfObject:[self getMDHMSNumber:selectDate.br_minute]];
    }
    NSInteger secondIndex = 0;
    if ([self.secondArr containsObject:[self getMDHMSNumber:selectDate.br_second]]) {
        secondIndex = [self.secondArr indexOfObject:[self getMDHMSNumber:selectDate.br_second]];
    }
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

#pragma mark - 滚动到【自定义字符串】的位置
- (void)scrollToCustomString:(BOOL)animated {
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
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight + pickerHeaderViewHeight, BRScreenWidth(), self.pickerStyle.pickerHeight)];
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
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight + pickerHeaderViewHeight, BRScreenWidth(), self.pickerStyle.pickerHeight)];
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
    [self setupPickerSelectRowStyle:pickerView titleForRow:row forComponent:component];

    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *titleString = @"";
    if (self.pickerMode == BRDatePickerModeYMDHMS) {
        if (component == 0) {
            titleString = [self getYearText:self.yearArr[row]];
        } else if (component == 1) {
            titleString = [self getMonthText:self.monthArr[row] monthNames:self.monthNames];
        } else if (component == 2) {
            titleString = [self getDayText:self.dayArr[row] mSelectDate:self.mSelectDate];
        } else if (component == 3) {
            titleString = [self getHourText:self.hourArr[row]];
        } else if (component == 4) {
            titleString = [self getMinuteText:self.minuteArr[row]];
        } else if (component == 5) {
            titleString = [self getSecondText:self.secondArr[row]];
        }
    } else if (self.pickerMode == BRDatePickerModeYMDHM) {
        if (component == 0) {
            titleString = [self getYearText:self.yearArr[row]];
        } else if (component == 1) {
            titleString = [self getMonthText:self.monthArr[row] monthNames:self.monthNames];
        } else if (component == 2) {
            titleString = [self getDayText:self.dayArr[row] mSelectDate:self.mSelectDate];
        } else if (component == 3) {
            titleString = [self getHourText:self.hourArr[row]];
        } else if (component == 4) {
            titleString = [self getMinuteText:self.minuteArr[row]];
        }
    } else if (self.pickerMode == BRDatePickerModeYMDH) {
        if (component == 0) {
            titleString = [self getYearText:self.yearArr[row]];
        } else if (component == 1) {
            titleString = [self getMonthText:self.monthArr[row] monthNames:self.monthNames];
        } else if (component == 2) {
            titleString = [self getDayText:self.dayArr[row] mSelectDate:self.mSelectDate];
        } else if (component == 3) {
            titleString = [self getHourText:self.hourArr[row]];
        }
    } else if (self.pickerMode == BRDatePickerModeMDHM) {
        if (component == 0) {
            titleString = [self getMonthText:self.monthArr[row] monthNames:self.monthNames];
        } else if (component == 1) {
            titleString = [self getDayText:self.dayArr[row] mSelectDate:self.mSelectDate];
        } else if (component == 2) {
            titleString = [self getHourText:self.hourArr[row]];
        } else if (component == 3) {
            titleString = [self getMinuteText:self.minuteArr[row]];
        }
    } else if (self.pickerMode == BRDatePickerModeYMD) {
        if (component == 0) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getYearText:self.yearArr[row]] : [self getDayText:self.dayArr[row] mSelectDate:self.mSelectDate];
        } else if (component == 1) {
            titleString = [self getMonthText:self.monthArr[row] monthNames:self.monthNames];
        } else if (component == 2) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getDayText:self.dayArr[row] mSelectDate:self.mSelectDate] : [self getYearText:self.yearArr[row]];
        }
    } else if (self.pickerMode == BRDatePickerModeYM) {
        if (component == 0) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getYearText:self.yearArr[row]] : [self getMonthText:self.monthArr[row] monthNames:self.monthNames];
        } else if (component == 1) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getMonthText:self.monthArr[row] monthNames:self.monthNames] : [self getYearText:self.yearArr[row]];
        }
    } else if (self.pickerMode == BRDatePickerModeY) {
        if (component == 0) {
            titleString = [self getYearText:self.yearArr[row]];
        }
    } else if (self.pickerMode == BRDatePickerModeMD) {
        if (component == 0) {
            titleString = [self getMonthText:self.monthArr[row] monthNames:self.monthNames];
        } else if (component == 1) {
            titleString = [self getDayText:self.dayArr[row] mSelectDate:self.mSelectDate];
        }
    } else if (self.pickerMode == BRDatePickerModeHMS) {
        if (component == 0) {
            titleString = [self getHourText:self.hourArr[row]];
        } else if (component == 1) {
            titleString = [self getMinuteText:self.minuteArr[row]];
        } else if (component == 2) {
            titleString = [self getSecondText:self.secondArr[row]];
        }
    } else if (self.pickerMode == BRDatePickerModeHM) {
        if (component == 0) {
            titleString = [self getHourText:self.hourArr[row]];
        } else if (component == 1) {
            titleString = [self getMinuteText:self.minuteArr[row]];
        }
    } else if (self.pickerMode == BRDatePickerModeMS) {
        if (component == 0) {
            titleString = [self getMinuteText:self.minuteArr[row]];
        } else if (component == 1) {
            titleString = [self getSecondText:self.secondArr[row]];
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
        if (![yearString isEqualToString:self.addCustomString]) {
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
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            self.mSelectValue = self.addCustomString;
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
        if (![yearString isEqualToString:self.addCustomString]) {
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count * self.hourArr.count * self.minuteArr.count == 0) return;
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day hour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            self.mSelectValue = self.addCustomString;
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
        if (![yearString isEqualToString:self.addCustomString]) {
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
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            self.mSelectValue = self.addCustomString;
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
        if (![monthString isEqualToString:self.addCustomString]) {
            if (self.monthArr.count * self.dayArr.count * self.hourArr.count * self.minuteArr.count == 0) return;
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            self.mSelectDate = [NSDate br_setMonth:month day:day hour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%02d-%02d %02d:%02d", month, day, hour, minute];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            self.mSelectValue = self.addCustomString;
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
        if (![yearString isEqualToString:self.addCustomString]) {
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count == 0) return;
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d", year, month, day];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            self.mSelectValue = self.addCustomString;
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
        if (![yearString isEqualToString:self.addCustomString]) {
            if (self.yearArr.count * self.monthArr.count == 0) return;
            int year = [self.yearArr[self.yearIndex] intValue];
            int month = [self.monthArr[self.monthIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d", year, month];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            self.mSelectValue = self.addCustomString;
        }
    } else if (self.pickerMode == BRDatePickerModeY) {
        if (component == 0) {
            self.yearIndex = row;
        }
        
        NSString *yearString = self.yearArr[self.yearIndex];
        if (![yearString isEqualToString:self.addCustomString]) {
            if (self.yearArr.count == 0) return;
            int year = [self.yearArr[self.yearIndex] intValue];
            self.mSelectDate = [NSDate br_setYear:year];
            self.mSelectValue = [NSString stringWithFormat:@"%04d", year];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            self.mSelectValue = self.addCustomString;
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
        if (![monthString isEqualToString:self.addCustomString]) {
            if (self.monthArr.count * self.dayArr.count == 0) return;
            int month = [self.monthArr[self.monthIndex] intValue];
            int day = [self.dayArr[self.dayIndex] intValue];
            self.mSelectDate = [NSDate br_setMonth:month day:day];
            self.mSelectValue = [NSString stringWithFormat:@"%02d-%02d", month, day];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            self.mSelectValue = self.addCustomString;
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
        if (![hourString isEqualToString:self.addCustomString]) {
            if (self.hourArr.count * self.minuteArr.count * self.secondArr.count == 0) return;
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            int second = [self.secondArr[self.secondIndex] intValue];
            self.mSelectDate = [NSDate br_setHour:hour minute:minute second:second];
            self.mSelectValue = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            self.mSelectValue = self.addCustomString;
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
        if (![hourString isEqualToString:self.addCustomString]) {
            if (self.hourArr.count * self.minuteArr.count == 0) return;
            int hour = [self.hourArr[self.hourIndex] intValue];
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            self.mSelectDate = [NSDate br_setHour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%02d:%02d", hour, minute];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            self.mSelectValue = self.addCustomString;
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
        if (![minuteString isEqualToString:self.addCustomString]) {
            if (self.minuteArr.count * self.secondArr.count == 0) return;
            int minute = [self.minuteArr[self.minuteIndex] intValue];
            int second = [self.secondArr[self.secondIndex] intValue];
            self.mSelectDate = [NSDate br_setMinute:minute second:second];
            self.mSelectValue = [NSString stringWithFormat:@"%02d:%02d", minute, second];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            self.mSelectValue = self.addCustomString;
        }
    }
    
    // 由 【自定义字符串】 滚动到 其它时间时，回滚到上次选择的位置
    if ([lastSelectValue isEqualToString:self.addCustomString] && ![self.mSelectValue isEqualToString:self.addCustomString]) {
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
    
    BOOL selectLessThanMin = [self br_compareDate:self.mSelectDate targetDate:self.minDate dateFormat:self.dateFormatter] == NSOrderedAscending;
    BOOL selectMoreThanMax = [self br_compareDate:self.mSelectDate targetDate:self.maxDate dateFormat:self.dateFormatter] == NSOrderedDescending;
    if (selectLessThanMin) {
        self.mSelectDate = self.minDate;
    }
    if (selectMoreThanMax) {
        self.mSelectDate = self.maxDate;
    }
    [self.datePicker setDate:self.mSelectDate animated:YES];
    
    self.mSelectValue = [self br_stringFromDate:self.mSelectDate dateFormat:self.dateFormatter];
    
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
        if (@available(iOS 13.4, *)) {
            // 适配 iOS14。如果编译报错，请使用 Xcode11.5 以上版本进行编译
            // 如果不考虑适配 iOS14，可将下面这行代码注释 或使用上一个版本 pod 'BRPickerView', '~> 2.6.6'
            self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
        // 设置该 UIDatePicker 的国际化 Locale
        self.datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:self.pickerStyle.language];
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
        if (self.selectValue && [self.selectValue isEqualToString:self.addCustomString]) {
            [self scrollToCustomString:NO];
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
        [self setupPickerView:self.datePicker toView:view];
    } else if (self.style == BRDatePickerStyleCustom) {
        [self setupPickerView:self.pickerView toView:view];
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

#pragma mark - 添加时间单位到选择器
- (void)addUnitLabel {
    if (self.unitLabelArr.count > 0) {
        for (UILabel *unitLabel in self.unitLabelArr) {
            [unitLabel removeFromSuperview];
        }
        self.unitLabelArr = nil;
    }
    self.unitLabelArr = [self setupPickerUnitLabel:self.pickerView unitArr:self.unitArr];
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
            [self setupPickerView:self.pickerView toView:_containerView];
        }
        // 自定义样式 切换到 系统样式
        if (lastStyle == BRDatePickerStyleCustom && self.style == BRDatePickerStyleSystem) {
            [self.pickerView removeFromSuperview];
            [self setupPickerView:self.datePicker toView:_containerView];
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
        _addCustomString = [NSBundle br_localizedStringForKey:@"至今" language:self.pickerStyle.language];
    }
}

- (void)setAddCustomString:(NSString *)addCustomString {
    if (!_addToNow) {
        _addCustomString = addCustomString;
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
