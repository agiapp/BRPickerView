//
//  BRDatePickerView.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRDatePickerView.h"
#import "BRPickerViewMacro.h"

/// 时间选择器的类型
typedef NS_ENUM(NSInteger, BRDatePickerStyle) {
    BRDatePickerStyleSystem,   // 系统样式：使用 UIDatePicker 类
    BRDatePickerStyleCustom    // 自定义样式：使用 UIPickerView 类
};

@interface BRDatePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    // 记录 年、月、日、时、分 当前选择的位置
    NSInteger _yearIndex;
    NSInteger _monthIndex;
    NSInteger _dayIndex;
    NSInteger _hourIndex;
    NSInteger _minuteIndex;
    
    NSString *_title;
    UIDatePickerMode _datePickerMode;
    BOOL _isAutoSelect;      // 是否开启自动选择
    UIColor *_themeColor;
}
/** 时间选择器1 */
@property (nonatomic, strong) UIDatePicker *datePicker;
/** 时间选择器2 */
@property (nonatomic, strong) UIPickerView *pickerView;
/// 日期存储数组
@property(nonatomic, strong) NSArray *yearArr;
@property(nonatomic, strong) NSArray *monthArr;
@property(nonatomic, strong) NSArray *dayArr;
@property(nonatomic, strong) NSArray *hourArr;
@property(nonatomic, strong) NSArray *minuteArr;
/** 显示类型 */
@property (nonatomic, assign) BRDatePickerMode showType;
/** 时间选择器的类型 */
@property (nonatomic, assign) BRDatePickerStyle style;
/** 限制最小日期 */
@property (nonatomic, strong) NSDate *minLimitDate;
/** 限制最大日期 */
@property (nonatomic, strong) NSDate *maxLimitDate;
/** 当前选择的日期 */
@property (nonatomic, strong) NSDate *selectDate;
/** 选择的日期的格式 */
@property (nonatomic, strong) NSString *selectDateFormatter;

/** 选中后的回调 */
@property (nonatomic, copy) BRDateResultBlock resultBlock;
/** 取消选择的回调 */
@property (nonatomic, copy) BRDateCancelBlock cancelBlock;

@end

@implementation BRDatePickerView

