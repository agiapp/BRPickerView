//
//  BRPickerViewMacro.h
//  BRPickerViewDemo
//
//  Created by renbo on 2018/4/23.
//  Copyright © 2018 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#ifndef BRPickerViewMacro_h
#define BRPickerViewMacro_h

#import <UIKit/UIKit.h>

// 屏幕安全区域下边距
#define BR_BOTTOM_MARGIN \
({CGFloat safeBottomHeight = 0;\
if (@available(iOS 11.0, *)) {\
safeBottomHeight = BRGetKeyWindow().safeAreaInsets.bottom;\
}\
(safeBottomHeight);})


// 静态库中编写 Category 时的便利宏，用于解决 Category 方法从静态库中加载需要特别设置的问题
#ifndef BRSYNTH_DUMMY_CLASS

#define BRSYNTH_DUMMY_CLASS(_name_) \
@interface BRSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation BRSYNTH_DUMMY_CLASS_ ## _name_ @end

#endif


// 打印错误日志
#ifdef DEBUG
    #define BRErrorLog(...) NSLog(@"reason: %@", [NSString stringWithFormat:__VA_ARGS__])
#else
    #define BRErrorLog(...)
#endif


/** RGB颜色(16进制) */
static inline UIColor *BR_RGB_HEX(uint32_t rgbValue, CGFloat alpha) {
    return [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0
                            blue:((CGFloat)(rgbValue & 0xFF)) / 255.0
                           alpha:(alpha)];
}


/** 获取 keyWindow */
static inline UIWindow *BRGetKeyWindow(void) {
    UIWindow *keyWindow = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 // 编译时检查SDK版本（兼容不同版本的Xcode，防止编译报错）
    if (@available(iOS 13.0, *)) { // 运行时检查系统版本（兼容不同版本的系统，防止运行报错）
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
    }
#endif
        
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
        if (!keyWindow.isKeyWindow) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 130000
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            if (CGRectEqualToRect(window.bounds, UIScreen.mainScreen.bounds)) {
                keyWindow = window;
            }
#endif
        }
    }
    
    return keyWindow;
}


#endif /* BRPickerViewMacro_h */
