//
//  UIImage+Color.h
//  BRPickerViewDemo
//
//  Created by renbo on 2019/12/26.
//  Copyright © 2019 irenb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)
/** 用颜色返回一张图片 */
+ (nullable UIImage *)br_imageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
