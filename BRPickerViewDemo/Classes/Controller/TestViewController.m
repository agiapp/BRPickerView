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
#import "BRPickerViewMacro.h"

@interface TestViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSArray *titleArr;

@property (nonatomic, strong) BRInfoModel *infoModel;
@property (nonatomic, assign) NSInteger genderSelectIndex;
@property (nonatomic, assign) NSInteger educationSelectIndex;
@property (nonatomic, copy) NSArray <NSNumber *> *addressSelectIndexs;
@property (nonatomic, copy) NSArray <NSNumber *> *otherSelectIndexs;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试选择器的使用";
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
    self.infoModel.otherStr = @"";
}

- (void)initUI {
    self.tableView.hidden = NO;
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
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        _footerView.backgroundColor = [UIColor clearColor];
        // 地区显示label
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, SCREEN_WIDTH - 100, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        if (@available(iOS 13.0, *)) {
            titleLabel.textColor = [UIColor labelColor];
        } else {
            titleLabel.textColor = [UIColor blackColor];
        }
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        [_footerView addSubview:titleLabel];
        
        // 1.创建选择器容器视图
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(30, 80, SCREEN_WIDTH - 60, 200)];
        containerView.backgroundColor = [UIColor redColor];
        [_footerView addSubview:containerView];
        
        // 2.创建选择器
        BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]initWithPickerMode:BRAddressPickerModeCity];
        addressPickerView.isAutoSelect = YES;
        addressPickerView.selectIndexs = @[@10, @0];
        addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
        };
        // 自定义选择器主题样式
        BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
        customStyle.pickerColor = BR_RGB_HEX(0xd9dbdf, 1.0f);
        addressPickerView.pickerStyle = customStyle;
        
        // 3.添加选择器到容器视图
        [addressPickerView addPickerToView:containerView];
        
    }
    return _footerView;
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
            datePickerView.title = @"出生年月日";
            datePickerView.selectValue = textField.text;
            //datePickerView.minDate = [NSDate br_setYear:1990 month:3 day:12];
            datePickerView.maxDate = [NSDate date];
            datePickerView.isAutoSelect = YES;
            datePickerView.resultBlock = ^(NSString *selectValue) {
                textField.text = self.infoModel.birthdayStr = selectValue;
            };
            
            // 自定义弹框样式
            BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
            customStyle.topCornerRadius = 16.0f;
            customStyle.titleLineColor = [UIColor clearColor];
            customStyle.doneTextColor = [UIColor lightGrayColor];
            customStyle.doneTextFont = [UIFont systemFontOfSize:20.0f];
            customStyle.pickerTextFont = [UIFont systemFontOfSize:20.0f];
            customStyle.cancelBtnTitle = @"";
            customStyle.doneBtnTitle = @"      ✕";
            datePickerView.pickerStyle = customStyle;
            
            [datePickerView show];
            
        }
            break;
        case 3:
        {
            // 出生时刻
            BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeHM];
            datePickerView.title = @"出生时刻";
            datePickerView.selectValue = textField.text;
            datePickerView.minDate = [NSDate br_setHour:8 minute:10];
            datePickerView.maxDate = [NSDate br_setHour:20 minute:35];
            datePickerView.isAutoSelect = YES;
            datePickerView.resultBlock = ^(NSString *selectValue) {
                textField.text = self.infoModel.birthdayStr = selectValue;
            };
            
            // 自定义弹框样式
            datePickerView.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor darkGrayColor]];
            
            [datePickerView show];
            
        }
            break;
        case 5:
        {
            // 地区
            BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]initWithPickerMode:BRAddressPickerModeArea];
            addressPickerView.title = @"请选择地区";
            //addressPickerView.defaultSelectedArr = [textField.text componentsSeparatedByString:@" "];
            addressPickerView.selectIndexs = self.addressSelectIndexs;
            addressPickerView.isAutoSelect = YES;
            addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                self.addressSelectIndexs = @[@(province.index), @(city.index), @(area.index)];
                textField.text = self.infoModel.addressStr = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
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
            //stringPickerView.selectValue = textField.text;
            stringPickerView.isAutoSelect = YES;
            stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
                self.educationSelectIndex = resultModel.index;
                self.infoModel.educationStr = resultModel.selectValue;
                textField.text = resultModel.selectValue;
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
            //stringPickerView.selectValueArr = [textField.text componentsSeparatedByString:@"，"];
            stringPickerView.isAutoSelect = YES;
            stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> *resultModelArr) {
                self.otherSelectIndexs = @[@(resultModelArr[0].index), @(resultModelArr[1].index)];
                self.infoModel.otherStr = [NSString stringWithFormat:@"%@，%@", resultModelArr[0].selectValue, resultModelArr[1].selectValue];
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
        customStyle.maskColor = [[UIColor labelColor] colorWithAlphaComponent:0.2];
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
