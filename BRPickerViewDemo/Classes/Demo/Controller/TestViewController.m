//
//  TestViewController.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//

#import "TestViewController.h"
#import "BRPickerView.h"
#import "BRInfoCell.h"
#import "BRInfoModel.h"
#import "Test2ViewController.h"

typedef NS_ENUM(NSUInteger, BRTimeType) {
    BRTimeTypeBeginTime = 0,
    BRTimeTypeEndTime
};
@interface TestViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
/// footerView
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITextField *beginTimeTF;
@property (nonatomic, strong) UITextField *endTimeTF;
@property (nonatomic, strong) UIView *beginTimeLineView;
@property (nonatomic, strong) UIView *endTimeLineView;
@property (nonatomic, strong) BRDatePickerView *datePickerView;


@property (nonatomic, copy) NSArray *titleArr;

@property (nonatomic, strong) BRInfoModel *infoModel;

@property (nonatomic, assign) BRTimeType timeType;

@property (nonatomic, assign) NSInteger genderSelectIndex;
@property (nonatomic, strong) NSDate *birthdaySelectDate;
@property (nonatomic, strong) NSDate *birthtimeSelectDate;
@property (nonatomic, assign) NSInteger educationSelectIndex;
@property (nonatomic, copy) NSArray <NSNumber *> *addressSelectIndexs;
@property (nonatomic, copy) NSArray <NSNumber *> *otherSelectIndexs;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Demo";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"可变日期选择器" style:UIBarButtonItemStylePlain target:self action:@selector(clickGotoTest2VC)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveBtn)];
    [self loadData];
    [self initUI];
    
    // 设置开始时间默认选择的值及状态
    //NSString *beginTime = @"2018-10-01";
    NSString *beginTime = nil;
    if (beginTime && beginTime.length > 0) {
        self.beginTimeTF.text = beginTime;
        self.beginTimeTF.textColor = [UIColor blueColor];
        self.beginTimeLineView.backgroundColor = [UIColor blueColor];
        // 设置选择器滚动到指定的日期
        self.datePickerView.selectDate = [NSDate br_getDate:self.beginTimeTF.text format:@"yyyy-MM-dd"];
    }
}

- (void)loadData {
    NSLog(@"-----加载数据-----");
    self.infoModel.nameStr = @"";
    self.infoModel.genderStr = @"";
    self.infoModel.birthdayStr = @"";
    self.infoModel.birthtimeStr = @"";
    self.infoModel.phoneStr = @"";
    self.infoModel.addressStr = @"";
    self.infoModel.educationStr = @"";
    self.infoModel.otherStr = @"";
}

- (void)initUI {
    self.tableView.hidden = NO;
}

- (void)clickGotoTest2VC {
    Test2ViewController *test2VC = [[Test2ViewController alloc]init];
    [self.navigationController pushViewController:test2VC animated:YES];
}

