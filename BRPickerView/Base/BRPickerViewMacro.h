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

// 底部安全区域高度
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


/**
 弱引用/强引用
 
 Example:
     @weakify(self)
     [self doSomething^{
         @strongify(self)
         if (!self) return;
         ...
     }];
 
 */
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
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
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 // 编译时检查SDK版本：Xcode11+编译会调用（iOS SDK 13.0 以后版本的处理）
    if (@available(iOS 13.0, *)) {
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
    } else
#endif
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 130000
        return [UIApplication sharedApplication].keyWindow;
#endif
    }
    
    return keyWindow;
}


#endif /* BRPickerViewMacro_h */
