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

/// 日期选择器的类型
typedef NS_ENUM(NSInteger, BRDatePickerStyle) {
    BRDatePickerStyleSystem,   // 系统样式：使用 UIDatePicker
    BRDatePickerStyleCustom    // 自定义样式：使用 UIPickerView
};

@interface BRDatePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIDatePickerMode _datePickerMode;
    UIView *_containerView;
    BOOL _isAdjustSelectRow; // 设置minDate时，调整日期联动的选择(解决日期选择器联动不正确的问题)
}
/** 日期选择器1 */
@property (nonatomic, strong) UIDatePicker *datePicker;
/** 日期选择器2 */
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

/** 日期选择器的类型 */
@property (nonatomic, assign) BRDatePickerStyle style;
/** 日期的格式 */
@property (nonatomic, copy) NSString *dateFormatter;
/** 单位数组 */
@property (nonatomic, copy) NSArray *unitArr;
/** 单位label数组 */
@property (nonatomic, copy) NSArray <UILabel *> *unitLabelArr;

@end

@implementation BRDatePickerView

#pragma mark - 1.显示日期选择器
+ (void)showDatePickerWithMode:(BRDatePickerMode)mode
                         title:(NSString *)title
                   selectValue:(NSString *)selectValue
                   resultBlock:(BRDateResultBlock)resultBlock {
    [self showDatePickerWithMode:mode title:title selectValue:selectValue minDate:nil maxDate:nil isAutoSelect:NO resultBlock:resultBlock];
}

#pragma mark - 2.显示日期选择器
+ (void)showDatePickerWithMode:(BRDatePickerMode)mode
                         title:(NSString *)title
                   selectValue:(NSString *)selectValue
                  isAutoSelect:(BOOL)isAutoSelect
                   resultBlock:(BRDateResultBlock)resultBlock {
    [self showDatePickerWithMode:mode title:title selectValue:selectValue minDate:nil maxDate:nil isAutoSelect:isAutoSelect resultBlock:resultBlock];
}

#pragma mark - 3.显示日期选择器
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

#pragma mark - 初始化日期选择器
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
        self.minDate = [NSDate distantPast]; // 0000-12-30 00:00:00 +0000
        self.maxDate = [NSDate distantFuture]; // 4001-01-01 00:00:00 +0000
    }
    
    // 3.默认选中的日期
    self.mSelectDate = [self handlerSelectDate:self.selectDate dateFormat:self.dateFormatter];
    
    // 4.设置选择器日期数据
    if (self.style == BRDatePickerStyleCustom) {
        [self setupDateArray];
    }
    
    if (self.selectValue && ([self.selectValue isEqualToString:self.lastRowContent] || [self.selectValue isEqualToString:self.firstRowContent])) {
        self.mSelectDate = self.addToNow ? [NSDate date] : nil;
    } else {
        if (self.pickerMode == BRDatePickerModeYMDH && self.isShowAMAndPM) {
            self.hourIndex = (self.mSelectDate.br_hour < 12 ? 0 : 1);
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %@", (int)self.mSelectDate.br_year, (int)self.mSelectDate.br_month, (int)self.mSelectDate.br_day, [self getHourString]];
        } else {
            self.mSelectValue = [self br_stringFromDate:self.mSelectDate dateFormat:self.dateFormatter];
        }
    }
}

