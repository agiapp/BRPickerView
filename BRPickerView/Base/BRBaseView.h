//
//  BaseView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import <UIKit/UIKit.h>

// 屏幕大小、宽、高
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/// RGB颜色(16进制)
#define RGB_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

// 等比例适配系数
#define kScaleFit ((SCREEN_WIDTH < SCREEN_HEIGHT) ? SCREEN_WIDTH / 375.0f : SCREEN_WIDTH / 667.0f)

#define kPickerHeight 216
#define kTopViewHeight 44

// 状态栏的高度(20 / 44(iPhoneX))
#define STATUSBAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)
#define IS_iPhoneX ((STATUSBAR_HEIGHT == 44) ? YES : NO)
// 顶部安全区域远离高度
#define TOP_MARGIN   (CGFloat)(IS_iPhoneX ? 44 : 0)
// 底部安全区域远离高度
#define BOTTOM_MARGIN (CGFloat)(IS_iPhoneX ? 34 : 0)
// 左右安全区域远离距离
#define LEFTRIGHT_MARGIN (SCREEN_WIDTH == 812 && SCREEN_HEIGHT == 375 ? 44 : 0)

#define kDefaultThemeColor RGB_HEX(0x464646, 1.0)

@interface BRBaseView : UIView
// 背景视图
@property (nonatomic, strong) UIView *backgroundView;
// 弹出视图
@property (nonatomic, strong) UIView *alertView;
// 顶部视图
@property (nonatomic, strong) UIView *topView;
// 左边取消按钮
@property (nonatomic, strong) UIButton *leftBtn;
// 右边确定按钮
@property (nonatomic, strong) UIButton *rightBtn;
// 中间标题
@property (nonatomic, strong) UILabel *titleLabel;
// 分割线视图
@property (nonatomic, strong) UIView *lineView;

/** 初始化子视图 */
- (void)initUI;

/** 点击背景遮罩图层事件 */
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender;

/** 取消按钮的点击事件 */
- (void)clickLeftBtn;

/** 确定按钮的点击事件 */
- (void)clickRightBtn;

/** 自定义主题颜色 */
- (void)setupThemeColor:(UIColor *)themeColor;

@end
