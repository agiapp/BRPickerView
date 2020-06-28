//
//  UIImage+Color.m
//  BRPickerViewDemo
//
//  Created by renbo on 2019/12/26.
//  Copyright © 2019 irenb. All rights reserved.
//

#import "UIImage+Color.h"


@implementation UIImage (Color)

#pragma mark - 用颜色返回一张图片
+ (UIImage *)br_imageWithColor:(UIColor *)color {
    return [self br_imageWithColor:color size:CGSizeMake(1, 1)];
}

#pragma mark - 用颜色返回一张图片
+ (UIImage *)br_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