#pragma mark - 设置默认日期数据源
- (void)setupDateArray {
    if (self.selectValue && ([self.selectValue isEqualToString:self.lastRowContent] || [self.selectValue isEqualToString:self.firstRowContent])) {
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
    _isAdjustSelectRow = NO;
    // 1.更新 monthArr
    if (self.yearArr.count == 0) {
        return;
    }
    NSString *yearString = [self getYearString];
    if ((self.lastRowContent && [yearString isEqualToString:self.lastRowContent]) || (self.firstRowContent && [yearString isEqualToString:self.firstRowContent])) {
        self.monthArr = nil;
        self.dayArr = nil;
        self.hourArr = nil;
        self.minuteArr = nil;
        self.secondArr = nil;
        
        return;
    }
    if (updateMonth) {
        NSString *lastSelectMonth = [self getMDHMSNumber:self.mSelectDate.br_month];
        self.monthArr = [self getMonthArr:[yearString integerValue]];
        if (self.mSelectDate) {
            if ([self.monthArr containsObject:lastSelectMonth]) {
                NSInteger monthIndex = [self.monthArr indexOfObject:lastSelectMonth];
                if (monthIndex != self.monthIndex) {
                    _isAdjustSelectRow = YES;
                    self.monthIndex = monthIndex;
                }
            } else {
                _isAdjustSelectRow = YES;
                self.monthIndex = ([lastSelectMonth intValue] < [self.monthArr.firstObject intValue]) ? 0 : (self.monthArr.count - 1);
            }
        }
    }
    
    // 2.更新 dayArr
    if (self.monthArr.count == 0) {
        return;
    }
    NSString *monthString = [self getMonthString];
    if ((self.lastRowContent && [monthString isEqualToString:self.lastRowContent]) || (self.firstRowContent && [monthString isEqualToString:self.firstRowContent])) {
        self.dayArr = nil;
        self.hourArr = nil;
        self.minuteArr = nil;
        self.secondArr = nil;
        
        return;
    }
    if (updateDay) {
        NSString *lastSelectDay = [self getMDHMSNumber:self.mSelectDate.br_day];
        self.dayArr = [self getDayArr:[yearString integerValue] month:[monthString integerValue]];
        if (self.mSelectDate) {
            if ([self.dayArr containsObject:lastSelectDay]) {
                NSInteger dayIndex = [self.dayArr indexOfObject:lastSelectDay];
                if (dayIndex != self.dayIndex) {
                    _isAdjustSelectRow = YES;
                    self.dayIndex = dayIndex;
                }
            } else {
                _isAdjustSelectRow = YES;
                self.dayIndex = ([lastSelectDay intValue] < [self.dayArr.firstObject intValue]) ? 0 : (self.dayArr.count - 1);
            }
        }
    }
    
    // 3.更新 hourArr
    if (self.dayArr.count == 0) {
        return;
    }
    NSInteger day = [[self getDayString] integerValue];
    if (updateHour) {
        NSString *lastSelectHour = [self getMDHMSNumber:self.mSelectDate.br_hour];
        self.hourArr = [self getHourArr:[yearString integerValue] month:[monthString integerValue] day:day];
        if (self.mSelectDate) {
            if ([self.hourArr containsObject:lastSelectHour]) {
                NSInteger hourIndex = [self.hourArr indexOfObject:lastSelectHour];
                if (hourIndex != self.hourIndex) {
                    _isAdjustSelectRow = YES;
                    self.hourIndex = hourIndex;
                }
            } else {
                _isAdjustSelectRow = YES;
                self.hourIndex = ([lastSelectHour intValue] < [self.hourArr.firstObject intValue]) ? 0 : (self.hourArr.count - 1);
            }
        }
    }
    
    // 4.更新 minuteArr
    if (self.hourArr.count == 0) {
        return;
    }
    NSString *hourString = [self getHourString];
    if ((self.lastRowContent && [hourString isEqualToString:self.lastRowContent]) || (self.firstRowContent && [hourString isEqualToString:self.firstRowContent])) {
        self.minuteArr = nil;
        self.secondArr = nil;
        
        return;
    }
    if (updateMinute) {
        NSString *lastSelectMinute = [self getMDHMSNumber:self.mSelectDate.br_minute];
        self.minuteArr = [self getMinuteArr:[yearString integerValue] month:[monthString integerValue] day:day hour:[hourString integerValue]];
        if (self.mSelectDate) {
            if ([self.minuteArr containsObject:lastSelectMinute]) {
                NSInteger minuteIndex = [self.minuteArr indexOfObject:lastSelectMinute];
                if (minuteIndex != self.minuteIndex) {
                    _isAdjustSelectRow = YES;
                    self.minuteIndex = minuteIndex;
                }
            } else {
                _isAdjustSelectRow = YES;
                self.minuteIndex = ([lastSelectMinute intValue] < [self.minuteArr.firstObject intValue]) ? 0 : (self.minuteArr.count - 1);
            }
        }
    }
    
    // 5.更新 secondArr
    if (self.minuteArr.count == 0) {
        return;
    }
    NSString *minuteString = [self getMinuteString];
    if ((self.lastRowContent && [minuteString isEqualToString:self.lastRowContent]) || (self.firstRowContent && [minuteString isEqualToString:self.firstRowContent])) {
        self.secondArr = nil;
        return;
    }
    if (updateSecond) {
        NSString *lastSelectSecond = [self getMDHMSNumber:self.mSelectDate.br_second];
        self.secondArr = [self getSecondArr:[yearString integerValue] month:[monthString integerValue] day:day hour:[hourString integerValue] minute:[minuteString integerValue]];
        if (self.mSelectDate) {
            if ([self.secondArr containsObject:lastSelectSecond]) {
                NSInteger secondIndex = [self.secondArr indexOfObject:lastSelectSecond];
                if (secondIndex != self.secondIndex) {
                    _isAdjustSelectRow = YES;
                    self.secondIndex = secondIndex;
                }
            } else {
                _isAdjustSelectRow = YES;
                self.secondIndex = ([lastSelectSecond intValue] < [self.secondArr.firstObject intValue]) ? 0 : (self.secondArr.count - 1);
            }
        }
    }
}

#pragma mark - 滚动到指定日期的位置(更新选择的索引)
- (void)scrollToSelectDate:(NSDate *)selectDate animated:(BOOL)animated {
    self.yearIndex = [self getIndexWithArray:self.yearArr object:[self getYearNumber:selectDate.br_year]];
    self.monthIndex = [self getIndexWithArray:self.monthArr object:[self getMDHMSNumber:selectDate.br_month]];
    self.dayIndex = [self getIndexWithArray:self.dayArr object:[self getMDHMSNumber:selectDate.br_day]];
    if (self.pickerMode == BRDatePickerModeYMDH && self.isShowAMAndPM) {
        self.hourIndex = selectDate.br_hour < 12 ? 0 : 1;
    } else {
        self.hourIndex = [self getIndexWithArray:self.hourArr object:[self getMDHMSNumber:selectDate.br_hour]];
    }
    self.minuteIndex = [self getIndexWithArray:self.minuteArr object:[self getMDHMSNumber:selectDate.br_minute]];
    self.secondIndex = [self getIndexWithArray:self.secondArr object:[self getMDHMSNumber:selectDate.br_second]];
    
    NSArray *indexArr = nil;
    if (self.pickerMode == BRDatePickerModeYMDHMS) {
        indexArr = @[@(self.yearIndex), @(self.monthIndex), @(self.dayIndex), @(self.hourIndex), @(self.minuteIndex), @(self.secondIndex)];
    } else if (self.pickerMode == BRDatePickerModeYMDHM) {
        indexArr = @[@(self.yearIndex), @(self.monthIndex), @(self.dayIndex), @(self.hourIndex), @(self.minuteIndex)];
    } else if (self.pickerMode == BRDatePickerModeYMDH) {
        indexArr = @[@(self.yearIndex), @(self.monthIndex), @(self.dayIndex), @(self.hourIndex)];
    } else if (self.pickerMode == BRDatePickerModeMDHM) {
        indexArr = @[@(self.monthIndex), @(self.dayIndex), @(self.hourIndex), @(self.minuteIndex)];
    } else if (self.pickerMode == BRDatePickerModeYMD) {
        if ([self.pickerStyle.language hasPrefix:@"zh"]) {
            indexArr = @[@(self.yearIndex), @(self.monthIndex), @(self.dayIndex)];
        } else {
            indexArr = @[@(self.dayIndex), @(self.monthIndex), @(self.yearIndex)];
        }
    } else if (self.pickerMode == BRDatePickerModeYM) {
        if ([self.pickerStyle.language hasPrefix:@"zh"]) {
            indexArr = @[@(self.yearIndex), @(self.monthIndex)];
        } else {
            indexArr = @[@(self.monthIndex), @(self.yearIndex)];
        }
    } else if (self.pickerMode == BRDatePickerModeY) {
        indexArr = @[@(self.yearIndex)];
    } else if (self.pickerMode == BRDatePickerModeMD) {
        indexArr = @[@(self.monthIndex), @(self.dayIndex)];
    } else if (self.pickerMode == BRDatePickerModeHMS) {
        indexArr = @[@(self.hourIndex), @(self.minuteIndex), @(self.secondIndex)];
    } else if (self.pickerMode == BRDatePickerModeHM) {
        indexArr = @[@(self.hourIndex), @(self.minuteIndex)];
    } else if (self.pickerMode == BRDatePickerModeMS) {
        indexArr = @[@(self.minuteIndex), @(self.secondIndex)];
    }
    if (!indexArr) return;
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
            NSInteger yearIndex = ([self.selectValue isEqualToString:self.lastRowContent] && self.yearArr.count > 0) ? self.yearArr.count - 1 : 0;
            NSInteger component = 0;
            if (self.pickerMode == BRDatePickerModeYMD && ![self.pickerStyle.language hasPrefix:@"zh"]) {
                component = 2;
            } else if (self.pickerMode == BRDatePickerModeYM && ![self.pickerStyle.language hasPrefix:@"zh"]) {
                component = 1;
            }
            [self.pickerView selectRow:yearIndex inComponent:component animated:animated];
        }
            break;
        case BRDatePickerModeMDHM:
        case BRDatePickerModeMD:
        {
            NSInteger monthIndex = ([self.selectValue isEqualToString:self.lastRowContent] && self.monthArr.count > 0) ? self.monthArr.count - 1 : 0;
            [self.pickerView selectRow:monthIndex inComponent:0 animated:animated];
        }
            break;
        case BRDatePickerModeHMS:
        case BRDatePickerModeHM:
        {
            NSInteger hourIndex = ([self.selectValue isEqualToString:self.lastRowContent] && self.hourArr.count > 0) ? self.hourArr.count - 1 : 0;
            [self.pickerView selectRow:hourIndex inComponent:0 animated:animated];
        }
            break;
        case BRDatePickerModeMS:
        {
            NSInteger minuteIndex = ([self.selectValue isEqualToString:self.lastRowContent] && self.minuteArr.count > 0) ? self.minuteArr.count - 1 : 0;
            [self.pickerView selectRow:minuteIndex inComponent:0 animated:animated];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 日期选择器1
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight + pickerHeaderViewHeight, self.keyView.bounds.size.width, self.pickerStyle.pickerHeight)];
        _datePicker.backgroundColor = self.pickerStyle.pickerColor;
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        // 滚动改变值的响应事件
        [_datePicker addTarget:self action:@selector(didSelectValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - 日期选择器2
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight + pickerHeaderViewHeight, self.keyView.bounds.size.width, self.pickerStyle.pickerHeight)];
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
    if (component >= 0 && component < rowsArr.count) {
        return [rowsArr[component] integerValue];
    }
    return 0;
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
    [self.pickerStyle setupPickerSelectRowStyle:pickerView titleForRow:row forComponent:component];

    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *titleString = @"";
    if (self.pickerMode == BRDatePickerModeYMDHMS) {
        if (component == 0) {
            titleString = [self getYearText:self.yearArr row:row];
        } else if (component == 1) {
            titleString = [self getMonthText:self.monthArr row:row];
        } else if (component == 2) {
            titleString = [self getDayText:self.dayArr row:row mSelectDate:self.mSelectDate];
        } else if (component == 3) {
            titleString = [self getHourText:self.hourArr row:row];
        } else if (component == 4) {
            titleString = [self getMinuteText:self.minuteArr row:row];
        } else if (component == 5) {
            titleString = [self getSecondText:self.secondArr row:row];
        }
    } else if (self.pickerMode == BRDatePickerModeYMDHM) {
        if (component == 0) {
            titleString = [self getYearText:self.yearArr row:row];
        } else if (component == 1) {
            titleString = [self getMonthText:self.monthArr row:row];
        } else if (component == 2) {
            titleString = [self getDayText:self.dayArr row:row mSelectDate:self.mSelectDate];
        } else if (component == 3) {
            titleString = [self getHourText:self.hourArr row:row];
        } else if (component == 4) {
            titleString = [self getMinuteText:self.minuteArr row:row];
        }
    } else if (self.pickerMode == BRDatePickerModeYMDH) {
        if (component == 0) {
            titleString = [self getYearText:self.yearArr row:row];;
        } else if (component == 1) {
            titleString = [self getMonthText:self.monthArr row:row];
        } else if (component == 2) {
            titleString = [self getDayText:self.dayArr row:row mSelectDate:self.mSelectDate];
        } else if (component == 3) {
            titleString = [self getHourText:self.hourArr row:row];
        }
    } else if (self.pickerMode == BRDatePickerModeMDHM) {
        if (component == 0) {
            titleString = [self getMonthText:self.monthArr row:row];
        } else if (component == 1) {
            titleString = [self getDayText:self.dayArr row:row mSelectDate:self.mSelectDate];
        } else if (component == 2) {
            titleString = [self getHourText:self.hourArr row:row];
        } else if (component == 3) {
            titleString = [self getMinuteText:self.minuteArr row:row];
        }
    } else if (self.pickerMode == BRDatePickerModeYMD) {
        if (component == 0) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getYearText:self.yearArr row:row] : [self getDayText:self.dayArr row:row mSelectDate:self.mSelectDate];
        } else if (component == 1) {
            titleString = [self getMonthText:self.monthArr row:row];
        } else if (component == 2) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getDayText:self.dayArr row:row mSelectDate:self.mSelectDate] : [self getYearText:self.yearArr row:row];
        }
    } else if (self.pickerMode == BRDatePickerModeYM) {
        if (component == 0) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getYearText:self.yearArr row:row] : [self getMonthText:self.monthArr row:row];
        } else if (component == 1) {
            titleString = [self.pickerStyle.language hasPrefix:@"zh"] ? [self getMonthText:self.monthArr row:row] : [self getYearText:self.yearArr row:row];
        }
    } else if (self.pickerMode == BRDatePickerModeY) {
        if (component == 0) {
            titleString = [self getYearText:self.yearArr row:row];
        }
    } else if (self.pickerMode == BRDatePickerModeMD) {
        if (component == 0) {
            titleString = [self getMonthText:self.monthArr row:row];
        } else if (component == 1) {
            titleString = [self getDayText:self.dayArr row:row mSelectDate:self.mSelectDate];
        }
    } else if (self.pickerMode == BRDatePickerModeHMS) {
        if (component == 0) {
            titleString = [self getHourText:self.hourArr row:row];
        } else if (component == 1) {
            titleString = [self getMinuteText:self.minuteArr row:row];
        } else if (component == 2) {
            titleString = [self getSecondText:self.secondArr row:row];
        }
    } else if (self.pickerMode == BRDatePickerModeHM) {
        if (component == 0) {
            titleString = [self getHourText:self.hourArr row:row];
        } else if (component == 1) {
            titleString = [self getMinuteText:self.minuteArr row:row];
        }
    } else if (self.pickerMode == BRDatePickerModeMS) {
        if (component == 0) {
            titleString = [self getMinuteText:self.minuteArr row:row];
        } else if (component == 1) {
            titleString = [self getSecondText:self.secondArr row:row];
        }
    }
    
    return titleString;
}

