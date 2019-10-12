//
//  BaseView.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRBaseView.h"
#import "BRPickerViewMacro.h"

@interface BRBaseView ()
// 遮罩背景视图
@property (nonatomic, strong) UIView *maskView;
// 弹出背景视图
@property (nonatomic, strong) UIView *alertView;
// 标题栏背景视图
@property (nonatomic, strong) UIView *titleBarView;
// 左边取消按钮
@property (nonatomic, strong) UIButton *leftBtn;
// 右边确定按钮
@property (nonatomic, strong) UIButton *rightBtn;
// 中间标题
@property (nonatomic, strong) UILabel *titleLabel;
// 标题栏下边框分割线
@property (nonatomic, strong) UIView *lineView;

@end

@implementation BRBaseView

- (void)initUI {
    self.frame = SCREEN_BOUNDS;
    // 设置子视图的宽度随着父视图变化
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:self.maskView];
    [self addSubview:self.alertView];
    
    [self.alertView addSubview:self.titleBarView];
    
    [self.titleBarView addSubview:self.leftBtn];
    [self.titleBarView addSubview:self.titleLabel];
    [self.titleBarView addSubview:self.rightBtn];
    [self.titleBarView addSubview:self.lineView];
}

#pragma mark - 背景遮罩图层
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:SCREEN_BOUNDS];
        _maskView.backgroundColor = self.pickerStyle.maskColor;
        // 设置子视图的大小随着父视图变化
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapMaskView:)];
        [_maskView addGestureRecognizer:myTap];
    }
    return _maskView;
}

#pragma mark - 弹出视图
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kTitleBarHeight - kPickerHeight - BR_BOTTOM_MARGIN, SCREEN_WIDTH, kTitleBarHeight + kPickerHeight + BR_BOTTOM_MARGIN)];
        _alertView.backgroundColor = self.pickerStyle.pickerColor;
        _alertView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _alertView;
}

#pragma mark - 顶部标题栏视图
- (UIView *)titleBarView {
    if (!_titleBarView) {
        _titleBarView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.alertView.frame.size.width, kTitleBarHeight + 0.5)];
        _titleBarView.backgroundColor = self.pickerStyle.titleBarColor;
        _titleBarView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _titleBarView;
}

#pragma mark - 左边取消按钮
- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(5, 8, 60, 28);
        _leftBtn.backgroundColor = self.pickerStyle.leftColor;;
        _leftBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_leftBtn setTitleColor:self.pickerStyle.leftTextColor forState:UIControlStateNormal];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
        // 设置按钮圆角或边框
        if (self.pickerStyle.leftBorderStyle == BRBorderStyleSolid) {
            _leftBtn.layer.cornerRadius = 6.0f;
            _leftBtn.layer.borderColor = self.pickerStyle.leftTextColor.CGColor;
            _leftBtn.layer.borderWidth = 1.0f;
            _leftBtn.layer.masksToBounds = YES;
        } else if (self.pickerStyle.leftBorderStyle == BRBorderStyleFill) {
            _leftBtn.layer.cornerRadius = 6.0f;
            _leftBtn.layer.masksToBounds = YES;
        }
    }
    return _leftBtn;
}

#pragma mark - 右边确定按钮
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(self.alertView.frame.size.width - 65, 8, 60, 28);
        _rightBtn.backgroundColor = self.pickerStyle.rightColor;
        _rightBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_rightBtn setTitleColor:self.pickerStyle.rightTextColor forState:UIControlStateNormal];
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
        // 设置按钮圆角或边框
        if (self.pickerStyle.rightBorderStyle == BRBorderStyleSolid) {
            _rightBtn.layer.cornerRadius = 6.0f;
            _rightBtn.layer.borderColor = self.pickerStyle.rightTextColor.CGColor;
            _rightBtn.layer.borderWidth = 1.0f;
            _rightBtn.layer.masksToBounds = YES;
        } else if (self.pickerStyle.rightBorderStyle == BRBorderStyleFill) {
            _rightBtn.layer.cornerRadius = 6.0f;
            _rightBtn.layer.masksToBounds = YES;
        }
    }
    return _rightBtn;
}

#pragma mark - 中间标题按钮
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 + 60 + 2, 0, SCREEN_WIDTH - 2 * (5 + 60 + 2), kTitleBarHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _titleLabel.textColor = [self.pickerStyle.titleTextColor colorWithAlphaComponent:0.8f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark - 分割线
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kTitleBarHeight, self.alertView.frame.size.width, 0.5)];
        _lineView.backgroundColor = self.pickerStyle.titleLineColor;
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [self.alertView addSubview:_lineView];
    }
    return _lineView;
}

#pragma mark - setter方法
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma mark - 点击背景遮罩图层事件
- (void)didTapMaskView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:YES toView:nil];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES toView:nil];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    if (self.doneBlock) {
        self.doneBlock();
    }
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation toView:(UIView *)view {
    [self initUI];
    if (view) {
        self.maskView.hidden = YES;
        self.titleBarView.hidden = YES;
        self.frame = view.bounds;
        self.alertView.frame = view.bounds;
        [view addSubview:self];
    } else {
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        [keyWindow addSubview:self];
        if (animation) {
            // 动画前初始位置
            CGRect rect = self.alertView.frame;
            rect.origin.y = SCREEN_HEIGHT;
            self.alertView.frame = rect;
            // 浮现动画
            [UIView animateWithDuration:0.3 animations:^{
                CGRect rect = self.alertView.frame;
                rect.origin.y -= kPickerHeight + kTitleBarHeight + BR_BOTTOM_MARGIN;
                self.alertView.frame = rect;
            }];
        }
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation toView:(UIView *)view {
    if (view) {
        [self removeFromSuperview];
    } else {
        if (animation) {
            // 关闭动画
            [UIView animateWithDuration:0.2 animations:^{
                CGRect rect = self.alertView.frame;
                rect.origin.y += kPickerHeight + kTitleBarHeight + BR_BOTTOM_MARGIN;
                self.alertView.frame = rect;
                self.maskView.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        } else {
            [self removeFromSuperview];
        }
    }
}

- (void)setPickerView:(UIView *)pickerView toView:(UIView *)view {
    if (view) {
        self.frame = view.bounds;
        self.alertView.frame = view.bounds;
        pickerView.frame = view.bounds;
    }
    [self.alertView addSubview:pickerView];
}

- (BRPickerStyle *)pickerStyle {
    if (!_pickerStyle) {
        _pickerStyle = [[BRPickerStyle alloc]init];
    }
    return _pickerStyle;
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