#pragma mark - 1.显示时间选择器
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(BRDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                    resultBlock:(BRDateResultBlock)resultBlock {
    [self showDatePickerWithTitle:title dateType:dateType defaultSelValue:defaultSelValue minDate:nil maxDate:nil isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil];
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
                    cancelBlock:(BRDateCancelBlock)cancelBlock {
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithTitle:title dateType:dateType defaultSelValue:defaultSelValue minDate:minDate maxDate:maxDate isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    [datePickerView showWithAnimation:YES];
}

#pragma mark - 初始化时间选择器
- (instancetype)initWithTitle:(NSString *)title
                     dateType:(BRDatePickerMode)dateType
              defaultSelValue:(NSString *)defaultSelValue
                      minDate:(NSDate *)minDate
                      maxDate:(NSDate *)maxDate
                 isAutoSelect:(BOOL)isAutoSelect
                   themeColor:(UIColor *)themeColor
                  resultBlock:(BRDateResultBlock)resultBlock
                  cancelBlock:(BRDateCancelBlock)cancelBlock {
    if (self = [super init]) {
        _title = title;
        _isAutoSelect = isAutoSelect;
        _themeColor = themeColor;
        _resultBlock = resultBlock;
        _cancelBlock = cancelBlock;
        self.showType = dateType;
        [self setupSelectDateFormatter:dateType];
        // 1.最小日期限制
        if (minDate) {
            self.minLimitDate = minDate;
        } else {
            if (self.showType == BRDatePickerModeTime || self.showType == BRDatePickerModeCountDownTimer || self.showType == BRDatePickerModeHM) {
                self.minLimitDate = [NSDate br_setHour:0 minute:0];
            } else if (self.showType == BRDatePickerModeMDHM) {
                self.minLimitDate = [NSDate br_setMonth:1 day:1 hour:0 minute:0];
            } else if (self.showType == BRDatePickerModeMD) {
                self.minLimitDate = [NSDate br_setMonth:1 day:1];
            } else {
                self.minLimitDate = [NSDate distantPast]; // 遥远的过去的一个时间点
            }
        }
        // 2.最大日期限制
        if (maxDate) {
            self.maxLimitDate = maxDate;
        } else {
            if (self.showType == BRDatePickerModeTime || self.showType == BRDatePickerModeCountDownTimer || self.showType == BRDatePickerModeHM) {
                self.maxLimitDate = [NSDate br_setHour:23 minute:59];
            } else if (self.showType == BRDatePickerModeMDHM) {
                self.maxLimitDate = [NSDate br_setMonth:12 day:31 hour:23 minute:59];
            } else if (self.showType == BRDatePickerModeMD) {
                self.maxLimitDate = [NSDate br_setMonth:12 day:31];
            } else {
                self.maxLimitDate = [NSDate distantFuture]; // 遥远的未来的一个时间点
            }
        }
        BOOL minMoreThanMax = [self.minLimitDate br_compare:self.maxLimitDate format:self.selectDateFormatter] == NSOrderedDescending;
        NSAssert(!minMoreThanMax, @"最小日期不能大于最大日期！");
        if (minMoreThanMax) {
            // 如果最小日期大于了最大日期，就忽略两个值
            self.minLimitDate = [NSDate distantPast];
            self.maxLimitDate = [NSDate distantFuture];
        }
        
        // 3.默认选中的日期
        if (defaultSelValue && defaultSelValue.length > 0) {
            NSDate *defaultSelDate = [NSDate br_getDate:defaultSelValue format:self.selectDateFormatter];
            if (!defaultSelDate) {
                BRErrorLog(@"参数格式错误！参数 defaultSelValue 的正确格式是：%@", self.selectDateFormatter);
                NSAssert(defaultSelDate, @"参数格式错误！请检查形参 defaultSelValue 的格式");
                defaultSelDate = [NSDate date]; // 默认值参数格式错误时，重置/忽略默认值，防止在 Release 环境下崩溃！
            }
            if (self.showType == BRDatePickerModeTime || self.showType == BRDatePickerModeCountDownTimer || self.showType == BRDatePickerModeHM) {
                self.selectDate = [NSDate br_setHour:defaultSelDate.br_hour minute:defaultSelDate.br_minute];
            } else if (self.showType == BRDatePickerModeMDHM) {
                self.selectDate = [NSDate br_setMonth:defaultSelDate.br_month day:defaultSelDate.br_day hour:defaultSelDate.br_hour minute:defaultSelDate.br_minute];
            } else if (self.showType == BRDatePickerModeMD) {
                self.selectDate = [NSDate br_setMonth:defaultSelDate.br_month day:defaultSelDate.br_day];
            } else {
                self.selectDate = defaultSelDate;
            }
        } else {
            // 不设置默认日期，就默认选中今天的日期
            self.selectDate = [NSDate date];
        }
        BOOL selectLessThanMin = [self.selectDate br_compare:self.minLimitDate format:self.selectDateFormatter] == NSOrderedAscending;
        BOOL selectMoreThanMax = [self.selectDate br_compare:self.maxLimitDate format:self.selectDateFormatter] == NSOrderedDescending;
        NSAssert(!selectLessThanMin, @"默认选择的日期不能小于最小日期！");
        NSAssert(!selectMoreThanMax, @"默认选择的日期不能大于最大日期！");
        if (selectLessThanMin) {
            self.selectDate = self.minLimitDate;
        }
        if (selectMoreThanMax) {
            self.selectDate = self.maxLimitDate;
        }
        
#ifdef DEBUG
        NSLog(@"最小时间date：%@", self.minLimitDate);
        NSLog(@"默认时间date：%@", self.selectDate);
        NSLog(@"最大时间date：%@", self.maxLimitDate);
        
        NSLog(@"最小时间：%@", [NSDate br_getDateString:self.minLimitDate format:self.selectDateFormatter]);
        NSLog(@"默认时间：%@", [NSDate br_getDateString:self.selectDate format:self.selectDateFormatter]);
        NSLog(@"最大时间：%@", [NSDate br_getDateString:self.maxLimitDate format:self.selectDateFormatter]);
#endif
        
        if (self.style == BRDatePickerStyleCustom) {
            [self initDefaultDateArray];
        }
        [self initUI];
        
        // 默认滚动的行
        if (self.style == BRDatePickerStyleSystem) {
            [self.datePicker setDate:self.selectDate animated:NO];
        } else if (self.style == BRDatePickerStyleCustom) {
            [self scrollToSelectDate:self.selectDate animated:NO];
        }
    }
    return self;
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
            
        case BRDatePickerModeYMDHM:
        {
            self.selectDateFormatter = @"yyyy-MM-dd HH:mm";
            self.style = BRDatePickerStyleCustom;
        }
            break;
        case BRDatePickerModeMDHM:
        {
            self.selectDateFormatter = @"MM-dd HH:mm";
            self.style = BRDatePickerStyleCustom;
        }
            break;
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

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = _title;
    // 添加时间选择器
    if (self.style == BRDatePickerStyleSystem) {
        [self.alertView addSubview:self.datePicker];
    } else if (self.style == BRDatePickerStyleCustom) {
        [self.alertView addSubview:self.pickerView];
    }
    if (_themeColor && [_themeColor isKindOfClass:[UIColor class]]) {
        [self setupThemeColor:_themeColor];
    }
}

#pragma mark - 设置日期数据源数组
- (void)initDefaultDateArray {
    // 1. 设置 yearArr 数组
    [self setupYearArr];
    // 2.设置 monthArr 数组
    [self setupMonthArr:self.selectDate.br_year];
    // 3.设置 dayArr 数组
    [self setupDayArr:self.selectDate.br_year month:self.selectDate.br_month];
    // 4.设置 hourArr 数组
    [self setupHourArr:self.selectDate.br_year month:self.selectDate.br_month day:self.selectDate.br_day];
    // 5.设置 minuteArr 数组
    [self setupMinuteArr:self.selectDate.br_year month:self.selectDate.br_month day:self.selectDate.br_day hour:self.selectDate.br_hour];
    // 根据 默认选择的日期 计算出 对应的索引
    _yearIndex = self.selectDate.br_year - self.minLimitDate.br_year;
    _monthIndex = self.selectDate.br_month - ((_yearIndex == 0) ? self.minLimitDate.br_month : 1);
    _dayIndex = self.selectDate.br_day - ((_yearIndex == 0 && _monthIndex == 0) ? self.minLimitDate.br_day : 1);
    _hourIndex = self.selectDate.br_hour - ((_yearIndex == 0 && _monthIndex == 0 && _dayIndex == 0) ? self.minLimitDate.br_hour : 0);
    _minuteIndex = self.selectDate.br_minute - ((_yearIndex == 0 && _monthIndex == 0 && _dayIndex == 0 && _hourIndex == 0) ? self.minLimitDate.br_minute : 0);
    
}

#pragma mark - 更新日期数据源数组
- (void)updateDateArray {
    NSInteger year = [self.yearArr[_yearIndex] integerValue];
    // 1.设置 monthArr 数组
    [self setupMonthArr:year];
    // 更新索引：防止更新 monthArr 后数组越界
    _monthIndex = (_monthIndex > self.monthArr.count - 1) ? (self.monthArr.count - 1) : _monthIndex;
    
    NSInteger month = [self.monthArr[_monthIndex] integerValue];
    // 2.设置 dayArr 数组
    [self setupDayArr:year month:month];
    // 更新索引：防止更新 dayArr 后数组越界
    _dayIndex = (_dayIndex > self.dayArr.count - 1) ? (self.dayArr.count - 1) : _dayIndex;
    
    NSInteger day = [self.dayArr[_dayIndex] integerValue];
    // 3.设置 hourArr 数组
    [self setupHourArr:year month:month day:day];
    // 更新索引：防止更新 hourArr 后数组越界
    _hourIndex = (_hourIndex > self.hourArr.count - 1) ? (self.hourArr.count - 1) : _hourIndex;
    
    NSInteger hour = [self.hourArr[_hourIndex] integerValue];
    // 4.设置 minuteArr 数组
    [self setupMinuteArr:year month:month day:day hour:hour];
    // 更新索引：防止更新 monthArr 后数组越界
    _minuteIndex = (_minuteIndex > self.minuteArr.count - 1) ? (self.minuteArr.count - 1) : _minuteIndex;
}

// 设置 yearArr 数组
- (void)setupYearArr {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = self.minLimitDate.br_year; i <= self.maxLimitDate.br_year; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.yearArr = [tempArr copy];
}

// 设置 monthArr 数组
- (void)setupMonthArr:(NSInteger)year {
    NSInteger startMonth = 1;
    NSInteger endMonth = 12;
    if (year == self.minLimitDate.br_year) {
        startMonth = self.minLimitDate.br_month;
    }
    if (year == self.maxLimitDate.br_year) {
        endMonth = self.maxLimitDate.br_month;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endMonth - startMonth + 1)];
    for (NSInteger i = startMonth; i <= endMonth; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.monthArr = [tempArr copy];
}

// 设置 dayArr 数组
- (void)setupDayArr:(NSInteger)year month:(NSInteger)month {
    NSInteger startDay = 1;
    NSInteger endDay = [NSDate br_getDaysInYear:year month:month];
    if (year == self.minLimitDate.br_year && month == self.minLimitDate.br_month) {
        startDay = self.minLimitDate.br_day;
    }
    if (year == self.maxLimitDate.br_year && month == self.maxLimitDate.br_month) {
        endDay = self.maxLimitDate.br_day;
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = startDay; i <= endDay; i++) {
        [tempArr addObject:[NSString stringWithFormat:@"%zi",i]];
    }
    self.dayArr = [tempArr copy];
}

// 设置 hourArr 数组
- (void)setupHourArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSInteger startHour = 0;
    NSInteger endHour = 23;
    if (year == self.minLimitDate.br_year && month == self.minLimitDate.br_month && day == self.minLimitDate.br_day) {
        startHour = self.minLimitDate.br_hour;
    }
    if (year == self.maxLimitDate.br_year && month == self.maxLimitDate.br_month && day == self.maxLimitDate.br_day) {
        endHour = self.maxLimitDate.br_hour;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endHour - startHour + 1)];
    for (NSInteger i = startHour; i <= endHour; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.hourArr = [tempArr copy];
}

// 设置 minuteArr 数组
- (void)setupMinuteArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
    NSInteger startMinute = 0;
    NSInteger endMinute = 59;
    if (year == self.minLimitDate.br_year && month == self.minLimitDate.br_month && day == self.minLimitDate.br_day && hour == self.minLimitDate.br_hour) {
        startMinute = self.minLimitDate.br_minute;
    }
    if (year == self.maxLimitDate.br_year && month == self.maxLimitDate.br_month && day == self.maxLimitDate.br_day && hour == self.maxLimitDate.br_hour) {
        endMinute = self.maxLimitDate.br_minute;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endMinute - startMinute + 1)];
    for (NSInteger i = startMinute; i <= endMinute; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.minuteArr = [tempArr copy];
}

