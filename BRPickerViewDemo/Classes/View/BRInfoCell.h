//
//  BRInfoCell.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2018/4/16.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRInfoCell : UITableViewCell
@property (nonatomic, assign) BOOL isNeed;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isNext;

@end
