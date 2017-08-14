//
//  TestViewController.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "TestViewController.h"
#import "BRPickerView.h"
#import "BRTextField.h"
#import "NSDate+BRAdd.h"

@interface TestViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 姓名 */
@property (nonatomic, strong) BRTextField *nameTF;
/** 性别 */
@property (nonatomic, strong) BRTextField *genderTF;
/** 出生年月 */
@property (nonatomic, strong) BRTextField *birthdayTF;
/** 出生时刻 */
@property (nonatomic, strong) BRTextField *birthtimeTF;
/** 联系方式 */
@property (nonatomic, strong) BRTextField *phoneTF;
/** 地区 */
@property (nonatomic, strong) BRTextField *addressTF;
/** 学历 */
@property (nonatomic, strong) BRTextField *educationTF;
/** 其它 */
@property (nonatomic, strong) BRTextField *otherTF;

@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试选择器的使用";
    self.tableView.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveBtn)];
}

- (void)clickSaveBtn {
    NSLog(@"保存");
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc]init];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = RGB_HEX(0x464646, 1.0f);
    NSString *title = [self.titleArr objectAtIndex:indexPath.row];
    if ([title hasPrefix:@"* "]) {
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:title];
        [textStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[[textStr string]rangeOfString:@"* "]];
        cell.textLabel.attributedText = textStr;
    } else {
        cell.textLabel.text = [self.titleArr objectAtIndex:indexPath.row];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self setupNameTF:cell];
        }
            break;
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self setupGenderTF:cell];
        }
            break;
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self setupBirthdayTF:cell];
        }
            break;
        case 3:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self setupBirthtimeTF:cell];
        }
            break;
        case 4:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self setupPhoneTF:cell];
        }
            break;
        case 5:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self setupAddressTF:cell];
        }
            break;
        case 6:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self setupEducationTF:cell];
        }
            break;
        case 7:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self setupOtherTF:cell];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (BRTextField *)getTextField:(UITableViewCell *)cell {
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 230, 0, 200, 50)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = RGB_HEX(0x666666, 1.0);
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
}

#pragma mark - 姓名 textField
- (void)setupNameTF:(UITableViewCell *)cell {
    if (!_nameTF) {
        _nameTF = [self getTextField:cell];
        _nameTF.placeholder = @"请输入";
        _nameTF.returnKeyType = UIReturnKeyDone;
        _nameTF.tag = 0;
    }
}

#pragma mark - 性别 textField
- (void)setupGenderTF:(UITableViewCell *)cell {
    if (!_genderTF) {
        _genderTF = [self getTextField:cell];
        _genderTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _genderTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"宝宝性别" dataSource:@[@"男", @"女", @"其他"] defaultSelValue:@"男" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.genderTF.text = selectValue;
            }];
        };
    }
}

#pragma mark - 出生日期 textField
- (void)setupBirthdayTF:(UITableViewCell *)cell {
    if (!_birthdayTF) {
        _birthdayTF = [self getTextField:cell];
        _birthdayTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _birthdayTF.tapAcitonBlock = ^{
            [BRDatePickerView showDatePickerWithTitle:@"出生年月" dateType:UIDatePickerModeDate defaultSelValue:weakSelf.birthdayTF.text minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                weakSelf.birthdayTF.text = selectValue;
            }];
        };
    }
}

#pragma mark - 出生时刻 textField
- (void)setupBirthtimeTF:(UITableViewCell *)cell {
    if (!_birthtimeTF) {
        _birthtimeTF = [self getTextField:cell];
        _birthtimeTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _birthtimeTF.tapAcitonBlock = ^{
            [BRDatePickerView showDatePickerWithTitle:@"出生时刻" dateType:UIDatePickerModeTime defaultSelValue:weakSelf.birthtimeTF.text minDateStr:@"" maxDateStr:@"" isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                weakSelf.birthtimeTF.text = selectValue;
            }];
        };
    }
}

#pragma mark - 联系方式 textField
- (void)setupPhoneTF:(UITableViewCell *)cell {
    if (!_phoneTF) {
        _phoneTF = [self getTextField:cell];
        _phoneTF.placeholder = @"请输入";
        _phoneTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _phoneTF.returnKeyType = UIReturnKeyDone;
        _phoneTF.tag = 4;
    }
}

#pragma mark - 地址 textField
- (void)setupAddressTF:(UITableViewCell *)cell {
    if (!_addressTF) {
        _addressTF = [self getTextField:cell];
        _addressTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _addressTF.tapAcitonBlock = ^{
            [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@10, @0, @3] isAutoSelect:YES resultBlock:^(NSArray *selectAddressArr) {
                weakSelf.addressTF.text = [NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1], selectAddressArr[2]];
            }];
        };
    }
}

#pragma mark - 学历 textField
- (void)setupEducationTF:(UITableViewCell *)cell {
    if (!_educationTF) {
        _educationTF = [self getTextField:cell];
        _educationTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _educationTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"学历" dataSource:@[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"] defaultSelValue:@"本科" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.educationTF.text = selectValue;
            }];
        };
    }
}

#pragma mark - 其它 textField
- (void)setupOtherTF:(UITableViewCell *)cell {
    if (!_otherTF) {
        _otherTF = [self getTextField:cell];
        _otherTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _otherTF.tapAcitonBlock = ^{
            NSArray *dataSources = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
            [BRStringPickerView showStringPickerWithTitle:@"自定义多列字符串" dataSource:dataSources defaultSelValue:@[@"第3周", @"第3天"] isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.otherTF.text = [NSString stringWithFormat:@"%@，%@", selectValue[0], selectValue[1]];
            }];
        };
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 4) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"* 姓名", @"* 性别", @"* 出生年月", @"   出生时刻", @"* 联系方式", @"* 地址", @"   学历", @"   其它"];
    }
    return _titleArr;
}

@end
