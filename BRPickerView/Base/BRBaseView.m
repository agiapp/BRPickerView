//
//  BaseView.m
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRBaseView.h"

@interface BRBaseView ()
// 蒙层视图
@property (nonatomic, strong) UIView *maskView;
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
    self.frame = self.keyView.bounds;
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
        [BRPickerStyle br_setView:_alertView roundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadius:self.pickerStyle.topCornerRadius];
    }
}

#pragma mark - 蒙层视图
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.keyView.bounds];
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
        CGFloat accessoryViewHeight = 0;
        if (self.pickerHeaderView) {
            accessoryViewHeight += self.pickerHeaderView.bounds.size.height;
        }
        if (self.pickerFooterView) {
            accessoryViewHeight += self.pickerFooterView.bounds.size.height;
        }
        CGFloat height = self.pickerStyle.titleBarHeight + self.pickerStyle.pickerHeight + self.pickerStyle.paddingBottom + accessoryViewHeight;
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, self.keyView.bounds.size.height - height, self.keyView.bounds.size.width, height)];
        _alertView.backgroundColor = self.pickerStyle.alertViewColor ? self.pickerStyle.alertViewColor : self.pickerStyle.pickerColor;
        if (!self.pickerStyle.topCornerRadius && !self.pickerStyle.hiddenShadowLine) {
            // 设置弹框视图顶部边框线
            UIView *shadowLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _alertView.frame.size.width, self.pickerStyle.shadowLineHeight)];
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
        _titleBarView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.keyView.bounds.size.width, self.pickerStyle.titleBarHeight)];
        _titleBarView.backgroundColor = self.pickerStyle.titleBarColor;
        _titleBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if (!self.pickerStyle.hiddenTitleLine) {
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
            _cancelBtn.layer.cornerRadius = self.pickerStyle.cancelCornerRadius > 0 ? self.pickerStyle.cancelCornerRadius : 6.0f;
            _cancelBtn.layer.borderColor = self.pickerStyle.cancelTextColor.CGColor;
            _cancelBtn.layer.borderWidth = self.pickerStyle.cancelBorderWidth > 0 ? self.pickerStyle.cancelBorderWidth : 1.0f;
            _cancelBtn.layer.masksToBounds = YES;
        } else if (self.pickerStyle.cancelBorderStyle == BRBorderStyleFill) {
            _cancelBtn.layer.cornerRadius = self.pickerStyle.cancelCornerRadius > 0 ? self.pickerStyle.cancelCornerRadius : 6.0f;
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
            _doneBtn.layer.cornerRadius = self.pickerStyle.doneCornerRadius > 0 ? self.pickerStyle.doneCornerRadius : 6.0f;
            _doneBtn.layer.borderColor = self.pickerStyle.doneTextColor.CGColor;
            _doneBtn.layer.borderWidth = self.pickerStyle.doneBorderWidth > 0 ? self.pickerStyle.doneBorderWidth : 1.0f;
            _doneBtn.layer.masksToBounds = YES;
        } else if (self.pickerStyle.doneBorderStyle == BRBorderStyleFill) {
            _doneBtn.layer.cornerRadius = self.pickerStyle.doneCornerRadius > 0 ? self.pickerStyle.doneCornerRadius : 6.0f;
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

#pragma mark - 点击蒙层视图事件
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
    [self removePickerFromView:nil];
    if (self.doneBlock) {
        self.doneBlock();
    }
}

#pragma mark - 添加视图方法
- (void)addPickerToView:(UIView *)view {
    if (view) {
        self.frame = view.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        CGFloat accessoryViewHeight = 0;
        if (self.pickerHeaderView) {
            CGRect rect = self.pickerHeaderView.frame;
            self.pickerHeaderView.frame = CGRectMake(0, 0, view.bounds.size.width, rect.size.height);
            self.pickerHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self addSubview:self.pickerHeaderView];
            
            accessoryViewHeight += self.pickerHeaderView.bounds.size.height;
        }
        if (self.pickerFooterView) {
            CGRect rect = self.pickerFooterView.frame;
            self.pickerFooterView.frame = CGRectMake(0, view.bounds.size.height - rect.size.height, view.bounds.size.width, rect.size.height);
            self.pickerFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self addSubview:self.pickerFooterView];
            
            accessoryViewHeight += self.pickerFooterView.bounds.size.height;
        }
        
        [view addSubview:self];
    } else {
        [self initUI];
        
        if (self.pickerHeaderView) {
            CGRect rect = self.pickerHeaderView.frame;
            CGFloat titleBarHeight = self.pickerStyle.hiddenTitleBarView ? 0 : self.pickerStyle.titleBarHeight;
            self.pickerHeaderView.frame = CGRectMake(0, titleBarHeight, self.alertView.bounds.size.width, rect.size.height);
            self.pickerHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self.alertView addSubview:self.pickerHeaderView];
        }
        if (self.pickerFooterView) {
            CGRect rect = self.pickerFooterView.frame;
            self.pickerFooterView.frame = CGRectMake(0, self.alertView.bounds.size.height - self.pickerStyle.paddingBottom - rect.size.height, self.alertView.bounds.size.width, rect.size.height);
            self.pickerFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self.alertView addSubview:self.pickerFooterView];
        }
    
        [self.keyView addSubview:self];
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = self.bounds.size.height;
        self.alertView.frame = rect;
        // 弹出动画
        if (!self.pickerStyle.hiddenMaskView) {
            self.maskView.alpha = 0;
        }
        [UIView animateWithDuration:0.3f animations:^{
            if (!self.pickerStyle.hiddenMaskView) {
                self.maskView.alpha = 1;
            }
            CGFloat alertViewHeight = self.alertView.bounds.size.height;
            CGRect rect = self.alertView.frame;
            rect.origin.y -= alertViewHeight;
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
        [UIView animateWithDuration:0.2f animations:^{
            CGFloat alertViewHeight = self.alertView.bounds.size.height;
            CGRect rect = self.alertView.frame;
            rect.origin.y += alertViewHeight;
            self.alertView.frame = rect;
            if (!self.pickerStyle.hiddenMaskView) {
                self.maskView.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 刷新选择器数据
- (void)reloadData {
    
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

- (BRPickerStyle *)pickerStyle {
    if (!_pickerStyle) {
        _pickerStyle = [[BRPickerStyle alloc]init];
    }
    return _pickerStyle;
}

- (UIView *)keyView {
    if (!_keyView) {
        _keyView = BRGetKeyWindow();
    }
    return _keyView;
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
