//
//  BRTextModel.m
//  BRPickerViewDemo
//
//  Created by renbo on 2019/10/2.
//  Copyright © 2019 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import "BRTextModel.h"

@implementation BRTextModel

/// 字典 转 模型
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.code = dictionary[@"code"];
        self.text = dictionary[@"text"];
        self.parentCode = dictionary[@"parent_code"];
        NSArray *childrenArray = dictionary[@"children"];
        if (childrenArray) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *childDict in childrenArray) {
                BRTextModel *child = [[BRTextModel alloc] initWithDictionary:childDict];
                [tempArr addObject:child];
            }
            self.children = [tempArr copy];
        }
    }
    return self;
}

/// 判断两个对象是否相等
/// @param object 目标对象
- (BOOL)isEqual:(id)object {
    // 1.对象的地址相同
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[BRTextModel class]]) {
        return NO;
    }
    
    BRTextModel *model = (BRTextModel *)object;
    if (!model) {
        return NO;
    }
    // 2.对象的类型相同，且对象的各个属性相等
    BOOL isSameCode = (!self.code && !model.code) || [self.code isEqualToString:model.code];
    BOOL isSameText = (!self.text && !model.text) || [self.text isEqualToString:model.text];
    
    return isSameCode && isSameText;
}

- (NSUInteger)hash {
    return [self.code hash] ^ [self.text hash];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

// value为nil，key不为nil的时候会调用
- (void)setNilValueForKey:(NSString *)key {
    
}

// 防止使用 valueForKey 获取值，key不存在时奔溃
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end


/// 工具方法
@implementation NSArray (BRPickerView)

/// 数组 转 模型数组
+ (NSArray *)br_modelArrayWithJson:(NSArray *)dataArr mapper:(nullable NSDictionary *)mapper {
    if (!mapper) {
        // 如果属性映射字典为空，就使用下面默认的
        mapper = @{
            @"code": @"code",
            @"text": @"text",
            @"parentCode": @"parent_code",
            @"extras": @"extras",
            @"children": @"children"
        };
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dic in dataArr) {
        BRTextModel *model = [[BRTextModel alloc]init];
        if (mapper[@"code"]) {
            model.code = [NSString stringWithFormat:@"%@", dic[mapper[@"code"]]];
        }
        if (mapper[@"text"]) {
            model.text = dic[mapper[@"text"]];
        }
        if (mapper[@"parentCode"]) {
            model.parentCode = [NSString stringWithFormat:@"%@", dic[mapper[@"parentCode"]]];
        }
        if (mapper[@"extras"]) {
            model.extras = dic[mapper[@"extras"]];
        }
        if (dic[mapper[@"children"]]) {
            model.children = [self br_modelArrayWithJson:dic[mapper[@"children"]] mapper:mapper]; // 递归处理子list
        }
        [tempArr addObject:model];
    }

    return [tempArr copy];
}

/// 获取模型数组元素，指定属性的值组成新数组
- (NSArray *)br_getValueArr:(NSString *)propertyName {
    NSMutableArray *valueArr = [[NSMutableArray alloc]init];
    for (BRTextModel *model in self) {
        id propertyValue = [model valueForKey:propertyName];
        if (propertyValue) {
            [valueArr addObject:propertyValue];
        }
    }
    return [valueArr copy];
}

/// 将模型数组元素，指定属性连接成字符串
- (NSString *)br_joinValue:(NSString *)propertyName separator:(NSString *)separator {
    NSArray *valueArr = [self br_getValueArr:propertyName];
    if (valueArr && valueArr.count > 0) {
        return [valueArr componentsJoinedByString:separator];
    }
    return @"";
}

/// 将模型数组元素的 text 属性，连接成字符串
- (NSString *)br_joinText:(NSString *)separator {
    NSArray *valueArr = [self br_getValueArr:@"text"];
    if (valueArr && valueArr.count > 0) {
        return [valueArr componentsJoinedByString:separator];
    }
    return @"";
}

/// 将扁平结构模型数组 转换成 树状结构模型数组
- (NSArray<BRTextModel *> *)br_buildTreeArray {
    NSMutableArray<BRTextModel *> *treeModels = [NSMutableArray array];
    NSMutableDictionary<NSString *, BRTextModel *> *allItemDic = [NSMutableDictionary dictionary];

    // 将所有模型对象以 code 作为 key 存入字典
    for (BRTextModel *model in self) {
        allItemDic[model.code] = model;
    }
    
    for (BRTextModel *model in self) {
        NSString *parentCode = model.parentCode;
        BRTextModel *parentModel = allItemDic[parentCode];
        if (parentModel) {
            if (!parentModel.children) {
                parentModel.children = [NSArray array];
            }
            parentModel.children = [parentModel.children arrayByAddingObject:model];
        } else {
            // 没有找到对应的父级模型，即该模型为根节点
            [treeModels addObject:model];
        }
    }
    
    return treeModels;
}

@end
