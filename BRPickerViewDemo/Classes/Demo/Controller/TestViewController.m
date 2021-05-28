//
//  TestViewController.m
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "TestViewController.h"
#import "BRPickerView.h"
#import "BRInfoCell.h"
#import "BRInfoModel.h"
#import "UIImage+Color.h"
#import "UIColor+BRAdd.h"
#import "Test2ViewController.h"

#define kThemeColor BR_RGB_HEX(0x2e70c2, 1.0f)

typedef NS_ENUM(NSInteger, BRTimeType) {
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
@property (nonatomic, copy) NSArray <NSNumber *> *linkage2SelectIndexs;
@property (nonatomic, copy) NSArray <NSNumber *> *linkage3SelectIndexs;

@property (nonatomic, strong) NSDate *beginSelectDate;
@property (nonatomic, strong) NSDate *endSelectDate;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Demo";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"其它" style:UIBarButtonItemStylePlain target:self action:@selector(clickGotoTest2VC)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveBtn)];
    [self loadData];
    [self initUI];
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
}

- (void)initUI {
    self.tableView.hidden = NO;
    
    // 设置开始时间默认选择的值及状态
    self.beginSelectDate = [NSDate date];
    self.beginTimeTF.text = [NSDate br_stringFromDate:self.beginSelectDate dateFormat:@"yyyy-MM-dd HH"];
    self.beginTimeTF.textColor = kThemeColor;
    self.beginTimeLineView.backgroundColor = kThemeColor;
    // 设置选择器滚动到指定的日期
    self.datePickerView.selectDate = self.beginSelectDate;
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
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
            cell.canEdit = YES;
            cell.textField.placeholder = @"请输入";
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.text = self.infoModel.nameStr;
        }
            break;
        case 1:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.genderStr;
        }
            break;
        case 2:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.birthdayStr;
        }
            break;
        case 3:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.birthtimeStr;
        }
            break;
        case 4:
        {
            cell.canEdit = YES;
            cell.textField.placeholder = @"请输入";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.text = self.infoModel.phoneStr;
        }
            break;
        case 5:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.addressStr;
        }
            break;
        case 6:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.educationStr;
        }
            break;
        case 7:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
        }
            break;
        case 8:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
        }
            break;
        case 9:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
        }
            break;
        case 10:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
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
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
            stringPickerView.pickerMode = BRStringPickerComponentSingle;
            stringPickerView.title = @"请选择性别";
            stringPickerView.dataSourceArr = @[@"男", @"女", @"其他"];
            stringPickerView.selectIndex = self.genderSelectIndex ;
            stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
                self.genderSelectIndex = resultModel.index;
                self.infoModel.genderStr = resultModel.value;
                textField.text = resultModel.value;
            };
            [stringPickerView show];
            
        }
            break;
            
        case 2:
        {
            // 出生年月日
            BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
            datePickerView.pickerMode = BRDatePickerModeYMD;
            datePickerView.title = @"请选择年月日";
            datePickerView.selectDate = self.birthdaySelectDate;
            datePickerView.minDate = [NSDate br_setYear:2018 month:3 day:10];
            datePickerView.maxDate = [NSDate br_setYear:2025 month:10 day:20];
            datePickerView.isAutoSelect = YES;
            //datePickerView.monthNames = @[@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月"];
            //datePickerView.customUnit = @{@"year": @"Y", @"month": @"M", @"day": @"D", @"hour": @"H", @"minute": @"M", @"second": @"S"};
            // 指定不可选择的日期
            //datePickerView.nonSelectableDates = @[[NSDate br_setYear:2020 month:8 day:1], [NSDate br_setYear:2020 month:9 day:10]];
            datePickerView.keyView = self.view; // 将组件 datePickerView 添加到 self.view 上，默认是添加到 keyWindow 上
            datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
                self.birthdaySelectDate = selectDate;
                self.infoModel.birthdayStr = selectValue;
                textField.text = selectValue;
                
                NSLog(@"selectValue=%@", selectValue);
                NSLog(@"selectDate=%@", selectDate);
                NSLog(@"---------------------------------");
                
            };
            
            // 设置年份背景
            UILabel *yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 216)];
            yearLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            yearLabel.backgroundColor = [UIColor clearColor];
            yearLabel.textAlignment = NSTextAlignmentCenter;
            yearLabel.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2f];
            yearLabel.font = [UIFont boldSystemFontOfSize:100.0f];
            NSString *yearString = self.birthdaySelectDate ? @(self.birthdaySelectDate.br_year).stringValue : @([NSDate date].br_year).stringValue;
            if (self.infoModel.birthdayStr && [self.infoModel.birthdayStr containsString:@"自定义"]) {
                yearString = @"";
            }
            yearLabel.text = yearString;
            [datePickerView.alertView addSubview:yearLabel];
            // 滚动选择器，动态更新年份
            datePickerView.changeBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                yearLabel.text = selectDate ? @(selectDate.br_year).stringValue : @"";
            };
            
            BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
            customStyle.pickerColor = [UIColor clearColor];
            customStyle.selectRowTextColor = [UIColor blueColor];
            datePickerView.pickerStyle = customStyle;
            
            [datePickerView show];
            
        }
            break;
            
        case 3:
        {
            // 出生时刻
            BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
            datePickerView.pickerMode = BRDatePickerModeHMS;
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
            BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]init];
            addressPickerView.pickerMode = BRAddressPickerModeArea;
            addressPickerView.title = @"请选择地区";
            //addressPickerView.selectValues = [self.infoModel.addressStr componentsSeparatedByString:@" "];
            addressPickerView.selectIndexs = self.addressSelectIndexs;
            addressPickerView.isAutoSelect = YES;
            addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                self.addressSelectIndexs = @[@(province.index), @(city.index), @(area.index)];
                self.infoModel.addressStr = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
                textField.text = self.infoModel.addressStr;
            };
            
            [addressPickerView show];
            
        }
            break;
            
        case 6:
        {
            // 学历
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
            stringPickerView.pickerMode = BRStringPickerComponentSingle;
            stringPickerView.title = @"请选择学历";
            stringPickerView.plistName = @"testData.plist";
            //stringPickerView.selectIndex = self.educationSelectIndex;
            stringPickerView.selectValue = self.infoModel.educationStr;
            stringPickerView.isAutoSelect = YES;
            stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
                self.educationSelectIndex = resultModel.index;
                self.infoModel.educationStr = resultModel.value;
                textField.text = self.infoModel.educationStr;
            };
            
            // 自定义弹框样式
            BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
            if (@available(iOS 13.0, *)) {
                customStyle.pickerColor = [UIColor secondarySystemBackgroundColor];
            } else {
                customStyle.pickerColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
            }
            customStyle.separatorColor = [UIColor clearColor];
            stringPickerView.pickerStyle = customStyle;
            
            [stringPickerView show];
            
        }
            break;
            
        case 7:
        {
            /// 融资情况
            NSArray *infoArr = @[@{@"key": @"1001", @"value": @"无融资", @"remark": @""},
                                 @{@"key": @"2001", @"value": @"天使轮", @"remark": @""},
                                 @{@"key": @"3001", @"value": @"A轮", @"remark": @""},
                                 @{@"key": @"4001", @"value": @"B轮", @"remark": @""},
                                 @{@"key": @"5001", @"value": @"C轮以后", @"remark": @""},
                                 @{@"key": @"6001", @"value": @"已上市", @"remark": @""}];
            NSMutableArray *modelArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in infoArr) {
                BRResultModel *model = [[BRResultModel alloc]init];
                model.key = dic[@"key"];
                model.value = dic[@"value"];
                model.remark = dic[@"remark"];
                [modelArr addObject:model];
            }
            
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
            stringPickerView.pickerMode = BRStringPickerComponentSingle;
            stringPickerView.title = @"融资情况";
            stringPickerView.dataSourceArr = [modelArr copy];
            stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
                NSLog(@"选择的索引：%@", @(resultModel.index));
                NSLog(@"选择的值：%@", resultModel.value);
                textField.text = resultModel.value;
            };
            
            [stringPickerView show];
            
        }
            break;
            
        case 8:
        {
            /// 多列字符串
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
            stringPickerView.pickerMode = BRStringPickerComponentMulti;
            stringPickerView.title = @"多列选择器";
            stringPickerView.dataSourceArr = @[@[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物"], @[@"优秀", @"良好", @"及格", @"不及格"]];
            stringPickerView.isAutoSelect = YES;
            stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> *resultModelArr) {
                textField.text = [NSString stringWithFormat:@"%@ %@", resultModelArr[0].value, resultModelArr[1].value];
            };
            
            // 使用模板样式2
            stringPickerView.pickerStyle = [BRPickerStyle pickerStyleWithDoneTextColor:[UIColor blueColor]];
            
            [stringPickerView show];
            
        }
            break;
            
        case 9:
        {
            /// 二级联动选择
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
            stringPickerView.pickerMode = BRStringPickerComponentLinkage;
            stringPickerView.title = @"二级联动选择";
            //stringPickerView.dataSourceArr = [self getLinkag2DataSource];
            stringPickerView.dataSourceArr = [self getStagesDataSource];
            stringPickerView.selectIndexs = self.linkage2SelectIndexs;
            stringPickerView.numberOfComponents = 2;
            stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> *resultModelArr) {
                // 1.选择的索引
                NSMutableArray *selectIndexs = [[NSMutableArray alloc]init];
                // 2.选择的值
                NSString *selectValue = @"";
                for (BRResultModel *model in resultModelArr) {
                    [selectIndexs addObject:@(model.index)];
                    selectValue = [NSString stringWithFormat:@"%@ %@", selectValue, model.value];
                }
                if ([selectValue hasPrefix:@" "]) {
                    selectValue = [selectValue substringFromIndex:1];
                }
                self.linkage2SelectIndexs = selectIndexs;
                textField.text = selectValue;
            };
            
            // 设置选择器中间选中行的样式
            BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
            customStyle.selectRowTextFont = [UIFont boldSystemFontOfSize:20.0f];
            customStyle.selectRowTextColor = [UIColor blueColor];
            stringPickerView.pickerStyle = customStyle;
            
            [stringPickerView show];
            
        }
            break;
            
        case 10:
        {
            /// 三级联动选择
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
            stringPickerView.pickerMode = BRStringPickerComponentLinkage;
            stringPickerView.title = @"三级联动选择";
            stringPickerView.dataSourceArr = [self getLinkag3DataSource];
            stringPickerView.selectIndexs = self.linkage3SelectIndexs;
            stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> *resultModelArr) {
                // 1.选择的索引
                NSMutableArray *selectIndexs = [[NSMutableArray alloc]init];
                // 2.选择的值
                NSString *selectValue = @"";
                // 提示：【广东省-东莞市】，【广东省-中山市】 没有对应的区数据，三级联动会自动变成二级联动，使用 for循环遍历 获取选择的值而不直接使用数组下标，可以避免数组越界。如果想始终保持三级联动，在包装数据源时 可以把没有区数据用空字符串补上。
                for (BRResultModel *model in resultModelArr) {
                    [selectIndexs addObject:@(model.index)];
                    selectValue = [NSString stringWithFormat:@"%@ %@", selectValue, model.value];
                }
                if ([selectValue hasPrefix:@" "]) {
                    selectValue = [selectValue substringFromIndex:1];
                }
                self.linkage3SelectIndexs = selectIndexs;
                textField.text = selectValue;
            };
            // 设置选择器中间选中行的样式
            BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
            customStyle.selectRowTextFont = [UIFont boldSystemFontOfSize:20.0f];
            customStyle.selectRowTextColor = [UIColor blueColor];
            stringPickerView.pickerStyle = customStyle;
            
            [stringPickerView show];
            
        }
            break;
            
        case 100:
        {
            NSLog(@"点击了开始时间：%@", self.beginTimeTF.text);
            self.timeType = BRTimeTypeBeginTime;
            self.endTimeTF.textColor = [UIColor br_labelColor];
            self.endTimeLineView.backgroundColor = [UIColor lightGrayColor];
            self.beginTimeTF.textColor = kThemeColor;
            self.beginTimeLineView.backgroundColor = kThemeColor;
            
            NSString *format = @"yyyy-MM-dd";
            if (self.datePickerView.pickerMode == BRDatePickerModeYM) {
                format = @"yyyy-MM";
            } else if (self.datePickerView.pickerMode == BRDatePickerModeYMDH) {
                format = @"yyyy-MM-dd HH";
            }
            
            if (self.beginTimeTF.text.length == 0) {
                self.beginTimeTF.text = [NSDate br_stringFromDate:[NSDate date] dateFormat:format];
            }
            // 设置选择器滚动到指定的日期
            //self.datePickerView.selectValue = self.beginTimeTF.text;
            self.datePickerView.selectDate = self.beginSelectDate;
        }
            break;
            
        case 101:
        {
            NSLog(@"点击了结束时间:%@", self.endTimeTF.text);
            self.timeType = BRTimeTypeEndTime;
            self.beginTimeTF.textColor = [UIColor br_labelColor];
            self.beginTimeLineView.backgroundColor = [UIColor lightGrayColor];
            self.endTimeTF.textColor = kThemeColor;
            self.endTimeLineView.backgroundColor = kThemeColor;
            
            NSString *format = @"yyyy-MM-dd";
            if (self.datePickerView.pickerMode == BRDatePickerModeYM) {
                format = @"yyyy-MM";
            } else if (self.datePickerView.pickerMode == BRDatePickerModeYMDH) {
                format = @"yyyy-MM-dd HH";
            }
            if (self.endTimeTF.text.length == 0) {
                self.endTimeTF.text = [NSDate br_stringFromDate:[NSDate date] dateFormat:format];
            }
            // 设置选择器滚动到指定的日期
            //self.datePickerView.selectValue = self.endTimeTF.text;
            self.datePickerView.selectDate = self.endSelectDate;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 获取二级联动的数据源
- (NSArray <BRResultModel *>*)getLinkag2DataSource {
    // 获取本地数据源
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"linkage2_data.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *responseObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *dataArr = responseObj[@"data"];
    
    NSMutableArray *listModelArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dataArr) {
        BRResultModel *model = [[BRResultModel alloc]init];
        model.parentKey = dic[@"parent_key"];
        model.parentValue = dic[@"parent_value"];
        model.key = dic[@"key"];
        model.value = dic[@"value"];
        [listModelArr addObject:model];
    }
    return [listModelArr copy];
}


