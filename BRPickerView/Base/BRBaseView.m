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
@property (nonatomic, strong) UIButton *cancelBtn;
// 右边确定按钮
@property (nonatomic, strong) UIButton *doneBtn;
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
    
    if (!self.pickerStyle.hiddenMaskView) {
        [self addSubview:self.maskView];
    }
    
    [self addSubview:self.alertView];
    
    [self.alertView addSubview:self.titleBarView];
    
    if (!self.pickerStyle.hiddenTitleLabel) {
        [self.titleBarView addSubview:self.titleLabel];
    }
    if (!self.pickerStyle.hiddenCancelBtn) {
        [self.titleBarView addSubview:self.cancelBtn];
    }
    if (!self.pickerStyle.hiddenDoneBtn) {
        [self.titleBarView addSubview:self.doneBtn];
    }
    if (!self.pickerStyle.hiddenLineView) {
        [self.titleBarView addSubview:self.lineView];
    }
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
        _alertView = [[UIView alloc]initWithFrame:self.pickerStyle.alertViewFrame];
        _alertView.backgroundColor = self.pickerStyle.alertViewColor;
        if (self.pickerStyle.topCornerRadius > 0) {
            _alertView.layer.cornerRadius = self.pickerStyle.topCornerRadius;
            _alertView.layer.masksToBounds = YES;
        }
        _alertView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _alertView;
}

#pragma mark - 顶部标题栏视图
- (UIView *)titleBarView {
    if (!_titleBarView) {
        _titleBarView =[[UIView alloc]initWithFrame:self.pickerStyle.titleBarFrame];
        _titleBarView.backgroundColor = self.pickerStyle.titleBarColor;
        _titleBarView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _titleBarView;
}

#pragma mark - 左边取消按钮
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = self.pickerStyle.cancelBtnFrame;
        _cancelBtn.backgroundColor = self.pickerStyle.cancelColor;;
        _cancelBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _cancelBtn.titleLabel.font = self.pickerStyle.cancelTextFont;
        [_cancelBtn setTitleColor:self.pickerStyle.cancelTextColor forState:UIControlStateNormal];
        if (self.pickerStyle.cancelBtnImage) {
            [_cancelBtn setImage:self.pickerStyle.cancelBtnImage forState:UIControlStateNormal];
        }
        if (self.pickerStyle.cancelBtnTitle) {
            [_cancelBtn setTitle:self.pickerStyle.cancelBtnTitle forState:UIControlStateNormal];
        }
        [_cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        // 设置按钮圆角或边框
        if (self.pickerStyle.cancelBorderStyle == BRBorderStyleSolid) {
            _cancelBtn.layer.cornerRadius = 6.0f;
            _cancelBtn.layer.borderColor = self.pickerStyle.cancelTextColor.CGColor;
            _cancelBtn.layer.borderWidth = 1.0f;
            _cancelBtn.layer.masksToBounds = YES;
        } else if (self.pickerStyle.cancelBorderStyle == BRBorderStyleFill) {
            _cancelBtn.layer.cornerRadius = 6.0f;
            _cancelBtn.layer.masksToBounds = YES;
        }
    }
    return _cancelBtn;
}

#pragma mark - 右边确定按钮
- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.frame = self.pickerStyle.doneBtnFrame;
        _doneBtn.backgroundColor = self.pickerStyle.doneColor;
        _doneBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        _doneBtn.titleLabel.font = self.pickerStyle.doneTextFont;
        [_doneBtn setTitleColor:self.pickerStyle.doneTextColor forState:UIControlStateNormal];
        if (self.pickerStyle.doneBtnImage) {
            [_doneBtn setImage:self.pickerStyle.doneBtnImage forState:UIControlStateNormal];
        }
        if (self.pickerStyle.doneBtnTitle) {
            [_doneBtn setTitle:self.pickerStyle.doneBtnTitle forState:UIControlStateNormal];
        }
        [_doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
        // 设置按钮圆角或边框
        if (self.pickerStyle.doneBorderStyle == BRBorderStyleSolid) {
            _doneBtn.layer.cornerRadius = 6.0f;
            _doneBtn.layer.borderColor = self.pickerStyle.doneTextColor.CGColor;
            _doneBtn.layer.borderWidth = 1.0f;
            _doneBtn.layer.masksToBounds = YES;
        } else if (self.pickerStyle.doneBorderStyle == BRBorderStyleFill) {
            _doneBtn.layer.cornerRadius = 6.0f;
            _doneBtn.layer.masksToBounds = YES;
        }
    }
    return _doneBtn;
}

#pragma mark - 中间标题label
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.pickerStyle.titleLabelFrame];
        _titleLabel.backgroundColor = self.pickerStyle.titleLabelColor;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = self.pickerStyle.titleTextFont;
        _titleLabel.textColor = self.pickerStyle.titleTextColor;
        _titleLabel.text = self.title;
    }
    return _titleLabel;
}

#pragma mark - 分割线
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleBarView.frame.size.height - 0.5, self.titleBarView.frame.size.width, 0.5)];
        _lineView.backgroundColor = self.pickerStyle.titleLineColor;
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _lineView;
}

#pragma mark - 点击背景遮罩图层事件
- (void)didTapMaskView:(UITapGestureRecognizer *)sender {
    [self removePickerFromView:nil];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 取消按钮的点击事件
- (void)clickCancelBtn {
    [self removePickerFromView:nil];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 确定按钮的点击事件
- (void)clickDoneBtn {
    if (self.doneBlock) {
        self.doneBlock();
    }
}

#pragma mark - 添加视图方法
- (void)addPickerToView:(UIView *)view {
    if (view) {
        self.frame = view.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view addSubview:self];
    } else {
        [self initUI];
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        [keyWindow addSubview:self];
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        // 弹出动画
        if (!self.pickerStyle.hiddenMaskView) {
            self.maskView.alpha = 1;
        }
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kPickerHeight + kTitleBarHeight + BR_BOTTOM_MARGIN;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 移除视图方法
- (void)removePickerFromView:(UIView *)view {
    if (view) {
        [self removeFromSuperview];
    } else {
        // 关闭动画
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y += kPickerHeight + kTitleBarHeight + BR_BOTTOM_MARGIN;
            self.alertView.frame = rect;
            if (!self.pickerStyle.hiddenMaskView) {
                self.maskView.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 添加子视图到选择器上
- (void)addSubViewToPicker:(UIView *)subView {
    
}

- (void)setPickerView:(UIView *)pickerView toView:(UIView *)view {
    if (view) {
        self.frame = view.bounds;
        pickerView.frame = view.bounds;
        [self addSubview:pickerView];
    } else {
        [self.alertView addSubview:pickerView];
    }
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
