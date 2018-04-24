//
//  BRPickerViewMacro.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2018/4/23.
//  Copyright © 2018年 renb. All rights reserved.
//

#ifndef BRPickerViewMacro_h
#define BRPickerViewMacro_h

// 屏幕大小、宽、高
#ifndef SCREEN_BOUNDS
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#endif
#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#endif
#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#endif

// RGB颜色(16进制)
#define BR_RGB_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

#define BR_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define BR_IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

// 等比例适配系数
#define kScaleFit (BR_IS_IPHONE ? ((SCREEN_WIDTH < SCREEN_HEIGHT) ? SCREEN_WIDTH / 375.0f : SCREEN_WIDTH / 667.0f) : 1.0)

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

#define kDefaultThemeColor BR_RGB_HEX(0x464646, 1.0)

/** 静态库中编写 Category 时的便利宏，用于解决 Category 方法从静态库中加载需要特别设置的问题。*/
#ifndef BRSYNTH_DUMMY_CLASS

#define BRSYNTH_DUMMY_CLASS(_name_) \
@interface BRSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation BRSYNTH_DUMMY_CLASS_ ## _name_ @end

#endif

// 打印错误日志
#define BRErrorLog(...) NSLog(@"reason: %@", [NSString stringWithFormat:__VA_ARGS__])

#endif /* BRPickerViewMacro_h */