#pragma mark - 滚动到指定的时间位置
- (void)scrollToSelectDate:(NSDate *)selectDate animated:(BOOL)animated {
    // 根据 当前选择的日期 计算出 对应的索引
    NSInteger yearIndex = selectDate.br_year - self.minLimitDate.br_year;
    NSInteger monthIndex = selectDate.br_month - ((yearIndex == 0) ? self.minLimitDate.br_month : 1);
    NSInteger dayIndex = selectDate.br_day - ((yearIndex == 0 && monthIndex == 0) ? self.minLimitDate.br_day : 1);
    NSInteger hourIndex = selectDate.br_hour - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0) ? self.minLimitDate.br_hour : 0);
    NSInteger minuteIndex = selectDate.br_minute - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0 && hourIndex == 0) ? self.minLimitDate.br_minute : 0);
    
    NSArray *indexArr = [NSArray array];
    if (self.showType == BRDatePickerModeYMDHM) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex)];
    } else if (self.showType == BRDatePickerModeMDHM) {
        indexArr = @[@(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex)];
    } else if (self.showType == BRDatePickerModeYMD) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex)];
    } else if (self.showType == BRDatePickerModeYM) {
        indexArr = @[@(yearIndex), @(monthIndex)];
    } else if (self.showType == BRDatePickerModeY) {
        indexArr = @[@(yearIndex)];
    } else if (self.showType == BRDatePickerModeMD) {
        indexArr = @[@(monthIndex), @(dayIndex)];
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
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, self.alertView.frame.size.width, kPickerHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        // 设置子视图的大小随着父视图变化
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _datePicker.datePickerMode = _datePickerMode;
        // 设置该UIDatePicker的国际化Locale，以简体中文习惯显示日期，UIDatePicker控件默认使用iOS系统的国际化Locale
        _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CHS_CN"];
        // textColor 隐藏属性，使用KVC赋值
        // [_datePicker setValue:[UIColor blackColor] forKey:@"textColor"];
        // 设置时间范围
        if (self.minLimitDate) {
            _datePicker.minimumDate = self.minLimitDate;
        }
        if (self.maxLimitDate) {
             _datePicker.maximumDate = self.maxLimitDate;
        }
        // 滚动改变值的响应事件
        [_datePicker addTarget:self action:@selector(didSelectValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - 时间选择器2
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, self.alertView.frame.size.width, kPickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        // 设置子视图的大小随着父视图变化
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource
// 1.指定pickerview有几个表盘(几列)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.showType == BRDatePickerModeYMDHM) {
        return 5;
    } else if (self.showType == BRDatePickerModeMDHM) {
        return 4;
    } else if (self.showType == BRDatePickerModeYMD) {
        return 3;
    } else if (self.showType == BRDatePickerModeYM) {
        return 2;
    } else if (self.showType == BRDatePickerModeY) {
        return 1;
    } else if (self.showType == BRDatePickerModeMD) {
        return 2;
    } else if (self.showType == BRDatePickerModeHM) {
        return 2;
    }
    return 0;
}

// 2.指定每个表盘上有几行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *rowsArr = [NSArray array];
    if (self.showType == BRDatePickerModeYMDHM) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count)];
    } else if (self.showType == BRDatePickerModeMDHM) {
        rowsArr = @[@(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count)];
    } else if (self.showType == BRDatePickerModeYMD) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count)];
    } else if (self.showType == BRDatePickerModeYM) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count)];
    } else if (self.showType == BRDatePickerModeY) {
        rowsArr = @[@(self.yearArr.count)];
    } else if (self.showType == BRDatePickerModeMD) {
        rowsArr = @[@(self.monthArr.count), @(self.dayArr.count)];
    } else if (self.showType == BRDatePickerModeHM) {
        rowsArr = @[@(self.hourArr.count), @(self.minuteArr.count)];
    }
    return [rowsArr[component] integerValue];
}