// 4.滚动 pickerView 执行的回调方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *lastSelectValue = self.mSelectValue;
    NSDate *lastSelectDate = self.mSelectDate;
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
        
        NSString *yearString = [self getYearString];
        if (![yearString isEqualToString:self.lastRowContent] && ![yearString isEqualToString:self.firstRowContent]) {
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count * self.hourArr.count * self.minuteArr.count * self.secondArr.count == 0) return;
            int year = [[self getYearString] intValue];
            int month = [[self getMonthString] intValue];
            int day = [[self getDayString] intValue];
            int hour = [[self getHourString] intValue];
            int minute = [[self getMinuteString] intValue];
            int second = [[self getSecondString] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day hour:hour minute:minute second:second];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            if ([yearString isEqualToString:self.lastRowContent]) {
                self.mSelectValue = self.lastRowContent;
            } else if ([yearString isEqualToString:self.firstRowContent]) {
                self.mSelectValue = self.firstRowContent;
            }
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
        
        NSString *yearString = [self getYearString];
        if (![yearString isEqualToString:self.lastRowContent] && ![yearString isEqualToString:self.firstRowContent]) {
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count * self.hourArr.count * self.minuteArr.count == 0) return;
            int year = [[self getYearString] intValue];
            int month = [[self getMonthString] intValue];
            int day = [[self getDayString] intValue];
            int hour = [[self getHourString] intValue];
            int minute = [[self getMinuteString] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day hour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            if ([yearString isEqualToString:self.lastRowContent]) {
                self.mSelectValue = self.lastRowContent;
            } else if ([yearString isEqualToString:self.firstRowContent]) {
                self.mSelectValue = self.firstRowContent;
            }
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
        
        NSString *yearString = [self getYearString];
        if (![yearString isEqualToString:self.lastRowContent] && ![yearString isEqualToString:self.firstRowContent]) {
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count * self.hourArr.count == 0) return;
            int year = [[self getYearString] intValue];
            int month = [[self getMonthString] intValue];
            int day = [[self getDayString] intValue];
            int hour = 0;
            if (self.pickerMode == BRDatePickerModeYMDH && self.isShowAMAndPM) {
                hour = (self.hourIndex == 0 ? 0 : 12);
                self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %@", year, month, day, [self getHourString]];
            } else {
                hour = [[self getHourString] intValue];
                self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d %02d", year, month, day, hour];
            }
            self.mSelectDate = [NSDate br_setYear:year month:month day:day hour:hour];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            if ([yearString isEqualToString:self.lastRowContent]) {
                self.mSelectValue = self.lastRowContent;
            } else if ([yearString isEqualToString:self.firstRowContent]) {
                self.mSelectValue = self.firstRowContent;
            }
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
        
        NSString *monthString = [self getMonthString];
        if (![monthString isEqualToString:self.lastRowContent] && ![monthString isEqualToString:self.firstRowContent]) {
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count * self.hourArr.count * self.minuteArr.count == 0) return;
            int year = [[self getYearString] intValue];
            int month = [[self getMonthString] intValue];
            int day = [[self getDayString] intValue];
            int hour = [[self getHourString] intValue];
            int minute = [[self getMinuteString] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day hour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%02d-%02d %02d:%02d", month, day, hour, minute];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            if ([monthString isEqualToString:self.lastRowContent]) {
                self.mSelectValue = self.lastRowContent;
            } else if ([monthString isEqualToString:self.firstRowContent]) {
                self.mSelectValue = self.firstRowContent;
            }
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
        
        NSString *yearString = [self getYearString];
        if (![yearString isEqualToString:self.lastRowContent] && ![yearString isEqualToString:self.firstRowContent]) {
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count == 0) return;
            int year = [[self getYearString] intValue];
            int month = [[self getMonthString] intValue];
            int day = [[self getDayString] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d-%02d", year, month, day];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            if ([yearString isEqualToString:self.lastRowContent]) {
                self.mSelectValue = self.lastRowContent;
            } else if ([yearString isEqualToString:self.firstRowContent]) {
                self.mSelectValue = self.firstRowContent;
            }
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
        
        NSString *yearString = [self getYearString];
        if (![yearString isEqualToString:self.lastRowContent] && ![yearString isEqualToString:self.firstRowContent]) {
            if (self.yearArr.count * self.monthArr.count == 0) return;
            int year = [[self getYearString] intValue];
            int month = [[self getMonthString] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month];
            self.mSelectValue = [NSString stringWithFormat:@"%04d-%02d", year, month];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            if ([yearString isEqualToString:self.lastRowContent]) {
                self.mSelectValue = self.lastRowContent;
            } else if ([yearString isEqualToString:self.firstRowContent]) {
                self.mSelectValue = self.firstRowContent;
            }
        }
    } else if (self.pickerMode == BRDatePickerModeY) {
        if (component == 0) {
            self.yearIndex = row;
        }
        
        NSString *yearString = [self getYearString];
        if (![yearString isEqualToString:self.lastRowContent] && ![yearString isEqualToString:self.firstRowContent]) {
            if (self.yearArr.count == 0) return;
            int year = [[self getYearString] intValue];
            self.mSelectDate = [NSDate br_setYear:year];
            self.mSelectValue = [NSString stringWithFormat:@"%04d", year];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            if ([yearString isEqualToString:self.lastRowContent]) {
                self.mSelectValue = self.lastRowContent;
            } else if ([yearString isEqualToString:self.firstRowContent]) {
                self.mSelectValue = self.firstRowContent;
            }
        }
        
    } else if (self.pickerMode == BRDatePickerModeMD) {
        if (component == 0) {
            self.monthIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:YES updateHour:NO updateMinute:NO updateSecond:NO];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            self.dayIndex = row;
        }
        
        NSString *monthString = [self getMonthString];
        if (![monthString isEqualToString:self.lastRowContent] && ![monthString isEqualToString:self.firstRowContent]) {
            if (self.yearArr.count * self.monthArr.count * self.dayArr.count == 0) return;
            int year = [[self getYearString] intValue];
            int month = [[self getMonthString] intValue];
            int day = [[self getDayString] intValue];
            self.mSelectDate = [NSDate br_setYear:year month:month day:day];
            self.mSelectValue = [NSString stringWithFormat:@"%02d-%02d", month, day];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            if ([monthString isEqualToString:self.lastRowContent]) {
                self.mSelectValue = self.lastRowContent;
            } else if ([monthString isEqualToString:self.firstRowContent]) {
                self.mSelectValue = self.firstRowContent;
            }
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
        
        NSString *hourString = [self getHourString];
        if (![hourString isEqualToString:self.lastRowContent] && ![hourString isEqualToString:self.firstRowContent]) {
            if (self.hourArr.count * self.minuteArr.count * self.secondArr.count == 0) return;
            int hour = [[self getHourString] intValue];
            int minute = [[self getMinuteString] intValue];
            int second = [[self getSecondString] intValue];
            self.mSelectDate = [NSDate br_setHour:hour minute:minute second:second];
            self.mSelectValue = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            if ([hourString isEqualToString:self.lastRowContent]) {
                self.mSelectValue = self.lastRowContent;
            } else if ([hourString isEqualToString:self.firstRowContent]) {
                self.mSelectValue = self.firstRowContent;
            }
        }
        
    } else if (self.pickerMode == BRDatePickerModeHM) {
        if (component == 0) {
            self.hourIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:NO updateMinute:YES updateSecond:NO];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            self.minuteIndex = row;
        }
        
        NSString *hourString = [self getHourString];
        if (![hourString isEqualToString:self.lastRowContent] && ![hourString isEqualToString:self.firstRowContent]) {
            if (self.hourArr.count * self.minuteArr.count == 0) return;
            int hour = [[self getHourString] intValue];
            int minute = [[self getMinuteString] intValue];
            self.mSelectDate = [NSDate br_setHour:hour minute:minute];
            self.mSelectValue = [NSString stringWithFormat:@"%02d:%02d", hour, minute];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            if ([hourString isEqualToString:self.lastRowContent]) {
                self.mSelectValue = self.lastRowContent;
            } else if ([hourString isEqualToString:self.firstRowContent]) {
                self.mSelectValue = self.firstRowContent;
            }
        }
    } else if (self.pickerMode == BRDatePickerModeMS) {
        if (component == 0) {
            self.minuteIndex = row;
            [self reloadDateArrayWithUpdateMonth:NO updateDay:NO updateHour:NO updateMinute:NO updateSecond:YES];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            self.secondIndex = row;
        }
        
        NSString *minuteString = [self getMinuteString];
        if (![minuteString isEqualToString:self.lastRowContent] && ![minuteString isEqualToString:self.firstRowContent]) {
            if (self.minuteArr.count * self.secondArr.count == 0) return;
            int minute = [[self getMinuteString] intValue];
            int second = [[self getSecondString] intValue];
            self.mSelectDate = [NSDate br_setMinute:minute second:second];
            self.mSelectValue = [NSString stringWithFormat:@"%02d:%02d", minute, second];
        } else {
            self.mSelectDate = self.addToNow ? [NSDate date] : nil;
            if ([minuteString isEqualToString:self.lastRowContent]) {
                self.mSelectValue = self.lastRowContent;
            } else if ([minuteString isEqualToString:self.firstRowContent]) {
                self.mSelectValue = self.firstRowContent;
            }
        }
    }
    
    // 纠正选择日期（解决：由【自定义字符串】滚动到 其它日期时，或设置 minDate，日期联动不正确问题）
    BOOL isLastRowContent = [lastSelectValue isEqualToString:self.lastRowContent] && ![self.mSelectValue isEqualToString:self.lastRowContent] && ![self.mSelectValue isEqualToString:self.firstRowContent];
    BOOL isFirstRowContent = [lastSelectValue isEqualToString:self.firstRowContent] && ![self.mSelectValue isEqualToString:self.lastRowContent] && ![self.mSelectValue isEqualToString:self.firstRowContent];
    if (isLastRowContent || isFirstRowContent || _isAdjustSelectRow) {
        [self scrollToSelectDate:self.mSelectDate animated:NO];
    }
    
    // 禁止选择日期：回滚到上次选择的日期
    if (self.nonSelectableDates && self.nonSelectableDates.count > 0 && ![self.mSelectValue isEqualToString:self.lastRowContent] && ![self.mSelectValue isEqualToString:self.firstRowContent]) {
        for (NSDate *date in self.nonSelectableDates) {
            if ([self br_compareDate:date targetDate:self.mSelectDate dateFormat:self.dateFormatter] == NSOrderedSame) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 如果当前的日期不可选择，就回滚到上次选择的日期
                    [self scrollToSelectDate:lastSelectDate animated:YES];
                });
                // 不可选择日期的回调
                if (self.nonSelectableBlock) {
                    self.nonSelectableBlock(self.mSelectDate, self.mSelectValue);
                }
                self.mSelectDate = lastSelectDate;
                self.mSelectValue = lastSelectValue;
                break;
            }
        }
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

