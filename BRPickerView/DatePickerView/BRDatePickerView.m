//
//  BRDatePickerView.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRDatePickerView.h"
#import "NSDate+BRAdd.h"

#define kPickerHeight 200
#define kTopViewHeight 44

/// 时间选择器的类型
typedef NS_ENUM(NSInteger, BRDatePickerStyle) {
    BRDatePickerStyleSystem,   // 系统样式：使用 UIDatePicker 类
    BRDatePickerStyleCustom    // 自定义样式：使用 UIPickerView 类
};

@interface BRDatePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    // 记录当前选择的位置
    NSInteger _yearIndex;
    NSInteger _monthIndex;
    NSInteger _dayIndex;
    NSInteger _hourIndex;
    NSInteger _minuteIndex;
    
    NSString *_title;
    UIDatePickerMode _datePickerMode;
    BOOL _isAutoSelect;  // 是否开启自动选择
    UIColor *_themeColor;
}
// 时间选择器1
@property (nonatomic, strong) UIDatePicker *datePicker;
// 时间选择器2
@property (nonatomic, strong) UIPickerView *pickerView;
// 日期存储数组
@property(nonatomic, strong) NSArray *yearArr;
@property(nonatomic, strong) NSArray *monthArr;
@property(nonatomic, strong) NSArray *dayArr;
@property(nonatomic, strong) NSArray *hourArr;
@property(nonatomic, strong) NSArray *minuteArr;
// 显示类型
@property (nonatomic, assign) BRDatePickerMode showType;
// 时间选择器的类型
@property (nonatomic, assign) BRDatePickerStyle style;
/** 限制最小日期 */
@property (nonatomic, strong) NSDate *minLimitDate;
/** 限制最大日期 */
@property (nonatomic, strong) NSDate *maxLimitDate;
// 选择的日期
@property (nonatomic, strong) NSString *selectDateValue;
// 选择的日期的格式
@property (nonatomic, strong) NSString *selectDateFormatter;

// 选中后的回调
@property (nonatomic, copy) BRDateResultBlock resultBlock;
// 取消选择的回调
@property (nonatomic, copy) BRDateCancelBlock cancelBlock;


@end

@implementation BRDatePickerView