- (void)clickSaveBtn {
    NSLog(@"-----保存数据-----");
    NSLog(@"姓名：%@", self.infoModel.nameStr);
    NSLog(@"性别：%@", self.infoModel.genderStr);
    NSLog(@"出生日期：%@", self.infoModel.birthdayStr);
    NSLog(@"出生时刻：%@", self.infoModel.birthtimeStr);
    NSLog(@"联系方式：%@", self.infoModel.phoneStr);
    NSLog(@"地址：%@", self.infoModel.addressStr);
    NSLog(@"学历：%@", self.infoModel.educationStr);
    NSLog(@"其它：%@", self.infoModel.otherStr);
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400)];
        _footerView.backgroundColor = [UIColor clearColor];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // 1.切换日期选择器的显示模式
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"年月日", @"年月", @"年"]];
        segmentedControl.frame = CGRectMake((SCREEN_WIDTH - 200) / 2, 50, 200, 36);
        // 设置圆角和边框
        segmentedControl.layer.cornerRadius = 3.0f;
        segmentedControl.layer.masksToBounds = YES;
        segmentedControl.layer.borderWidth = 0.5f;
        segmentedControl.layer.borderColor = [UIColor blueColor].CGColor;
        // 设置标题颜色
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} forState:UIControlStateNormal];
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} forState:UIControlStateSelected];
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl addTarget:self action:@selector(pickerModeSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        [_footerView addSubview:segmentedControl];
        
        
        // 2.开始时间label
        UITextField *beginTimeTF = [self getTextField:CGRectMake(SCREEN_WIDTH / 2 - 120 - 15, 110, 120, 36) placeholder:@"开始时间"];
        beginTimeTF.tag = 100;
        beginTimeTF.textColor = [UIColor blackColor];
        beginTimeTF.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.beginTimeTF = beginTimeTF;
        [_footerView addSubview:beginTimeTF];
        
        UIView *beginTimeLineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 120 - 15, 146, 120, 0.8f)];
        beginTimeLineView.backgroundColor = [UIColor lightGrayColor];
        [_footerView addSubview:beginTimeLineView];
        self.beginTimeLineView = beginTimeLineView;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 15, 110, 30, 36)];
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.text = @"至";
        [_footerView addSubview:label];
        
        // 结束时间label
        UITextField *endTimeTF = [self getTextField:CGRectMake(SCREEN_WIDTH / 2 + 15, 110, 120, 36) placeholder:@"结束时间"];
        endTimeTF.tag = 101;
        endTimeTF.textColor = [UIColor blackColor];
        endTimeTF.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.endTimeTF = endTimeTF;
        [_footerView addSubview:endTimeTF];
        
        UIView *endTimeLineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 15, 146, 120, 0.8f)];
        endTimeLineView.backgroundColor = [UIColor lightGrayColor];
        [_footerView addSubview:endTimeLineView];
        self.endTimeLineView = endTimeLineView;
        
        
        // 3.创建选择器容器视图
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(30, 170, _footerView.frame.size.width - 60, 200)];
        containerView.backgroundColor = [UIColor redColor];
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_footerView addSubview:containerView];
        
        // 提示：当 containerView 使用自动布局时，需先立即刷新布局，计算出frame后；再添加选择器视图（否则无法正常显示选择器视图）
        // 立即刷新布局
        //[containerView setNeedsLayout];
        //[containerView layoutIfNeeded];
        
        // 4.创建日期选择器
        BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
        datePickerView.pickerMode = BRDatePickerModeYMD;
        datePickerView.selectDate = [NSDate br_getDate:self.endTimeTF.text format:@"yyyy-MM-dd"];
        datePickerView.minDate = [NSDate br_setYear:2010 month:10 day:1];
        datePickerView.maxDate = [NSDate date];
        datePickerView.showWeek = YES;
        datePickerView.isAutoSelect = YES;
        datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            if (self.timeType == BRTimeTypeBeginTime) {
                self.beginTimeTF.text = selectValue;
            } else if (self.timeType == BRTimeTypeEndTime) {
                self.endTimeTF.text = selectValue;
            }
        };
        // 自定义选择器主题样式
        BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
        customStyle.pickerColor = BR_RGB_HEX(0xd9dbdf, 1.0f);
        datePickerView.pickerStyle = customStyle;
        self.datePickerView = datePickerView;
        
        // 添加选择器到容器视图
        [datePickerView addPickerToView:containerView];
        
    }
    return _footerView;
}

#pragma mark - 切换日期显示模式
- (void)pickerModeSegmentedControlAction:(UISegmentedControl *)sender {
    NSInteger selecIndex = sender.selectedSegmentIndex;
    if (selecIndex == 0) {
        NSLog(@"年月日");
        self.datePickerView.pickerMode = BRDatePickerModeYMD;
        self.beginTimeTF.text = nil;
        self.endTimeTF.text = nil;
        self.beginTimeLineView.backgroundColor = [UIColor lightGrayColor];
        self.endTimeLineView.backgroundColor = [UIColor lightGrayColor];
    } else if (selecIndex == 1) {
        NSLog(@"年月");
        self.datePickerView.pickerMode = BRDatePickerModeYM;
        self.beginTimeTF.text = nil;
        self.endTimeTF.text = nil;
        self.beginTimeLineView.backgroundColor = [UIColor lightGrayColor];
        self.endTimeLineView.backgroundColor = [UIColor lightGrayColor];
    } else if (selecIndex == 2) {
        NSLog(@"年");
        self.datePickerView.pickerMode = BRDatePickerModeY;
        self.beginTimeTF.text = nil;
        self.endTimeTF.text = nil;
        self.beginTimeLineView.backgroundColor = [UIColor lightGrayColor];
        self.endTimeLineView.backgroundColor = [UIColor lightGrayColor];
    }
}

