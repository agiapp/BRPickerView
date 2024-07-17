//
//  BRDataSourceHelper.m
//  BRPickerViewDemo
//
//  Created by renbo on 2024/7/4.
//  Copyright © 2024 irenb. All rights reserved.
//

#import "BRDataSourceHelper.h"

@implementation BRDataSourceHelper

#pragma mark - 获取本地文件（.plist/.json）数据
+ (id)getLocalFileData:(NSString *)fileName {
    // 获取本地数据源
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    if (filePath && filePath.length > 0) {
        if ([fileName hasSuffix:@".plist"]) {
            // 获取本地 plist文件 数据源
            return [[NSArray alloc] initWithContentsOfFile:filePath];
        } else if ([fileName hasSuffix:@".json"]) {
            // 获取本地 JSON文件 数据源
            NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
            return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        }
    }
    return nil;
}


// =====================================================
// ================= 处理高德行政区划数据 =================
// =====================================================
#pragma mark - 获取高德地图行政区划数据源
+ (void)loadAMapRegionData:(NSString *)amapKey completionBlock:(void (^)(NSDictionary *responseObject))completionBlock {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://restapi.amap.com/v3/config/district?key=%@&subdistrict=3", amapKey]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 创建一个默认的NSURLSession配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 使用配置创建NSURLSession
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    // 创建一个数据任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            // 处理错误
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            // 处理数据
            if (data) {
                // 将二进制数据序列化成JSON数据
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                completionBlock ? completionBlock(responseObject): nil;
            }
        }
    }];
    // 开始任务
    [dataTask resume];
}

#pragma mark - 加载高德行政区划省市区模型数组
+ (void)loadAMapRegionModelArr:(void (^)(NSArray *dataArr))completionBlock {
    [self loadAMapRegionData:@"005deb4aeb1f8cfdd28fb5fdd6badf25" completionBlock:^(NSDictionary *responseObject) {
        // 写入数据到文件
        [self writeDataWithJSONObject:responseObject toFileName:@"amap_region_data.json"];
        
        NSString *status = responseObject[@"status"];
        if ([status integerValue] == 1) {
            NSArray *districts = responseObject[@"districts"];
            NSDictionary *countryDic = districts.firstObject;
            districts = countryDic[@"districts"];
            
            // 生成 region_data.json 文件
            [self writeToRegionDataJsonFile];
            // 生成 BRCity.json 文件
            [self writeToBRCityJsonFile];
            
            completionBlock ? completionBlock(districts): nil;
        }
    }];
}

/// 写入数据到文件
+ (void)writeDataWithJSONObject:(id)obj toFileName:(NSString *)fileName {
    // 字典/数组转Json字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    NSString *logString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // 写入文件
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    // 会自动的创建没有的文件；再将内容写入文件中
    [logString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@文件保存路径：%@", fileName, filePath);
    NSLog(@"%@文件写入内容：%@", fileName, logString);
}

#pragma mark - 生成 region_tree_data.json 文件
+ (void)writeToRegionDataJsonFile {
    // 获取本地数据源
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"amap_region_data.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *districts = responseObject[@"districts"];
    NSDictionary *countryDic = districts.firstObject;
    NSArray *dataArr = countryDic[@"districts"];
    
    // 新的数组
    NSArray *textDataArr = [self convertToTextArray:dataArr];
    // 写入数据到文件
    [self writeDataWithJSONObject:textDataArr toFileName:@"region_tree_data.json"];
}

+ (NSArray *)convertToTextArray:(NSArray *)dataArr {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dic in dataArr) {
        NSMutableDictionary *textDic = [[NSMutableDictionary alloc] init];
        if (dic[@"districts"] && [dic[@"districts"] count] > 0) {
            textDic[@"children"] = [self convertToTextArray:dic[@"districts"]]; // 递归处理子list
        } else {
            textDic[@"children"] = @[];
        }
        
        textDic[@"code"] = dic[@"adcode"];
        textDic[@"text"] = dic[@"name"];
        [tempArr addObject:textDic];
    }
    
    // 按code字段对模型数组进行升序排序
    [tempArr sortUsingComparator:^NSComparisonResult(NSDictionary * _Nonnull obj1, NSDictionary * _Nonnull obj2) {
        return [obj1[@"code"] compare:obj2[@"code"]];
    }];
    
    return [tempArr copy];
}

#pragma mark - 生成 region_list_data 文件
+ (void)writeToBRCityJsonFile {
    // 获取本地数据源
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"amap_region_data.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *districts = responseObject[@"districts"];
    NSDictionary *countryDic = districts.firstObject;
    NSArray *dataArr = countryDic[@"districts"];
    
    // 新的数组
    NSArray *textDataArr = [self convertToCityArray:dataArr];
    // 写入数据到文件
    [self writeDataWithJSONObject:textDataArr toFileName:@"region_list_data.json"];
}

+ (NSArray *)convertToCityArray:(NSArray *)dataArr {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dic in dataArr) {
        NSMutableDictionary *textDic = [[NSMutableDictionary alloc] init];
        textDic[@"acode"] = dic[@"adcode"]; // 注意：生成的BRCity.json文件，把 acode 替换为 code （这里用acode是为了方便调整字典key的排序）
        textDic[@"name"] = dic[@"name"];
        if ([dic[@"level"] isEqualToString:@"province"]) {
            textDic[@"cityList"] = [self convertToCityArray:dic[@"districts"]]; // 递归处理子list
        } else if ([dic[@"level"] isEqualToString:@"city"]) {
            textDic[@"areaList"] = [self convertToCityArray:dic[@"districts"]]; // 递归处理子list
        }
        [tempArr addObject:textDic];
    }
    
    // 按code字段对模型数组进行升序排序
    [tempArr sortUsingComparator:^NSComparisonResult(NSDictionary * _Nonnull obj1, NSDictionary * _Nonnull obj2) {
        return [obj1[@"acode"] compare:obj2[@"acode"]];
    }];
    
    return [tempArr copy];
}

@end
