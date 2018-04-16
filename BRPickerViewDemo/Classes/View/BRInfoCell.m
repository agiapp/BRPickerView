//
//  BRInfoCell.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2018/4/16.
//  Copyright © 2018年 renb. All rights reserved.
//

#import "BRInfoCell.h"

// 屏幕大小、宽、高
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/// RGB颜色(16进制)
#define RGB_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

#define kLeftMargin 20
#define kRowHeight 50

@interface BRInfoCell ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *needLabel;
@property (nonatomic, strong) UIImageView *nextImageView;

@end

@implementation BRInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.needLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.nextImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(kLeftMargin, kRowHeight - 0.5f, SCREEN_WIDTH - 2 * kLeftMargin, 0.5f);
    self.needLabel.frame = CGRectMake(kLeftMargin - 16, 0, 16, kRowHeight);
    self.titleLabel.frame = CGRectMake(kLeftMargin, 0, 100, kRowHeight);
    self.nextImageView.frame = CGRectMake(SCREEN_WIDTH - kLeftMargin - 14, (kRowHeight - 14) / 2, 14, 14);
    self.textField.frame = CGRectMake(self.nextImageView.frame.origin.x - 200, 0, 200, kRowHeight);
    if (self.isNeed) {
        self.needLabel.hidden = NO;
    } else {
        self.needLabel.hidden = YES;
    }
    if (self.isNext) {
        self.nextImageView.hidden = NO;
    } else {
        self.nextImageView.hidden = YES;
    }
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB_HEX(0xE3E3E3, 1.0f);
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = RGB_HEX(0x464646, 1.0);
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)needLabel {
    if (!_needLabel) {
        _needLabel = [[UILabel alloc]init];
        _needLabel.backgroundColor = [UIColor clearColor];
        _needLabel.font = [UIFont systemFontOfSize:16.0f];
        _needLabel.textAlignment = NSTextAlignmentCenter;
        _needLabel.textColor = [UIColor redColor];
        _needLabel.text = @"*";
    }
    return _needLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont systemFontOfSize:16.0f];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = RGB_HEX(0x666666, 1.0);
    }
    return _textField;
}

- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc]init];
        _nextImageView.backgroundColor = [UIColor clearColor];
        _nextImageView.image = [UIImage imageNamed:@"icon_next"];
    }
    return _nextImageView;
}

@end
