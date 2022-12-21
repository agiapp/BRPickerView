//
//  BRAddressPickerView.m
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRAddressPickerView.h"
#import "NSBundle+BRPickerView.h"

@interface BRAddressPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
// 地址选择器
@property (nonatomic, strong) UIPickerView *pickerView;
// 省模型数组
@property(nonatomic, copy) NSArray *provinceModelArr;
// 市模型数组
@property(nonatomic, copy) NSArray *cityModelArr;
// 区模型数组
@property(nonatomic, copy) NSArray *areaModelArr;
// 选中的省
@property(nonatomic, strong) BRProvinceModel *selectProvinceModel;
// 选中的市
@property(nonatomic, strong) BRCityModel *selectCityModel;
// 选中的区
@property(nonatomic, strong) BRAreaModel *selectAreaModel;
// 记录省选中的位置
@property(nonatomic, assign) NSInteger provinceIndex;
// 记录市选中的位置
@property(nonatomic, assign) NSInteger cityIndex;
// 记录区选中的位置
@property(nonatomic, assign) NSInteger areaIndex;

@property (nonatomic, copy) NSArray <NSString *>* mSelectValues;

@end

@implementation BRAddressPickerView

#pragma mark - 1.显示地址选择器
+ (void)showAddressPickerWithSelectIndexs:(NSArray <NSNumber *>*)selectIndexs
                              resultBlock:(BRAddressResultBlock)resultBlock {
    [self showAddressPickerWithMode:BRAddressPickerModeArea dataSource:nil selectIndexs:selectIndexs isAutoSelect:NO resultBlock:resultBlock];
}

#pragma mark - 2.显示地址选择器
+ (void)showAddressPickerWithMode:(BRAddressPickerMode)mode
                     selectIndexs:(NSArray <NSNumber *>*)selectIndexs
                     isAutoSelect:(BOOL)isAutoSelect
                      resultBlock:(BRAddressResultBlock)resultBlock {
    [self showAddressPickerWithMode:mode dataSource:nil selectIndexs:selectIndexs isAutoSelect:isAutoSelect resultBlock:resultBlock];
}


#pragma mark - 3.显示地址选择器
+ (void)showAddressPickerWithMode:(BRAddressPickerMode)mode
                       dataSource:(NSArray *)dataSource
                     selectIndexs:(NSArray <NSNumber *>*)selectIndexs
                     isAutoSelect:(BOOL)isAutoSelect
                      resultBlock:(BRAddressResultBlock)resultBlock {
    // 创建地址选择器
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc] initWithPickerMode:mode];
    addressPickerView.dataSourceArr = dataSource;
    addressPickerView.selectIndexs = selectIndexs;
    addressPickerView.isAutoSelect = isAutoSelect;
    addressPickerView.resultBlock = resultBlock;
    // 显示
    [addressPickerView show];
}

#pragma mark - 初始化地址选择器
- (instancetype)initWithPickerMode:(BRAddressPickerMode)pickerMode {
    if (self = [super init]) {
        self.pickerMode = pickerMode;
    }
    return self;
}

#pragma mark - 处理选择器数据
- (void)handlerPickerData {
    if (self.dataSourceArr && self.dataSourceArr.count > 0) {
        id item = [self.dataSourceArr firstObject];
        // 如果传的值是解析好的模型数组
        if ([item isKindOfClass:[BRProvinceModel class]]) {
            self.provinceModelArr = self.dataSourceArr;
        } else {
            self.provinceModelArr = [self getProvinceModelArr:self.dataSourceArr];
        }
    } else {
        // 如果外部没有传入地区数据源，就使用本地的数据源
        NSArray *dataSource = [self br_addressJsonArray];
        
        if (!dataSource || dataSource.count == 0) {
            return;
        }
        self.dataSourceArr = dataSource;
        self.provinceModelArr = [self getProvinceModelArr:self.dataSourceArr];
    }
    
    // 设置默认值
    [self handlerDefaultSelectValue];
}

