//
//  UIImage+Color.h
//  BRPickerViewDemo
//
//  Created by 筑龙股份 on 2019/12/26.
//  Copyright © 2019 91renb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)
/** 用颜色返回一张图片 */
+ (nullable UIImage *)br_imageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