#pragma mark - 获取二级联动的数据源
- (NSArray <BRResultModel *>*)getStagesDataSource {
    // 获取本地数据源
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"stages.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *responseObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *dataArr = responseObj[@"GetStageInfoDto"];
    
    NSMutableArray *listModelArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dataArr) {
        BRResultModel *model = [[BRResultModel alloc]init];
        model.parentKey = @"-1";
        model.parentValue = @"";
        model.key = dic[@"StageID"];
        model.value = dic[@"Name"];
        [listModelArr addObject:model];
        
        for (NSDictionary *param in dic[@"GetGradeInfoDto"]) {
            BRResultModel *model1 = [[BRResultModel alloc]init];
            model1.parentKey = param[@"StageID"];
            model1.parentValue = dic[@"Name"];
            model1.key = param[@"GradeID"];
            model1.value = param[@"Name"];
            [listModelArr addObject:model1];
        }
    }
    return [listModelArr copy];
}


#pragma mark - 获取三级联动的数据源
- (NSArray <BRResultModel *>*)getLinkag3DataSource {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"linkage3_data.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *responseObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableArray *allRegionModelArr = [[NSMutableArray alloc]init];
    // 省
    NSArray *provinceArr = responseObj[@"Result"][@"Province"];
    for (NSInteger i = 0; i < provinceArr.count; i++) {
        BRResultModel *model = [[BRResultModel alloc]init];
        model.parentKey = @"-1";
        model.parentValue = @"";
        model.key = [NSString stringWithFormat:@"%@", provinceArr[i][@"ProvinceID"]];
        model.value = provinceArr[i][@"Province"];
        [allRegionModelArr addObject:model];
    }
    // 市
    NSArray *cityArr = responseObj[@"Result"][@"City"];
    for (NSInteger i = 0; i < cityArr.count; i++) {
        BRResultModel *model = [[BRResultModel alloc]init];
        model.parentKey = [NSString stringWithFormat:@"%@", cityArr[i][@"ProvinceID"]];
        model.parentValue = @"";
        model.key = [NSString stringWithFormat:@"%@", cityArr[i][@"CityID"]];
        model.value = cityArr[i][@"City"];
        [allRegionModelArr addObject:model];
    }
    // 区
    NSArray *areaArr = responseObj[@"Result"][@"Area"];
    for (NSInteger i = 0; i < areaArr.count; i++) {
        BRResultModel *model = [[BRResultModel alloc]init];
        model.parentKey = [NSString stringWithFormat:@"%@", areaArr[i][@"CityID"]];;
        model.parentValue = @"";
        model.key = [NSString stringWithFormat:@"%@", areaArr[i][@"AreaID"]];
        model.value = areaArr[i][@"Area"];
        [allRegionModelArr addObject:model];
    }
    
    return [allRegionModelArr copy];
}