#pragma mark - UIPickerViewDelegate
// 3.设置 pickerView 的 显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    // 设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0f];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0f];
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20.0f * kScaleFit];
        // 字体自适应属性
        label.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        label.minimumScaleFactor = 0.5f;
    }
    // 给选择器上的label赋值
    [self setDateLabelText:label component:component row:row];
    return label;
}

// 4.选中时回调的委托方法，在此方法中实现省份和城市间的联动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 获取滚动后选择的日期
    self.selectDate = [self getDidSelectedDate:component row:row];
    // 设置是否开启自动回调
    if (_isAutoSelect) {
        // 滚动完成后，执行block回调
        if (self.resultBlock) {
            NSString *selectDateValue = [NSDate br_getDateString:self.selectDate format:self.selectDateFormatter];
            self.resultBlock(selectDateValue);
        }
    }
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f * kScaleFit;
}

- (void)setDateLabelText:(UILabel *)label component:(NSInteger)component row:(NSInteger)row {
    if (self.showType == BRDatePickerModeYMDHM) {
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
        } else if (component == 1) {
            label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
        } else if (component == 2) {
            label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
        } else if (component == 3) {
            label.text = [NSString stringWithFormat:@"%@时", self.hourArr[row]];
        } else if (component == 4) {
            label.text = [NSString stringWithFormat:@"%@分", self.minuteArr[row]];
        }
    } else if (self.showType == BRDatePickerModeMDHM) {
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
        } else if (component == 1) {
            label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
        } else if (component == 2) {
            label.text = [NSString stringWithFormat:@"%@时", self.hourArr[row]];
        } else if (component == 3) {
            label.text = [NSString stringWithFormat:@"%@分", self.minuteArr[row]];
        }
    } else if (self.showType == BRDatePickerModeYMD) {
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
        } else if (component == 1) {
            label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
        } else if (component == 2) {
            label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
        }
    } else if (self.showType == BRDatePickerModeYM) {
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
        } else if (component == 1) {
            label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
        }
    } else if (self.showType == BRDatePickerModeY) {
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
        }
    } else if (self.showType == BRDatePickerModeMD) {
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
        } else if (component == 1) {
            label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
        }
    } else if (self.showType == BRDatePickerModeHM) {
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%@时", self.hourArr[row]];
        } else if (component == 1) {
            label.text = [NSString stringWithFormat:@"%@分", self.minuteArr[row]];
        }
    }
}