#pragma mark - 日期选择器1 滚动后的响应事件
- (void)didSelectValueChanged:(UIDatePicker *)sender {
    // 读取日期：datePicker.date
    self.mSelectDate = sender.date;
    
    if (_datePickerMode != UIDatePickerModeCountDownTimer) {
        BOOL selectLessThanMin = [self br_compareDate:self.mSelectDate targetDate:self.minDate dateFormat:self.dateFormatter] == NSOrderedAscending;
        BOOL selectMoreThanMax = [self br_compareDate:self.mSelectDate targetDate:self.maxDate dateFormat:self.dateFormatter] == NSOrderedDescending;
        if (selectLessThanMin) {
            self.mSelectDate = self.minDate;
        }
        if (selectMoreThanMax) {
            self.mSelectDate = self.maxDate;
        }
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
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130400 // 编译时检查SDK版本，iOS SDK 13.4 以后版本的处理
        if (@available(iOS 13.4, *)) {
            // 适配 iOS14 以后 UIDatePicker 的显示样式
            self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
            // 设置 datePicker 的 frame（在iOS14里，UIDatePicker 的 frame 赋值必须放在 datePickerMode 赋值之后， 否则 frame 不会生效）
            CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
            self.datePicker.frame = CGRectMake(0, self.pickerStyle.titleBarHeight + pickerHeaderViewHeight, self.keyView.bounds.size.width, self.pickerStyle.pickerHeight);
        } else
#endif
        {
            // Fallback on earlier versions
        }

        // 设置该 UIDatePicker 的国际化 Locale
        self.datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:self.pickerStyle.language];
        if (self.timeZone) {
            self.datePicker.timeZone = self.timeZone;
        }
        
        self.datePicker.calendar = self.calendar;
        // 设置农历日期
        //self.datePicker.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        
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
        
        // 3.滚动到选择的日期
        [self.datePicker setDate:self.mSelectDate animated:NO];
    } else if (self.style == BRDatePickerStyleCustom) {
        // 2.刷新选择器
        [self.pickerView reloadAllComponents];
        // 3.滚动到选择的日期
        if (self.selectValue && ([self.selectValue isEqualToString:self.lastRowContent] || [self.selectValue isEqualToString:self.firstRowContent])) {
            [self scrollToCustomString:NO];
        } else {
            [self scrollToSelectDate:self.mSelectDate animated:NO];
        }
    }
}