#pragma mark - 获取城市JSON数据
- (NSArray *)br_addressJsonArray {
    static NSArray *cityArray = nil;
    if (!cityArray) {
        // 获取 BRAddressPickerView.bundle
        NSBundle *containnerBundle = [NSBundle bundleForClass:[BRAddressPickerView class]];
        NSString *bundlePath = [containnerBundle pathForResource:@"BRAddressPickerView" ofType:@"bundle"];
        NSBundle *addressPickerBundle = [NSBundle bundleWithPath:bundlePath];
        
        // 获取bundle中的JSON文件
        NSString *filePath = [addressPickerBundle pathForResource:@"BRCity" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        cityArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }
    return cityArray;
}

#pragma mark - 获取模型数组
- (NSArray <BRProvinceModel *>*)getProvinceModelArr:(NSArray *)dataSourceArr {
    NSMutableArray *tempArr1 = [NSMutableArray array];
    for (NSDictionary *proviceDic in dataSourceArr) {
        BRProvinceModel *proviceModel = [[BRProvinceModel alloc]init];
        proviceModel.code = [proviceDic objectForKey:@"code"];
        proviceModel.name = [proviceDic objectForKey:@"name"];
        proviceModel.index = [dataSourceArr indexOfObject:proviceDic];
        NSArray *cityList = [proviceDic.allKeys containsObject:@"cityList"] ? [proviceDic objectForKey:@"cityList"] : [proviceDic objectForKey:@"citylist"];
        NSMutableArray *tempArr2 = [NSMutableArray array];
        for (NSDictionary *cityDic in cityList) {
            BRCityModel *cityModel = [[BRCityModel alloc]init];
            cityModel.code = [cityDic objectForKey:@"code"];
            cityModel.name = [cityDic objectForKey:@"name"];
            cityModel.index = [cityList indexOfObject:cityDic];
            NSArray *areaList = [cityDic.allKeys containsObject:@"areaList"] ? [cityDic objectForKey:@"areaList"] : [cityDic objectForKey:@"arealist"];
            NSMutableArray *tempArr3 = [NSMutableArray array];
            for (NSDictionary *areaDic in areaList) {
                BRAreaModel *areaModel = [[BRAreaModel alloc]init];
                areaModel.code = [areaDic objectForKey:@"code"];
                areaModel.name = [areaDic objectForKey:@"name"];
                areaModel.index = [areaList indexOfObject:areaDic];
                [tempArr3 addObject:areaModel];
            }
            cityModel.arealist = [tempArr3 copy];
            [tempArr2 addObject:cityModel];
        }
        proviceModel.citylist = [tempArr2 copy];
        [tempArr1 addObject:proviceModel];
    }
    return [tempArr1 copy];
}

#pragma mark - 设置默认选择的值
- (void)handlerDefaultSelectValue {
    __block NSString *selectProvinceName = nil;
    __block NSString *selectCityName = nil;
    __block NSString *selectAreaName = nil;
    
    if (self.mSelectValues.count > 0) {
        selectProvinceName = self.mSelectValues.count > 0 ? self.mSelectValues[0] : nil;
        selectCityName = self.mSelectValues.count > 1 ? self.mSelectValues[1] : nil;
        selectAreaName = self.mSelectValues.count > 2 ? self.mSelectValues[2] : nil;
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (self.pickerMode == BRAddressPickerModeProvince || self.pickerMode == BRAddressPickerModeCity || self.pickerMode == BRAddressPickerModeArea) {
        if (self.selectIndexs.count > 0) {
            NSInteger provinceIndex = [self.selectIndexs[0] integerValue];
            self.provinceIndex = (provinceIndex > 0 && provinceIndex < self.provinceModelArr.count) ? provinceIndex : 0;
            self.selectProvinceModel = self.provinceModelArr.count > self.provinceIndex ? self.provinceModelArr[self.provinceIndex] : nil;
        } else {
            self.provinceIndex = 0;
            self.selectProvinceModel = self.provinceModelArr.count > 0 ? self.provinceModelArr[0] : nil;
            [self.provinceModelArr enumerateObjectsUsingBlock:^(BRProvinceModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (selectProvinceName && [model.name isEqualToString:selectProvinceName]) {
                    weakSelf.provinceIndex = idx;
                    weakSelf.selectProvinceModel = model;
                    *stop = YES;
                }
            }];
        }
    }
    
    if (self.pickerMode == BRAddressPickerModeCity || self.pickerMode == BRAddressPickerModeArea) {
        self.cityModelArr = [self getCityModelArray:self.provinceIndex];
        if (self.selectIndexs.count > 0) {
            NSInteger cityIndex = self.selectIndexs.count > 1 ? [self.selectIndexs[1] integerValue] : 0;
            self.cityIndex = (cityIndex > 0 && cityIndex < self.cityModelArr.count) ? cityIndex : 0;
            self.selectCityModel = self.cityModelArr.count > self.cityIndex ? self.cityModelArr[self.cityIndex] : nil;
        } else {
            self.cityIndex = 0;
            self.selectCityModel = self.cityModelArr.count > 0 ? self.cityModelArr[0] : nil;
            [self.cityModelArr enumerateObjectsUsingBlock:^(BRCityModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (selectCityName && [model.name isEqualToString:selectCityName]) {
                    weakSelf.cityIndex = idx;
                    weakSelf.selectCityModel = model;
                    *stop = YES;
                }
            }];
        }
    }
    
    if (self.pickerMode == BRAddressPickerModeArea) {
        self.areaModelArr = [self getAreaModelArray:self.provinceIndex cityIndex:self.cityIndex];
        if (self.selectIndexs.count > 0) {
            NSInteger areaIndex = self.selectIndexs.count > 2 ? [self.selectIndexs[2] integerValue] : 0;
            self.areaIndex = (areaIndex > 0 && areaIndex < self.areaModelArr.count) ? areaIndex : 0;
            self.selectAreaModel = self.areaModelArr.count > self.areaIndex ? self.areaModelArr[self.areaIndex] : nil;
        } else {
            self.areaIndex = 0;
            self.selectAreaModel = self.areaModelArr.count > 0 ? self.areaModelArr[0] : nil;
            [self.areaModelArr enumerateObjectsUsingBlock:^(BRAreaModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (selectAreaName && [model.name isEqualToString:selectAreaName]) {
                    weakSelf.areaIndex = idx;
                    weakSelf.selectAreaModel = model;
                    *stop = YES;
                }
            }];
        }
    }
}

// 根据 省索引 获取 城市模型数组
- (NSArray *)getCityModelArray:(NSInteger)provinceIndex {
    BRProvinceModel *provinceModel = self.provinceModelArr[provinceIndex];
    // 返回城市模型数组
    return provinceModel.citylist;
}

// 根据 省索引和城市索引 获取 区域模型数组
- (NSArray *)getAreaModelArray:(NSInteger)provinceIndex cityIndex:(NSInteger)cityIndex {
    BRProvinceModel *provinceModel = self.provinceModelArr[provinceIndex];
    if (provinceModel.citylist && provinceModel.citylist.count > 0) {
        BRCityModel *cityModel = provinceModel.citylist[cityIndex];
        // 返回地区模型数组
        return cityModel.arealist;
    } else {
        return nil;
    }
}

#pragma mark - 地址选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight + pickerHeaderViewHeight, self.keyView.bounds.size.width, self.pickerStyle.pickerHeight)];
        _pickerView.backgroundColor = self.pickerStyle.pickerColor;
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource
// 1.设置 pickerView 的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.pickerMode) {
        case BRAddressPickerModeProvince:
            return 1;
            break;
        case BRAddressPickerModeCity:
            return 2;
            break;
        case BRAddressPickerModeArea:
            return 3;
            break;
            
        default:
            break;
    }
}

