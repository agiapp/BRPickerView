//
//  BRResultModel.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2019/10/2.
//  Copyright © 2019年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import <Foundation/Foundation.h>

@interface BRResultModel : NSObject
/** 选择的值 */
@property (nonatomic, copy) NSString *selectValue;
/** 选择值对应的索引（行数） */
@property (nonatomic, assign) NSInteger index;

@end