- (void)addPickerToView:(UIView *)view {
    _containerView = view;
    [self setupDateFormatter:self.pickerMode];
    // 1.添加日期选择器
    if (self.style == BRDatePickerStyleSystem) {
        [self setupPickerView:self.datePicker toView:view];
    } else if (self.style == BRDatePickerStyleCustom) {
        [self setupPickerView:self.pickerView toView:view];
        if (self.showUnitType == BRShowUnitTypeOnlyCenter) {
            // 添加日期单位到选择器
            [self addUnitLabel];
        }
    }
    
    // ③添加中间选择行的两条分割线
    if (self.pickerStyle.clearPickerNewStyle) {
        [self.pickerStyle addSeparatorLineView:self.pickerView];
    }
    
    // 2.绑定数据
    [self reloadData];
    
    __weak typeof(self) weakSelf = self;
    self.doneBlock = ^{
        // 点击确定按钮后，执行block回调
        if (weakSelf.resultBlock) {
            weakSelf.resultBlock(weakSelf.mSelectDate, weakSelf.mSelectValue);
        }
    };
    
    [super addPickerToView:view];
}

#pragma mark - 添加日期单位到选择器
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
            // 添加日期单位到选择器
            [self addUnitLabel];
        }
    }
}

- (void)setAddToNow:(BOOL)addToNow {
    _addToNow = addToNow;
    if (addToNow) {
        _maxDate = [NSDate date];
        _lastRowContent = [NSBundle br_localizedStringForKey:@"至今" language:self.pickerStyle.language];
    }
}

