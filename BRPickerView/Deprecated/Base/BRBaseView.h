//
//  BaseView.h
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import "BRPickerAlertView.h"

@interface BRBaseView : BRPickerAlertView
/** 是否自动选择，即滚动选择器后就执行结果回调，默认为 NO */
@property (nonatomic, assign) BOOL isAutoSelect;

@end
