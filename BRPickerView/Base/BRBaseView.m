//
//  BaseView.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRBaseView.h"

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

// 取消按钮离屏幕边缘的距离
@property (nonatomic, assign) CGFloat cancelBtnMargin;
// 确定按钮离屏幕边缘的距离
@property (nonatomic, assign) CGFloat doneBtnMargin;

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
    
    // 是否隐藏标题栏
    if (!self.pickerStyle.hiddenTitleBarView) {
        [self.alertView addSubview:self.titleBarView];
        [self.alertView sendSubviewToBack:self.titleBarView];

        if (!self.pickerStyle.hiddenTitleLabel) {
            [self.titleBarView addSubview:self.titleLabel];
        }
        if (!self.pickerStyle.hiddenCancelBtn) {
            [self.titleBarView addSubview:self.cancelBtn];
            // 获取边距
            if (self.pickerStyle.cancelBtnFrame.origin.x < self.bounds.size.width / 2) {
                self.cancelBtnMargin = self.pickerStyle.cancelBtnFrame.origin.x;
            } else {
                self.cancelBtnMargin = self.bounds.size.width - self.pickerStyle.cancelBtnFrame.origin.x - self.pickerStyle.cancelBtnFrame.size.width;
            }
        }
        if (!self.pickerStyle.hiddenDoneBtn) {
            [self.titleBarView addSubview:self.doneBtn];
            // 获取边距
            if (self.pickerStyle.doneBtnFrame.origin.x < self.bounds.size.width / 2) {
                self.doneBtnMargin = self.pickerStyle.doneBtnFrame.origin.x;
            } else {
                self.doneBtnMargin = self.bounds.size.width - self.pickerStyle.doneBtnFrame.origin.x - self.pickerStyle.doneBtnFrame.size.width;
            }
        }
    }
}

#pragma mark - 适配横屏安全区域，更新子视图布局
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_cancelBtn || _doneBtn) {
        if (@available(iOS 11.0, *)) {
            UIEdgeInsets safeInsets = self.safeAreaInsets;
            if (_cancelBtn) {
                CGRect cancelBtnFrame = self.pickerStyle.cancelBtnFrame;
                if (cancelBtnFrame.origin.x < MIN(self.bounds.size.width / 2, self.bounds.size.height / 2)) {
                    cancelBtnFrame.origin.x += safeInsets.left;
                } else {
                    cancelBtnFrame.origin.x = self.bounds.size.width - cancelBtnFrame.size.width - safeInsets.right - self.cancelBtnMargin;
                }
                self.cancelBtn.frame = cancelBtnFrame;
            }
            if (_doneBtn) {
                CGRect doneBtnFrame = self.pickerStyle.doneBtnFrame;
                if (doneBtnFrame.origin.x < MIN(self.bounds.size.width / 2, self.bounds.size.height / 2)) {
                    doneBtnFrame.origin.x += safeInsets.left;
                } else {
                    doneBtnFrame.origin.x = self.bounds.size.width - doneBtnFrame.size.width - safeInsets.right - self.doneBtnMargin;
                }
                self.doneBtn.frame = doneBtnFrame;
            }
        }
    }
    
    if (_alertView && self.pickerStyle.topCornerRadius > 0) {
        // 设置顶部圆角
        [self br_setView:_alertView roundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadius:self.pickerStyle.topCornerRadius];
    }
}

#pragma mark - 背景遮罩视图
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

#pragma mark - 弹框视图
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - self.pickerStyle.titleBarHeight - self.pickerStyle.pickerHeight - BR_BOTTOM_MARGIN, SCREEN_WIDTH, self.pickerStyle.titleBarHeight + self.pickerStyle.pickerHeight + BR_BOTTOM_MARGIN)];
        _alertView.backgroundColor = self.pickerStyle.alertViewColor;
        if (!self.pickerStyle.topCornerRadius && !self.pickerStyle.hiddenShadowLine) {
            // 设置弹框视图顶部边框线
            UIView *shadowLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _alertView.frame.size.width, 1.0f)];
            shadowLineView.backgroundColor = self.pickerStyle.shadowLineColor;
            shadowLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [_alertView addSubview:shadowLineView];
        }
        _alertView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _alertView;
}

#pragma mark - 标题栏视图
- (UIView *)titleBarView {
    if (!_titleBarView) {
        _titleBarView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.pickerStyle.titleBarHeight)];
        _titleBarView.backgroundColor = self.pickerStyle.titleBarColor;
        _titleBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if (!self.pickerStyle.hiddenTitleBottomBorder) {
            // 设置标题栏底部分割线
            UIView *titleLineView = [[UIView alloc]initWithFrame:CGRectMake(0, _titleBarView.frame.size.height - 0.5f, _titleBarView.frame.size.width, 0.5f)];
            titleLineView.backgroundColor = self.pickerStyle.titleLineColor;
            titleLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [_titleBarView addSubview:titleLineView];
        }
    }
    return _titleBarView;
}

#pragma mark - 取消按钮
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = self.pickerStyle.cancelBtnFrame;
        _cancelBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        _cancelBtn.backgroundColor = self.pickerStyle.cancelColor;;
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

#pragma mark - 确定按钮
- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.frame = self.pickerStyle.doneBtnFrame;
        _doneBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        _doneBtn.backgroundColor = self.pickerStyle.doneColor;
        if (self.pickerStyle.doneBtnImage) {
            [_doneBtn setImage:self.pickerStyle.doneBtnImage forState:UIControlStateNormal];
        }
        if (self.pickerStyle.doneBtnTitle) {
            _doneBtn.titleLabel.font = self.pickerStyle.doneTextFont;
            [_doneBtn setTitleColor:self.pickerStyle.doneTextColor forState:UIControlStateNormal];
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
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = self.pickerStyle.titleTextFont;
        _titleLabel.textColor = self.pickerStyle.titleTextColor;
        _titleLabel.text = self.title;
    }
    return _titleLabel;
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
        self.alpha = 0;
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
            self.alpha = 1;
            CGRect rect = self.alertView.frame;
            rect.origin.y -= self.pickerStyle.pickerHeight + self.pickerStyle.titleBarHeight + BR_BOTTOM_MARGIN;
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
            rect.origin.y += self.pickerStyle.pickerHeight + self.pickerStyle.titleBarHeight + BR_BOTTOM_MARGIN;
            self.alertView.frame = rect;
            if (!self.pickerStyle.hiddenMaskView) {
                self.maskView.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 添加自定义视图到选择器（picker）上
- (void)addSubViewToPicker:(UIView *)customView {
    
}

#pragma mark - 添加自定义视图到标题栏（titleBar）上
- (void)addSubViewToTitleBar:(UIView *)customView {
    if (!self.pickerStyle.hiddenTitleBarView) {
        [self.titleBarView addSubview:customView];
    }
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

#pragma mark - 设置 view 的部分圆角
// corners(枚举类型，可组合使用)：UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
- (void)br_setView:(UIView *)view roundingCorners:(UIRectCorner)corners withRadius:(CGFloat)radius {
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *shape = [[CAShapeLayer alloc]init];
    [shape setPath:rounded.CGPath];
    view.layer.mask = shape;
}

#pragma mark - setter 方法（支持动态设置标题）
- (void)setTitle:(NSString *)title {
    _title = title;
    if (_titleLabel) {
        _titleLabel.text = title;
    }
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