#pragma mark - 1.显示时间选择器
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(BRDatePickerMode)type
                defaultSelValue:(NSString *)defaultSelValue
                    resultBlock:(BRDateResultBlock)resultBlock {
    [self showDatePickerWithTitle:title dateType:type defaultSelValue:defaultSelValue minDateStr:nil maxDateStr:nil isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 2.显示时间选择器（支持 设置自动选择 和 自定义主题颜色）
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(BRDatePickerMode)type
                defaultSelValue:(NSString *)defaultSelValue
                     minDateStr:(NSString *)minDateStr
                     maxDateStr:(NSString *)maxDateStr
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(BRDateResultBlock)resultBlock {
    [self showDatePickerWithTitle:title dateType:type defaultSelValue:defaultSelValue minDateStr:minDateStr maxDateStr:maxDateStr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 3.显示时间选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(BRDatePickerMode)type
                defaultSelValue:(NSString *)defaultSelValue
                     minDateStr:(NSString *)minDateStr
                     maxDateStr:(NSString *)maxDateStr
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(BRDateResultBlock)resultBlock
                    cancelBlock:(BRDateCancelBlock)cancelBlock {
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithTitle:title dateType:type defaultSelValue:defaultSelValue minDateStr:minDateStr maxDateStr:maxDateStr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    [datePickerView showWithAnimation:YES];
}

#pragma mark - 初始化时间选择器
- (instancetype)initWithTitle:(NSString *)title
                     dateType:(BRDatePickerMode)type
              defaultSelValue:(NSString *)defaultSelValue
                   minDateStr:(NSString *)minDateStr
                   maxDateStr:(NSString *)maxDateStr
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
        self.showType = type;
        [self setupSelectDateFormatter:type];
        // 不设置默认日期，就默认选中今天的日期
        if (defaultSelValue && defaultSelValue.length > 0) {
            self.selectDateValue = defaultSelValue;
        } else {
            self.selectDateValue = [NSDate currentDateStringWithFormat:self.selectDateFormatter];
        }
        // 最小日期限制
        if (minDateStr && minDateStr.length > 0) {
            self.minLimitDate = [NSDate getDate:minDateStr format:@"yyyy-MM-dd HH:mm:ss"];
        } else {
            if (self.style == BRDatePickerStyleCustom) {
                self.minLimitDate = [NSDate getDate:@"1900-01-01 00:00:00" format:@"yyyy-MM-dd HH:mm:ss"];
            }
        }
        // 最大日期限制
        if (maxDateStr && maxDateStr.length > 0) {
            self.maxLimitDate = [NSDate getDate:maxDateStr format:@"yyyy-MM-dd HH:mm:ss"];
        } else {
            if (self.style == BRDatePickerStyleCustom) {
                self.maxLimitDate = [NSDate getDate:@"2099-12-31 23:59:00" format:@"yyyy-MM-dd HH:mm:ss"];
            }
        }
        
        NSAssert([self.minLimitDate compare:self.maxLimitDate] != NSOrderedDescending, @"最小日期不能大于最大日期！");
        
        if (self.style == BRDatePickerStyleCustom) {
            [self initData];
        }
        [self initUI];
        
        NSDate *selectedDate = [NSDate getDate:self.selectDateValue format:self.selectDateFormatter];
        if (!selectedDate) {
            NSLog(@"参数异常！请检查，参数:defaultSelValue 的格式");
            selectedDate = [NSDate date]; // 默认值参数异常时，重置默认值，防止崩溃！
        }
        // 默认滚动的行
        if (self.style == BRDatePickerStyleSystem) {
            [self.datePicker setDate:selectedDate animated:YES];
        } else if (self.style == BRDatePickerStyleCustom) {
            [self scrollToDate:selectedDate animated:YES];
        }
    }
    return self;
}

- (void)setupSelectDateFormatter:(BRDatePickerMode)type {
    switch (type) {
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

#pragma mark - 滚动到指定的时间位置
- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated {
    if (!date) {
        date = [NSDate date];
    }
    _yearIndex = date.year - self.minLimitDate.year;
    _monthIndex = date.month - 1;
    _dayIndex = date.day - 1;
    _hourIndex = date.hour;
    _minuteIndex = date.minute;
    NSArray *indexArr = [NSArray array];
    if (self.showType == BRDatePickerModeYMDHM) {
        indexArr = @[@(_yearIndex), @(_monthIndex), @(_dayIndex), @(_hourIndex), @(_minuteIndex)];
    } else if (self.showType == BRDatePickerModeMDHM) {
        indexArr = @[@(_monthIndex), @(_dayIndex), @(_hourIndex), @(_minuteIndex)];
    } else if (self.showType == BRDatePickerModeYMD) {
        indexArr = @[@(_yearIndex), @(_monthIndex), @(_dayIndex)];
    } else if (self.showType == BRDatePickerModeYM) {
        indexArr = @[@(_yearIndex), @(_monthIndex)];
    } else if (self.showType == BRDatePickerModeY) {
        indexArr = @[@(_yearIndex)];
    } else if (self.showType == BRDatePickerModeMD) {
        indexArr = @[@(_monthIndex), @(_dayIndex)];
    } else if (self.showType == BRDatePickerModeHM) {
        indexArr = @[@(_hourIndex), @(_minuteIndex)];
    }
    for (NSInteger i = 0; i < indexArr.count; i++) {
        [self.pickerView selectRow:[indexArr[i] integerValue] inComponent:i animated:animated];
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

- (void)initData {
    NSMutableArray *tempYearArr = [NSMutableArray array];
    NSMutableArray *tempMonthArr = [NSMutableArray array];
    NSMutableArray *tempHourArr = [NSMutableArray array];
    NSMutableArray *tempMinuteArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 60; i++) {
        NSString *num = [NSString stringWithFormat:@"%zi",i];
        if (i > 0 && i <= 12) {
            [tempMonthArr addObject:num];
        }
        if (i < 24) {
            [tempHourArr addObject:num];
        }
        [tempMinuteArr addObject:num];
    }
    for (NSInteger i = self.minLimitDate.year; i <= self.maxLimitDate.year; i++) {
        NSString *num = [NSString stringWithFormat:@"%zi", i];
        [tempYearArr addObject:num];
    }
    self.yearArr = tempYearArr;
    self.monthArr = tempMonthArr;
    self.hourArr = tempHourArr;
    self.minuteArr = tempMinuteArr;
}

#pragma mark - 时间选择器
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, SCREEN_WIDTH, kDatePicHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
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

#pragma mark - 时间选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, SCREEN_WIDTH, kPickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
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
    NSInteger year = [self.yearArr[_yearIndex] integerValue];
    if (self.showType == BRDatePickerModeMDHM || self.showType == BRDatePickerModeMD) {
        year = [NSDate date].year;
    }
    NSInteger month = [self.monthArr[_monthIndex] integerValue];
    NSInteger days = [NSDate getDaysInYear:year month:month];
    [self setupDayArr:days];
    if (self.showType == BRDatePickerModeYMDHM) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(days), @(self.hourArr.count), @(self.minuteArr.count)];
    } else if (self.showType == BRDatePickerModeMDHM) {
        rowsArr = @[@(self.monthArr.count), @(days), @(self.hourArr.count), @(self.minuteArr.count)];
    } else if (self.showType == BRDatePickerModeYMD) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(days)];
    } else if (self.showType == BRDatePickerModeYM) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count)];
    } else if (self.showType == BRDatePickerModeY) {
        rowsArr = @[@(self.yearArr.count)];
    } else if (self.showType == BRDatePickerModeMD) {
        rowsArr = @[@(self.monthArr.count), @(days)];
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
    [self setSelectedIndex:component row:row];
    [pickerView reloadAllComponents];
    
    // 设置是否开启自动回调
    if (_isAutoSelect) {
        // 滚动完成后，执行block回调
        if (self.resultBlock) {
            self.resultBlock(self.selectDateValue);
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

// 刷新day列数据（当年/月份改变时，都要重新刷新日的数据）
- (void)reloadDayComponent {
    // 1. 根据年和月计算出天数
    NSInteger selectYear = [self.yearArr[_yearIndex] integerValue];
    if (self.showType == BRDatePickerModeMDHM || self.showType == BRDatePickerModeMD) {
        selectYear = [NSDate date].year;
    }
    NSInteger selectMonth = [self.monthArr[_monthIndex] integerValue];
    NSInteger days = [NSDate getDaysInYear:selectYear month:selectMonth];
    // 2. 计算天数后，重新给 dayArr 数组赋值
    [self setupDayArr:days];
    // 3. 防止数组越界
    if (_dayIndex > self.dayArr.count - 1) {
        _dayIndex = self.dayArr.count - 1;
    }
    [self.pickerView reloadAllComponents];
}

// 设置每月的天数数组
- (void)setupDayArr:(NSInteger)days {
    NSMutableArray *tempDayArr = [NSMutableArray array];
    for (NSInteger i = 1; i <= days; i++) {
        [tempDayArr addObject:[NSString stringWithFormat:@"%zi",i]];
    }
    self.dayArr = tempDayArr;
}

- (void)setSelectedIndex:(NSInteger)component row:(NSInteger)row {
    if (self.showType == BRDatePickerModeYMDHM) {
        if (component == 0) {
            _yearIndex = row;
            [self reloadDayComponent];
        } else if (component == 1) {
            _monthIndex = row;
            [self reloadDayComponent];
        } else if (component == 2) {
            _dayIndex = row;
        } else if (component == 3) {
            _hourIndex = row;
        } else if (component == 4) {
            _minuteIndex = row;
        }
        self.selectDateValue = [NSString stringWithFormat:@"%@-%02zi-%02zi %02zi:%02zi", self.yearArr[_yearIndex], [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue], [self.hourArr[_hourIndex] integerValue], [self.minuteArr[_minuteIndex] integerValue]];
    } else if (self.showType == BRDatePickerModeMDHM) {
        if (component == 0) {
            _monthIndex = row;
            [self reloadDayComponent];
        } else if (component == 1) {
            _dayIndex = row;
        } else if (component == 2) {
            _hourIndex = row;
        } else if (component == 3) {
            _minuteIndex = row;
        }
        self.selectDateValue = [NSString stringWithFormat:@"%02zi-%02zi %02zi:%02zi", [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue], [self.hourArr[_hourIndex] integerValue], [self.minuteArr[_minuteIndex] integerValue]];
    } else if (self.showType == BRDatePickerModeYMD) {
        if (component == 0) {
            _yearIndex = row;
            [self reloadDayComponent];
        } else if (component == 1) {
            _monthIndex = row;
            [self reloadDayComponent];
        } else if (component == 2) {
            _dayIndex = row;
        }
        self.selectDateValue = [NSString stringWithFormat:@"%@-%02zi-%02zi", self.yearArr[_yearIndex], [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue]];
    } else if (self.showType == BRDatePickerModeYM) {
        if (component == 0) {
            _yearIndex = row;
        } else if (component == 1) {
            _monthIndex = row;
        }
        self.selectDateValue = [NSString stringWithFormat:@"%@-%02zi", self.yearArr[_yearIndex], [self.monthArr[_monthIndex] integerValue]];
    } else if (self.showType == BRDatePickerModeY) {
        if (component == 0) {
            _yearIndex = row;
        }
        self.selectDateValue = [NSString stringWithFormat:@"%@", self.yearArr[_yearIndex]];
    } else if (self.showType == BRDatePickerModeMD) {
        if (component == 0) {
            _monthIndex = row;
            [self reloadDayComponent];
        } else if (component == 1) {
            _dayIndex = row;
        }
        self.selectDateValue = [NSString stringWithFormat:@"%02zi-%02zi", [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue]];
    } else if (self.showType == BRDatePickerModeHM) {
        if (component == 0) {
            _hourIndex = row;
        } else if (component == 1) {
            _minuteIndex = row;
        }
        self.selectDateValue = [NSString stringWithFormat:@"%02zi:%02zi", [self.hourArr[_hourIndex] integerValue], [self.minuteArr[_minuteIndex] integerValue]];
    }
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
    if (self.cancelBlock) {
        self.cancelBlock();
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
            rect.origin.y -= kDatePicHeight + kTopViewHeight;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kDatePicHeight + kTopViewHeight;
        self.alertView.frame = rect;
        
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.leftBtn removeFromSuperview];
        [self.rightBtn removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.topView removeFromSuperview];
        [self.datePicker removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        self.datePicker = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}

#pragma mark - 时间选择器的滚动响应事件
- (void)didSelectValueChanged:(UIDatePicker *)sender {
    // 读取日期：datePicker.date
    self.selectDateValue = [NSDate getDateString:sender.date format:self.selectDateFormatter];
    // 设置是否开启自动回调
    if (_isAutoSelect) {
        // 滚动完成后，执行block回调
        if (self.resultBlock) {
            self.resultBlock(self.selectDateValue);
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
        self.resultBlock(self.selectDateValue);
    }
}

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
