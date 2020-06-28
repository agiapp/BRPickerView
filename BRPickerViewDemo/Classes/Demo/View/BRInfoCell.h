//
//  BRInfoCell.h
//  BRPickerViewDemo
//
//  Created by renbo on 2018/4/16.
//  Copyright © 2018 irenb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRInfoCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL canEdit;

@end
