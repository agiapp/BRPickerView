//
//  Test2ViewController.m
//  BRPickerViewDemo
//
//  Created by renbo on 2019/12/5.
//  Copyright © 2019 irenb. All rights reserved.
//

#import "Test2ViewController.h"
#import "BRPickerViewMacro.h"
#import "BRMutableDatePickerView.h"

@interface Test2ViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSDate *selectDate;
/** 是否隐藏【月】，默认为 NO */
@property (nonatomic, assign) BOOL hiddenMonth;
/** 是否隐藏【日】，默认为 NO */
@property (nonatomic, assign) BOOL hiddenDay;

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"可变日期选择器";
    [self.view addSubview:self.titleLabel];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, self.view.bounds.size.width - 40, 44)];
        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.text = @"--- 请选择日期 ---";
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapTitleLabel)];
        [_titleLabel addGestureRecognizer:myTap];
    }
    return _titleLabel;
}

- (void)didTapTitleLabel {
    NSLog(@"点击标题");
    
    BRMutableDatePickerView *datePickerView = [[BRMutableDatePickerView alloc]init];
    datePickerView.selectDate = self.selectDate;
    datePickerView.hiddenDateUnit = YES;
    datePickerView.hiddenMonth = self.hiddenMonth;
    datePickerView.hiddenDay = self.hiddenDay;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue, BOOL hiddenMonth, BOOL hiddenDay) {
        NSLog(@"选择的时间：%@", selectValue);
        self.titleLabel.text = selectValue;
        self.selectDate = selectDate;
        self.hiddenMonth = hiddenMonth;
        self.hiddenDay = hiddenDay;
    };
    [datePickerView show];
}

@end