#pragma mark - footerView
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400)];
        _footerView.backgroundColor = [UIColor clearColor];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // 1.切换日期选择器的显示模式
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"年月日时", @"年月日", @"年月"]];
        segmentedControl.frame = CGRectMake(40, 50, self.view.bounds.size.width - 80, 36);
        segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        // 设置圆角和边框
        segmentedControl.layer.cornerRadius = 3.0f;
        segmentedControl.layer.masksToBounds = YES;
        segmentedControl.layer.borderWidth = 0.8f;
        segmentedControl.layer.borderColor = kThemeColor.CGColor;
        // 设置背景图片颜色
        [segmentedControl setBackgroundImage:[UIImage br_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [segmentedControl setBackgroundImage:[UIImage br_imageWithColor:kThemeColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        // 设置标题颜色
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:kThemeColor, NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} forState:UIControlStateNormal];
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} forState:UIControlStateSelected];
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl addTarget:self action:@selector(pickerModeSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        [_footerView addSubview:segmentedControl];
        
        
        // 2.开始时间label
        UITextField *beginTimeTF = [self getTextField:CGRectMake(self.view.bounds.size.width / 2 - 120 - 15, 110, 120, 36) placeholder:@"开始时间"];
        beginTimeTF.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        beginTimeTF.tag = 100;
        beginTimeTF.textColor = [UIColor br_labelColor];
        self.beginTimeTF = beginTimeTF;
        [_footerView addSubview:beginTimeTF];
        
        UIView *beginTimeLineView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 120 - 15, 146, 120, 0.8f)];
        beginTimeLineView.backgroundColor = [UIColor lightGrayColor];
        beginTimeLineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        [_footerView addSubview:beginTimeLineView];
        self.beginTimeLineView = beginTimeLineView;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 15, 110, 30, 36)];
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.text = @"至";
        [_footerView addSubview:label];
        
        // 结束时间label
        UITextField *endTimeTF = [self getTextField:CGRectMake(self.view.bounds.size.width / 2 + 15, 110, 120, 36) placeholder:@"结束时间"];
        endTimeTF.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        endTimeTF.tag = 101;
        endTimeTF.textColor = [UIColor br_labelColor];
        self.endTimeTF = endTimeTF;
        [_footerView addSubview:endTimeTF];
        
        UIView *endTimeLineView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2 + 15, 146, 120, 0.8f)];
        endTimeLineView.backgroundColor = [UIColor lightGrayColor];
        endTimeLineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        [_footerView addSubview:endTimeLineView];
        self.endTimeLineView = endTimeLineView;
        
        
        // 3.创建选择器容器视图
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(30, 170, _footerView.frame.size.width - 60, 200)];
        if (@available(iOS 13.0, *)) {
            containerView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        } else {
            containerView.backgroundColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
        }
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_footerView addSubview:containerView];
        
    
        // 4.创建日期选择器
        BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
        datePickerView.pickerMode = BRDatePickerModeYMDH;
        datePickerView.maxDate = [NSDate date];
        datePickerView.isAutoSelect = YES;
        datePickerView.showUnitType = BRShowUnitTypeOnlyCenter;
        datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            if (self.timeType == BRTimeTypeBeginTime) {
                self.beginSelectDate = selectDate;
                self.beginTimeTF.text = selectValue;
            } else if (self.timeType == BRTimeTypeEndTime) {
                self.endSelectDate = selectDate;
                self.endTimeTF.text = selectValue;
            }
        };
        
        // 自定义选择器主题样式
        BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
        customStyle.pickerColor = containerView.backgroundColor;
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
        NSLog(@"年月日时");
        self.datePickerView.pickerMode = BRDatePickerModeYMDH;
    } else if (selecIndex == 1) {
        NSLog(@"年月日");
        self.datePickerView.pickerMode = BRDatePickerModeYMD;
    } else if (selecIndex == 2) {
        NSLog(@"年月");
        self.datePickerView.pickerMode = BRDatePickerModeYM;
    }
    
    // 重置选择的值
    self.datePickerView.selectDate = nil;
    self.beginTimeTF.text = nil;
    self.endTimeTF.text = nil;
    self.beginTimeLineView.backgroundColor = [UIColor lightGrayColor];
    self.endTimeLineView.backgroundColor = [UIColor lightGrayColor];
    self.timeType = BRTimeTypeBeginTime;
}

- (UITextField *)getTextField:(CGRect)frame placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.backgroundColor = [UIColor br_systemBackgroundColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor br_labelColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.placeholder = placeholder;
    textField.delegate = self;
    
    return textField;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"姓名", @"性别", @"出生年月", @"出生时刻", @"联系方式", @"地址", @"学历", @"融资", @"多列选择", @"二级联动选择", @"三级联动选择"];
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

@end