// 2.设置 pickerView 每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        // 返回省个数
        return self.provinceModelArr.count;
    }
    if (component == 1) {
        // 返回市个数
        return self.cityModelArr.count;
    }
    if (component == 2) {
        // 返回区个数
        return self.areaModelArr.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
// 3.设置 pickerView 的显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    // 1.自定义 row 的内容视图
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.pickerStyle.pickerTextFont;
        label.textColor = self.pickerStyle.pickerTextColor;
        // 字体自适应属性
        label.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        label.minimumScaleFactor = 0.5f;
    }
    if (component == 0) {
        BRProvinceModel *model = self.provinceModelArr[row];
        label.text = model.name;
    } else if (component == 1) {
        BRCityModel *model = self.cityModelArr[row];
        label.text = model.name;
    } else if (component == 2) {
        BRAreaModel *model = self.areaModelArr[row];
        label.text = model.name;
    }
    
    // 2.设置选择器中间选中行的样式
    [self.pickerStyle setupPickerSelectRowStyle:pickerView titleForRow:row forComponent:component];
    
    return label;
}

// 4.滚动 pickerView 执行的回调方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) { // 选择省
        // 保存选择的省份的索引
        self.provinceIndex = row;
        switch (self.pickerMode) {
            case BRAddressPickerModeProvince:
            {
                self.selectProvinceModel = self.provinceModelArr.count > self.provinceIndex ? self.provinceModelArr[self.provinceIndex] : nil;
                self.selectCityModel = nil;
                self.selectAreaModel = nil;
            }
                break;
            case BRAddressPickerModeCity:
            {
                self.cityModelArr = [self getCityModelArray:self.provinceIndex];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                self.selectProvinceModel = self.provinceModelArr.count > self.provinceIndex ? self.provinceModelArr[self.provinceIndex] : nil;
                self.selectCityModel = self.cityModelArr.count > 0 ? self.cityModelArr[0] : nil;
                self.selectAreaModel = nil;
            }
                break;
            case BRAddressPickerModeArea:
            {
                self.cityModelArr = [self getCityModelArray:self.provinceIndex];
                self.areaModelArr = [self getAreaModelArray:self.provinceIndex cityIndex:0];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectProvinceModel = self.provinceModelArr.count > self.provinceIndex ? self.provinceModelArr[self.provinceIndex] : nil;
                self.selectCityModel = self.cityModelArr.count > 0 ? self.cityModelArr[0] : nil;
                self.selectAreaModel = self.areaModelArr.count > 0 ? self.areaModelArr[0] : nil;
            }
                break;
            default:
                break;
        }
    }
    if (component == 1) { // 选择市
        // 保存选择的城市的索引
        self.cityIndex = row;
        switch (self.pickerMode) {
            case BRAddressPickerModeCity:
            {
                self.selectCityModel = self.cityModelArr.count > self.cityIndex ? self.cityModelArr[self.cityIndex] : nil;
                self.selectAreaModel = nil;
            }
                break;
            case BRAddressPickerModeArea:
            {
                self.areaModelArr = [self getAreaModelArray:self.provinceIndex cityIndex:self.cityIndex];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectCityModel = self.cityModelArr.count > self.cityIndex ? self.cityModelArr[self.cityIndex] : nil;
                self.selectAreaModel = self.areaModelArr.count > 0 ? self.areaModelArr[0] : nil;
            }
                break;
            default:
                break;
        }
    }
    if (component == 2) { // 选择区
        // 保存选择的地区的索引
        self.areaIndex = row;
        if (self.pickerMode == BRAddressPickerModeArea) {
            self.selectAreaModel = self.areaModelArr.count > self.areaIndex ? self.areaModelArr[self.areaIndex] : nil;
        }
    }
    
    // 滚动选择时执行 changeBlock
    if (self.changeBlock) {
        self.changeBlock(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
    }
    
    // 设置自动选择时，滚动选择时就执行 resultBlock
    if (self.isAutoSelect) {
        if (self.resultBlock) {
            self.resultBlock(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
        }
    }
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.pickerStyle.rowHeight;
}

#pragma mark - 重写父类方法
- (void)reloadData {
    // 1.处理数据源
    [self handlerPickerData];
    // 2.刷新选择器
    [self.pickerView reloadAllComponents];
    // 3.滚动到选择的地区
    if (self.pickerMode == BRAddressPickerModeProvince) {
        [self.pickerView selectRow:self.provinceIndex inComponent:0 animated:YES];
    } else if (self.pickerMode == BRAddressPickerModeCity) {
        [self.pickerView selectRow:self.provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:self.cityIndex inComponent:1 animated:YES];
    } else if (self.pickerMode == BRAddressPickerModeArea) {
        [self.pickerView selectRow:self.provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:self.cityIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:self.areaIndex inComponent:2 animated:YES];
    }
}

- (void)addPickerToView:(UIView *)view {
    // 1.添加地址选择器
    if (view) {
        // 立即刷新容器视图 view 的布局（防止 view 使用自动布局时，选择器视图无法正常显示）
        [view setNeedsLayout];
        [view layoutIfNeeded];
        
        self.frame = view.bounds;
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        CGFloat pickerFooterViewHeight = self.pickerFooterView ? self.pickerFooterView.bounds.size.height : 0;
        self.pickerView.frame = CGRectMake(0, pickerHeaderViewHeight, view.bounds.size.width, view.bounds.size.height - pickerHeaderViewHeight - pickerFooterViewHeight);
        [self addSubview:self.pickerView];
    } else {
        // iOS16：重新设置 pickerView 高度（解决懒加载设置frame不生效问题）
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        self.pickerView.frame = CGRectMake(0, self.pickerStyle.titleBarHeight + pickerHeaderViewHeight, self.keyView.bounds.size.width, self.pickerStyle.pickerHeight);
        
        [self.alertView addSubview:self.pickerView];
    }
    
    // ③添加中间选择行的两条分割线
    if (self.pickerStyle.clearPickerNewStyle) {
        [self.pickerStyle addSeparatorLineView:self.pickerView];
    }
    
    // 2.绑定数据
    [self reloadData];
    
    __weak typeof(self) weakSelf = self;
    self.doneBlock = ^{
        // 点击确定按钮后，执行block回调
        if (weakSelf.resultBlock) {
            weakSelf.resultBlock(weakSelf.selectProvinceModel, weakSelf.selectCityModel, weakSelf.selectAreaModel);
        }
    };
    
    [super addPickerToView:view];
}

#pragma mark - 重写父类方法
- (void)addSubViewToPicker:(UIView *)customView {
    [self.pickerView addSubview:customView];
}

#pragma mark - 弹出选择器视图
- (void)show {
    [self addPickerToView:nil];
}

#pragma mark - 关闭选择器视图
- (void)dismiss {
    [self removePickerFromView:nil];
}

#pragma mark - setter方法
- (void)setSelectValues:(NSArray<NSString *> *)selectValues {
    self.mSelectValues = selectValues;
}

#pragma mark - getter方法
- (NSArray *)provinceModelArr {
    if (!_provinceModelArr) {
        _provinceModelArr = [NSArray array];
    }
    return _provinceModelArr;
}

- (NSArray *)cityModelArr {
    if (!_cityModelArr) {
        _cityModelArr = [NSArray array];
    }
    return _cityModelArr;
}

- (NSArray *)areaModelArr {
    if (!_areaModelArr) {
        _areaModelArr = [NSArray array];
    }
    return _areaModelArr;
}

- (BRProvinceModel *)selectProvinceModel {
    if (!_selectProvinceModel) {
        _selectProvinceModel = [[BRProvinceModel alloc]init];
    }
    return _selectProvinceModel;
}

- (BRCityModel *)selectCityModel {
    if (!_selectCityModel) {
        _selectCityModel = [[BRCityModel alloc]init];
        _selectCityModel.code = @"";
        _selectCityModel.name = @"";
    }
    return _selectCityModel;
}

- (BRAreaModel *)selectAreaModel {
    if (!_selectAreaModel) {
        _selectAreaModel = [[BRAreaModel alloc]init];
        _selectAreaModel.code = @"";
        _selectAreaModel.name = @"";
    }
    return _selectAreaModel;
}

- (NSArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSArray array];
    }
    return _dataSourceArr;
}

- (NSArray<NSString *> *)mSelectValues {
    if (!_mSelectValues) {
        _mSelectValues = [NSArray array];
    }
    return _mSelectValues;
}

- (NSArray<NSNumber *> *)selectIndexs {
    if (!_selectIndexs) {
        _selectIndexs = [NSArray array];
    }
    return _selectIndexs;
}

@end