- (UITextField *)getTextField:(CGRect)frame placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.placeholder = placeholder;
    textField.delegate = self;
    
    return textField;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        if (@available(iOS 13.0, *)) {
            _tableView.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            _tableView.backgroundColor = [UIColor whiteColor];
        }
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableFooterView = self.footerView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"testCell";
    BRInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[BRInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.titleLabel.text = self.titleArr[indexPath.row];
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:
        {
            cell.isNext = NO;
            cell.textField.placeholder = @"请输入";
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.text = self.infoModel.nameStr;
        }
            break;
        case 1:
        {
            cell.isNext = YES;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.genderStr;
        }
            break;
        case 2:
        {
            cell.isNext = YES;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.birthdayStr;
        }
            break;
        case 3:
        {
            cell.isNext = YES;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.birthtimeStr;
        }
            break;
        case 4:
        {
            cell.isNext = NO;
            cell.textField.placeholder = @"请输入";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.text = self.infoModel.phoneStr;
        }
            break;
        case 5:
        {
            cell.isNext = YES;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.addressStr;
        }
            break;
        case 6:
        {
            cell.isNext = YES;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.educationStr;
        }
            break;
        case 7:
        {
            cell.isNext = YES;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.otherStr;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

#pragma mark - 获取地区数据源
- (NSArray *)getAddressDataSource {
    // 加载地区数据源（实际开发中这里可以写网络请求，从服务端请求数据。可以把 BRCity.json 文件的数据放到服务端去维护，通过接口获取这个数据源数组）
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"BRCity.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *dataSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    return dataSource;
}

#pragma mark - UITextFieldDelegate 返回键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 4) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 4) {
        [textField addTarget:self action:@selector(handlerTextFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
        return YES; // 当前 textField 可以编辑
    } else {
        [self.view endEditing:YES];
        [self handlerTextFieldSelect:textField];
        return NO; // 当前 textField 不可编辑，可以响应点击事件
    }
}

#pragma mark - 处理编辑事件
- (void)handlerTextFieldEndEdit:(UITextField *)textField {
    NSLog(@"结束编辑:%@", textField.text);
    switch (textField.tag) {
        case 0:
        {
            self.infoModel.nameStr = textField.text;
        }
            break;
        case 4:
        {
            self.infoModel.phoneStr = textField.text;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 处理点击事件
- (void)handlerTextFieldSelect:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
        {
            // 性别
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
            stringPickerView.title = @"请选择性别";
            stringPickerView.dataSourceArr = @[@"男", @"女", @"其他"];
            stringPickerView.selectIndex = self.genderSelectIndex ;
            stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
                self.genderSelectIndex = resultModel.index;
                self.infoModel.genderStr = resultModel.selectValue;
                textField.text = resultModel.selectValue;
            };
            [stringPickerView show];
            
        }
            break;
        case 2:
        {
            // 出生年月日
            BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeYMD];
            datePickerView.title = @"请选择年月日";
            //datePickerView.selectValue = @"1948-10-01";
            datePickerView.selectDate = self.birthdaySelectDate;
            datePickerView.minDate = [NSDate br_setYear:1948 month:10 day:1];
            datePickerView.isAutoSelect = YES;
            datePickerView.addToNow = YES;
            //datePickerView.showToday = YES;
            datePickerView.showWeek = YES;
            datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
                self.birthdaySelectDate = selectDate;
                self.infoModel.birthdayStr = selectValue;
                textField.text = selectValue;
                
                NSLog(@"selectValue=%@", selectValue);
                NSLog(@"selectDate=%@", selectDate);
                NSLog(@"---------------------------------");
            };
            
            // 自定义弹框样式
            BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
            customStyle.topCornerRadius = 16.0f;
            customStyle.hiddenTitleBottomBorder = YES;
            customStyle.hiddenCancelBtn = YES;
            customStyle.doneBtnImage = [UIImage imageNamed:@"icon_close"];
            customStyle.doneBtnFrame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
            customStyle.pickerTextFont = [UIFont systemFontOfSize:20.0f];
            datePickerView.pickerStyle = customStyle;
            
            [datePickerView show];
            
        }
            break;
        case 3:
        {
            // 出生时刻
            BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeHMS];
            datePickerView.title = @"出生时刻";
            datePickerView.selectDate = self.birthtimeSelectDate;
            datePickerView.isAutoSelect = YES;
            datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
                self.birthtimeSelectDate = selectDate;
                self.infoModel.birthtimeStr = selectValue;
                textField.text = selectValue;
            };
            
            // 自定义弹框样式
            BRPickerStyle *customStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor darkGrayColor]];
            datePickerView.pickerStyle = customStyle;
            
            [datePickerView show];
            
        }
            break;
        case 5:
        {
            // 地区
            BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]initWithPickerMode:BRAddressPickerModeArea];
            addressPickerView.title = @"请选择地区";
            //addressPickerView.selectValues = [self.infoModel.addressStr componentsSeparatedByString:@" "];
            addressPickerView.selectIndexs = self.addressSelectIndexs;
            addressPickerView.isAutoSelect = YES;
            addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                self.addressSelectIndexs = @[@(province.index), @(city.index), @(area.index)];
                self.infoModel.addressStr = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
                textField.text = self.infoModel.addressStr;
            };
            
            // 自定义弹框样式（适配深色模式）
            addressPickerView.pickerStyle = [self pickerStyleWithDarkModel];
            
            [addressPickerView show];
            
        }
            break;
        case 6:
        {
            // 学历
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
            stringPickerView.title = @"请选择学历";
            stringPickerView.plistName = @"testData1.plist";
            stringPickerView.selectIndex = self.educationSelectIndex;
            //stringPickerView.selectValue = self.infoModel.educationStr;
            stringPickerView.isAutoSelect = YES;
            stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
                self.educationSelectIndex = resultModel.index;
                self.infoModel.educationStr = resultModel.name;
                textField.text = self.infoModel.educationStr;
            };
            
            // 自定义弹框样式
            BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
            customStyle.pickerColor = BR_RGB_HEX(0xd9dbdf, 1.0f);
            customStyle.separatorColor = [UIColor clearColor];
            stringPickerView.pickerStyle = customStyle;
            
            [stringPickerView show];
            
        }
            break;
        case 7:
        {
            /// 其它
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentMulti];
            stringPickerView.title = @"自定义多列字符串";
            stringPickerView.dataSourceArr = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
            stringPickerView.selectIndexs = self.otherSelectIndexs;
            //stringPickerView.selectValues = [self.infoModel.otherStr componentsSeparatedByString:@"，"];
            stringPickerView.isAutoSelect = YES;
            stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> *resultModelArr) {
                self.otherSelectIndexs = @[@(resultModelArr[0].index), @(resultModelArr[1].index)];
                self.infoModel.otherStr = [NSString stringWithFormat:@"%@，%@", resultModelArr[0].name, resultModelArr[1].name];
                textField.text = self.infoModel.otherStr;
            };
            
            // 自定义弹框样式
            BRPickerStyle *customStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor orangeColor]];
            customStyle.pickerTextColor = [UIColor redColor];
            customStyle.separatorColor = [UIColor redColor];
            customStyle.titleTextColor = [UIColor redColor];
            stringPickerView.pickerStyle = customStyle;
            
            [stringPickerView show];
            
        }
            break;
            
        case 100:
        {
            NSLog(@"开始时间：%@", self.beginTimeTF.text);
            self.timeType = BRTimeTypeBeginTime;
            self.endTimeTF.textColor = [UIColor blackColor];
            self.endTimeLineView.backgroundColor = [UIColor lightGrayColor];
            self.beginTimeTF.textColor = [UIColor blueColor];
            self.beginTimeLineView.backgroundColor = [UIColor blueColor];
            
            NSString *format = @"yyyy-MM-dd";
            if (self.datePickerView.pickerMode == BRDatePickerModeYM) {
                format = @"yyyy-MM";
            } else if (self.datePickerView.pickerMode == BRDatePickerModeY) {
                format = @"yyyy";
            }
            if (self.beginTimeTF.text.length == 0) {
                self.beginTimeTF.text = [NSDate br_getDateString:[NSDate date] format:format];
            }
            // 设置选择器滚动到指定的日期
            //self.datePickerView.selectValue = self.beginTimeTF.text;
            self.datePickerView.selectDate = [NSDate br_getDate:self.beginTimeTF.text format:format];
        }
            break;
            
        case 101:
        {
            NSLog(@"结束时间:%@", self.endTimeTF.text);
            self.timeType = BRTimeTypeEndTime;
            self.beginTimeTF.textColor = [UIColor blackColor];
            self.beginTimeLineView.backgroundColor = [UIColor lightGrayColor];
            self.endTimeTF.textColor = [UIColor blueColor];
            self.endTimeLineView.backgroundColor = [UIColor blueColor];
            
            NSString *format = @"yyyy-MM-dd";
            if (self.datePickerView.pickerMode == BRDatePickerModeYM) {
                format = @"yyyy-MM";
            } else if (self.datePickerView.pickerMode == BRDatePickerModeY) {
                format = @"yyyy";
            }
            if (self.endTimeTF.text.length == 0) {
                self.endTimeTF.text = [NSDate br_getDateString:[NSDate date] format:format];
            }
            // 设置选择器滚动到指定的日期
            //self.datePickerView.selectValue = self.endTimeTF.text;
            self.datePickerView.selectDate = [NSDate br_getDate:self.endTimeTF.text format:format];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 快捷设置自定义样式 - 适配默认深色模式样式
/// 注意：下面的颜色是iOS13新出来的系统颜色，主要用于适配深色模式，升级Xcode11以上才能编译，编译报错也可以直接注释掉
- (BRPickerStyle *)pickerStyleWithDarkModel {
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    // 自定义主题样式（适配深色模式）
    if (@available(iOS 13.0, *)) {
        customStyle.maskColor = [[UIColor labelColor] colorWithAlphaComponent:0.2f];
        customStyle.shadowLineColor = [UIColor quaternaryLabelColor];
        customStyle.titleBarColor = [UIColor systemBackgroundColor];
        customStyle.cancelTextColor = [UIColor labelColor];
        customStyle.doneTextColor = [UIColor labelColor];
        customStyle.titleTextColor = [UIColor placeholderTextColor];
        customStyle.titleLineColor = [UIColor quaternaryLabelColor];
        
        customStyle.pickerColor = [UIColor systemBackgroundColor];
        customStyle.pickerTextColor = [UIColor labelColor];
        customStyle.separatorColor = [UIColor separatorColor];
    }
    
    return customStyle;
}

//#pragma mark - 刷新指定行的数据
//- (void)reloadData:(NSInteger)section row:(NSInteger)row {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"姓名", @"性别", @"出生年月", @"出生时刻", @"联系方式", @"地址", @"学历", @"其它"];
    }
    return _titleArr;
}

- (BRInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[BRInfoModel alloc]init];
    }
    return _infoModel;
}

- (NSArray<NSNumber *> *)addressSelectIndexs {
    if (!_addressSelectIndexs) {
        _addressSelectIndexs = [NSArray array];
    }
    return _addressSelectIndexs;
}

- (NSArray<NSNumber *> *)otherSelectIndexs {
    if (!_otherSelectIndexs) {
        _otherSelectIndexs = [NSArray array];
    }
    return _otherSelectIndexs;
}

@end
