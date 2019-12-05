//
//  Test2ViewController.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2019/12/5.
//  Copyright © 2019 91renb. All rights reserved.
//

#import "Test2ViewController.h"
#import "BRPickerViewMacro.h"
#import "BRMutableDatePickerView.h"

@interface Test2ViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSDate *selectDate;
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
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 150, SCREEN_WIDTH - 200, 44)];
        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.text = @"--- 请选择 ---";
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapTitleLabel)];
        [_titleLabel addGestureRecognizer:myTap];
    }
    return _titleLabel;
}

- (void)didTapTitleLabel {
    NSLog(@"点击标题");
    
    BRMutableDatePickerView *datePickerView = [[BRMutableDatePickerView alloc]init];
    //datePickerView.title = @"选择年月日";
    //datePickerView.isAutoSelect = YES;
    datePickerView.selectDate = self.selectDate;
    datePickerView.hiddenDateUnit = YES;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        NSLog(@"选择的时间：%@", selectValue);
        self.titleLabel.text = selectValue;
        self.selectDate = selectDate;
    };
    [datePickerView show];
}

@end