- (NSDate *)getDidSelectedDate:(NSInteger)component row:(NSInteger)row {
    NSString *selectDateValue = nil;
    if (self.showType == BRDatePickerModeYMDHM) {
        if (component == 0) {
            _yearIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        } else if (component == 1) {
            _monthIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        } else if (component == 2) {
            _dayIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        } else if (component == 3) {
            _hourIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:4];
        } else if (component == 4) {
            _minuteIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%@-%02ld-%02ld %02ld:%02ld", self.yearArr[_yearIndex], [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue], [self.hourArr[_hourIndex] integerValue], [self.minuteArr[_minuteIndex] integerValue]];
    } else if (self.showType == BRDatePickerModeMDHM) {
        if (component == 0) {
            _monthIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
        } else if (component == 1) {
            _dayIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
        } else if (component == 2) {
            _hourIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:3];
        } else if (component == 3) {
            _minuteIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld", [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue], [self.hourArr[_hourIndex] integerValue], [self.minuteArr[_minuteIndex] integerValue]];
    } else if (self.showType == BRDatePickerModeYMD) {
        if (component == 0) {
            _yearIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
        } else if (component == 1) {
            _monthIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:2];
        } else if (component == 2) {
            _dayIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%@-%02ld-%02ld", self.yearArr[_yearIndex], [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue]];
    } else if (self.showType == BRDatePickerModeYM) {
        if (component == 0) {
            _yearIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            _monthIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%@-%02ld", self.yearArr[_yearIndex], [self.monthArr[_monthIndex] integerValue]];
    } else if (self.showType == BRDatePickerModeY) {
        if (component == 0) {
            _yearIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%@", self.yearArr[_yearIndex]];
    } else if (self.showType == BRDatePickerModeMD) {
        if (component == 0) {
            _monthIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            _dayIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%02ld-%02ld", [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue]];
    } else if (self.showType == BRDatePickerModeHM) {
        if (component == 0) {
            _hourIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            _minuteIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%02ld:%02ld", [self.hourArr[_hourIndex] integerValue], [self.minuteArr[_minuteIndex] integerValue]];
    }
    return [NSDate br_getDate:selectDateValue format:self.selectDateFormatter];
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 时间选择器的滚动响应事件
- (void)didSelectValueChanged:(UIDatePicker *)sender {
    // 读取日期：datePicker.date
    self.selectDate = sender.date;
    
    BOOL selectLessThanMin = [self.selectDate br_compare:self.minLimitDate format:self.selectDateFormatter] == NSOrderedAscending;
    BOOL selectMoreThanMax = [self.selectDate br_compare:self.maxLimitDate format:self.selectDateFormatter] == NSOrderedDescending;
    if (selectLessThanMin) {
        self.selectDate = self.minLimitDate;
    }
    if (selectMoreThanMax) {
        self.selectDate = self.maxLimitDate;
    }
    [self.datePicker setDate:self.selectDate animated:YES];
    
    // 设置是否开启自动回调
    if (_isAutoSelect) {
        // 滚动完成后，执行block回调
        if (self.resultBlock) {
            NSString *selectDateValue = [NSDate br_getDateString:self.selectDate format:self.selectDateFormatter];
            self.resultBlock(selectDateValue);
        }
    }
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    // 点击确定按钮后，执行block回调
    [self dismissWithAnimation:YES];
    if (self.resultBlock) {
        NSString *selectDateValue = [NSDate br_getDateString:self.selectDate format:self.selectDateFormatter];
        self.resultBlock(selectDateValue);
    }
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kPickerHeight + kTopViewHeight + BR_BOTTOM_MARGIN;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kPickerHeight + kTopViewHeight + BR_BOTTOM_MARGIN;
        self.alertView.frame = rect;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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

@end