- (void)setLastRowContent:(NSString *)lastRowContent {
    if (!_addToNow) {
        _lastRowContent = lastRowContent;
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

- (void)setAddCustomString:(NSString *)addCustomString {
    self.lastRowContent = addCustomString;
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
        _monthNames = [NSArray array];
    }
    return _monthNames;
}

- (NSString *)getYearString {
    NSInteger index = 0;
    if (self.yearIndex >= 0 && self.yearIndex < self.yearArr.count) {
        index = self.yearIndex;
    }
    return [self.yearArr objectAtIndex:index];
}

- (NSString *)getMonthString {
    NSInteger index = 0;
    if (self.monthIndex >= 0 && self.monthIndex < self.monthArr.count) {
        index = self.monthIndex;
    }
    return [self.monthArr objectAtIndex:index];
}

- (NSString *)getDayString {
    NSInteger index = 0;
    if (self.dayIndex >= 0 && self.dayIndex < self.dayArr.count) {
        index = self.dayIndex;
    }
    return [self.dayArr objectAtIndex:index];
}

- (NSString *)getHourString {
    NSInteger index = 0;
    if (self.hourIndex >= 0 && self.hourIndex < self.hourArr.count) {
        index = self.hourIndex;
    }
    return [self.hourArr objectAtIndex:index];
}

- (NSString *)getMinuteString {
    NSInteger index = 0;
    if (self.minuteIndex >= 0 && self.minuteIndex < self.minuteArr.count) {
        index = self.minuteIndex;
    }
    return [self.minuteArr objectAtIndex:index];
}

- (NSString *)getSecondString {
    NSInteger index = 0;
    if (self.secondIndex >= 0 && self.secondIndex < self.secondArr.count) {
        index = self.secondIndex;
    }
    return [self.secondArr objectAtIndex:index];
}

@end
