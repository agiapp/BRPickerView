//
//  BRInfoModel.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2018/4/16.
//  Copyright © 2018年 91renb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRInfoModel : NSObject
/** 姓名 */
@property (nonatomic, copy) NSString *nameStr;
/** 性别 */
@property (nonatomic, copy) NSString *genderStr;
/** 出生年月 */
@property (nonatomic, copy) NSString *birthdayStr;
/** 出生时刻 */
@property (nonatomic, copy) NSString *birthtimeStr;
/** 联系方式 */
@property (nonatomic, copy) NSString *phoneStr;
/** 地区 */
@property (nonatomic, copy) NSString *addressStr;
/** 学历 */
@property (nonatomic, copy) NSString *educationStr;
/** 其它 */
@property (nonatomic, copy) NSString *otherStr;

@end
