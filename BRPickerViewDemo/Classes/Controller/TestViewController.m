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
@property (nonatomic, strong) BRInfoModel *infoModel;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UILabel *titleLabel;

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
        containerView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:containerView];
        
        // 2.创建选择器
        BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]initWithPickerMode:BRAddressPickerModeArea];
        addressPickerView.isAutoSelect = YES;
        addressPickerView.defaultSelectedArr = [self.titleLabel.text componentsSeparatedByString:@" "];
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
/*
            [BRStringPickerView showStringPickerWithTitle:@"请选择性别" dataSource:@[@"男", @"女", @"其他"] defaultSelValue:textField.text resultBlock:^(id selectValue) {
                textField.text = self.infoModel.genderStr = selectValue;
            }];
 */
            /// 使用方式一
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
            stringPickerView.title = @"请选择性别";
            stringPickerView.dataSourceArr = @[@"男", @"女", @"其他"];
            stringPickerView.selectValue = textField.text;
            stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
                textField.text = self.infoModel.genderStr = resultModel.selectValue;
            };
            [stringPickerView show];
            
        }
            break;
        case 2:
        {
/*
            NSDate *minDate = [NSDate br_setYear:1990 month:3 day:12];
            NSDate *maxDate = [NSDate date];
            [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:BRDatePickerModeYMD defaultSelValue:textField.text minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
                textField.text = self.infoModel.birthdayStr = selectValue;
            } cancelBlock:^{
                NSLog(@"点击了背景或取消按钮");
            }];
 */
            /// 使用方式一
            BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeYMD];
            datePickerView.title = @"出生年月日";
            datePickerView.defaultSelValue = textField.text;
            datePickerView.minDate = [NSDate br_setYear:1990 month:3 day:12];
            datePickerView.maxDate = [NSDate date];
            datePickerView.isAutoSelect = YES;
            datePickerView.resultBlock = ^(NSString *selectValue) {
                textField.text = self.infoModel.birthdayStr = selectValue;
            };
            [datePickerView show];
            
        }
            break;
        case 3:
        {
/*
            NSDate *minDate = [NSDate br_setHour:8 minute:10];
            NSDate *maxDate = [NSDate br_setHour:20 minute:35];
            [BRDatePickerView showDatePickerWithTitle:@"出生时刻" dateType:BRDatePickerModeTime defaultSelValue:textField.text minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:[UIColor orangeColor] resultBlock:^(NSString *selectValue) {
                textField.text = self.infoModel.birthtimeStr = selectValue;
            }];
 */
            /// 使用方式一
            BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeHM];
            datePickerView.title = @"出生时刻";
            datePickerView.defaultSelValue = textField.text;
            datePickerView.minDate = [NSDate br_setHour:8 minute:10];
            datePickerView.maxDate = [NSDate br_setHour:20 minute:35];
            datePickerView.isAutoSelect = YES;
            
            // 自定义主题样式
            BRPickerStyle *customStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor orangeColor]];
            customStyle.pickerColor = BR_RGB_HEX(0xd9dbdf, 1.0f);
            customStyle.pickerTextColor = [UIColor redColor];
            customStyle.separatorColor = [UIColor redColor];
            datePickerView.pickerStyle = customStyle;
            
            datePickerView.resultBlock = ^(NSString *selectValue) {
                textField.text = self.infoModel.birthdayStr = selectValue;
            };
            [datePickerView show];
            
        }
            break;
        case 5:
        {
/*
            // 【转换】：以@" "自字符串为基准将字符串分离成数组，如：@"浙江省 杭州市 西湖区" ——》@[@"浙江省", @"杭州市", @"西湖区"]
            NSArray *defaultSelArr = [textField.text componentsSeparatedByString:@" "];
            // NSArray *dataSource = [weakSelf getAddressDataSource];  //从外部传入地区数据源
            NSArray *dataSource = nil; // dataSource 为空时，就默认使用框架内部提供的数据源（即 BRCity.plist）
            [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:dataSource defaultSelected:defaultSelArr isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                textField.text = self.infoModel.addressStr = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
                NSLog(@"省[%@]：%@，%@", @(province.index), province.code, province.name);
                NSLog(@"市[%@]：%@，%@", @(city.index), city.code, city.name);
                NSLog(@"区[%@]：%@，%@", @(area.index), area.code, area.name);
                NSLog(@"--------------------");
            } cancelBlock:^{
                NSLog(@"点击了背景视图或取消按钮");
            }];
*/
            /// 使用方式一
            BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]initWithPickerMode:BRAddressPickerModeArea];
            addressPickerView.title = @"请选择地区";
            addressPickerView.defaultSelectedArr = [textField.text componentsSeparatedByString:@" "];
            addressPickerView.isAutoSelect = YES;
                        
            // 自定义主题样式（适配深色模式）
            addressPickerView.pickerStyle = [BRPickerStyle pickerStyleWithDarkModel];
            
            addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                textField.text = self.infoModel.addressStr = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
            };
            [addressPickerView show];
            
        }
            break;
        case 6:
        {
/*
            // NSArray *dataSource = @[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"];
            NSString *dataSource = @"testData1.plist"; // 可以将数据源（上面的数组）放到plist文件中
            [BRStringPickerView showStringPickerWithTitle:@"学历" dataSource:dataSource defaultSelValue:textField.text isAutoSelect:YES themeColor:nil resultBlock:^(id selectValue) {
                textField.text = self.infoModel.educationStr = selectValue;
            } cancelBlock:^{
                NSLog(@"点击了背景视图或取消按钮");
            }];
 */
            
            /// 使用方式一
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
            stringPickerView.title = @"请选择学历";
            stringPickerView.plistName = @"testData1.plist";
            stringPickerView.selectValue = textField.text;
            stringPickerView.isAutoSelect = YES;
            stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
                textField.text = self.infoModel.educationStr = resultModel.selectValue;
            };
            [stringPickerView show];
            
        }
            break;
        case 7:
        {
/*
            NSArray *dataSource = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
            // NSString *dataSource = @"testData3.plist"; // 可以将数据源（上面的数组）放到plist文件中
            NSArray *defaultSelArr = [textField.text componentsSeparatedByString:@"，"];
            [BRStringPickerView showStringPickerWithTitle:@"自定义多列字符串" dataSource:dataSource defaultSelValue:defaultSelArr isAutoSelect:YES themeColor:BR_RGB_HEX(0xff7998, 1.0f) resultBlock:^(id selectValue) {
                textField.text = self.infoModel.otherStr = [NSString stringWithFormat:@"%@，%@", selectValue[0], selectValue[1]];
            } cancelBlock:^{
                NSLog(@"点击了背景视图或取消按钮");
            }];
*/

            /// 使用方式一
            BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentMulti];
            stringPickerView.title = @"自定义多列字符串";
            stringPickerView.dataSourceArr = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
            stringPickerView.selectValueArr = [textField.text componentsSeparatedByString:@"，"];
            stringPickerView.isAutoSelect = YES;
            stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> *resultModelArr) {
                textField.text = self.infoModel.otherStr = [NSString stringWithFormat:@"%@，%@", resultModelArr[0].selectValue, resultModelArr[1].selectValue];
            };
            
            [stringPickerView show];
            
        }
            break;
            
        default:
            break;
    }
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

@end
