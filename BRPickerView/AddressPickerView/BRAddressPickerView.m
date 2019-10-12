//
//  BRAddressPickerView.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRAddressPickerView.h"
#import "BRPickerViewMacro.h"

@interface BRAddressPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL _isDataSourceValid;    // 数据源是否合法
    NSInteger _provinceIndex;   // 记录省选中的位置
    NSInteger _cityIndex;       // 记录市选中的位置
    NSInteger _areaIndex;       // 记录区选中的位置
}
// 地址选择器
@property (nonatomic, strong) UIPickerView *pickerView;
// 省模型数组
@property(nonatomic, strong) NSArray *provinceModelArr;
// 市模型数组
@property(nonatomic, strong) NSArray *cityModelArr;
// 区模型数组
@property(nonatomic, strong) NSArray *areaModelArr;
// 显示类型
@property (nonatomic, assign) BRAddressPickerMode showType;
// 选中的省
@property(nonatomic, strong) BRProvinceModel *selectProvinceModel;
// 选中的市
@property(nonatomic, strong) BRCityModel *selectCityModel;
// 选中的区
@property(nonatomic, strong) BRAreaModel *selectAreaModel;

@end

@implementation BRAddressPickerView

#pragma mark - 1.显示地址选择器
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                 resultBlock:(BRAddressResultBlock)resultBlock {
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc] initWithShowType:BRAddressPickerModeArea dataSource:nil defaultSelected:defaultSelectedArr isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil];
    NSAssert(addressPickerView->_isDataSourceValid, @"数据源不合法！参数异常，请检查地址选择器的数据源是否有误");
    if (addressPickerView->_isDataSourceValid) {
        [addressPickerView showWithAnimation:YES toView:nil];
    }
}

#pragma mark - 2.显示地址选择器（支持 设置自动选择 和 自定义主题颜色）
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                  themeColor:(UIColor *)themeColor
                                 resultBlock:(BRAddressResultBlock)resultBlock {
    [self showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:nil defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 3.显示地址选择器（支持 设置选择器类型、设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showAddressPickerWithShowType:(BRAddressPickerMode)showType
                     defaultSelected:(NSArray *)defaultSelectedArr
                        isAutoSelect:(BOOL)isAutoSelect
                          themeColor:(UIColor *)themeColor
                         resultBlock:(BRAddressResultBlock)resultBlock
                         cancelBlock:(BRCancelBlock)cancelBlock {
    [self showAddressPickerWithShowType:showType dataSource:nil defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
}

#pragma mark - 4.显示地址选择器（支持 设置选择器类型、传入地区数据源、设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showAddressPickerWithShowType:(BRAddressPickerMode)showType
                           dataSource:(NSArray *)dataSource
                      defaultSelected:(NSArray *)defaultSelectedArr
                         isAutoSelect:(BOOL)isAutoSelect
                           themeColor:(UIColor *)themeColor
                          resultBlock:(BRAddressResultBlock)resultBlock
                          cancelBlock:(BRCancelBlock)cancelBlock {
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc] initWithShowType:showType dataSource:dataSource defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    NSAssert(addressPickerView->_isDataSourceValid, @"数据源不合法！参数异常，请检查地址选择器的数据源是否有误");
    if (addressPickerView->_isDataSourceValid) {
        [addressPickerView showWithAnimation:YES toView:nil];
    }
}

#pragma mark - 初始化地址选择器
- (instancetype)initWithPickerMode:(BRAddressPickerMode)pickerMode {
    if (self = [super init]) {
        self.showType = pickerMode;
        self.isAutoSelect = NO;
        _isDataSourceValid = YES;
    }
    return self;
}

- (instancetype)initWithShowType:(BRAddressPickerMode)showType
                      dataSource:(NSArray *)dataSource
                 defaultSelected:(NSArray *)defaultSelectedArr
                    isAutoSelect:(BOOL)isAutoSelect
                      themeColor:(UIColor *)themeColor
                     resultBlock:(BRAddressResultBlock)resultBlock
                     cancelBlock:(BRCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.showType = showType;
        self.dataSourceArr = dataSource;
        self.defaultSelectedArr = defaultSelectedArr;
        _isDataSourceValid = YES;
    
        self.isAutoSelect = isAutoSelect;
        
        // 兼容旧版本，快速设置主题样式
        if (themeColor && [themeColor isKindOfClass:[UIColor class]]) {
            self.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:themeColor];
        }
        
        self.resultBlock = resultBlock;
        self.cancelBlock = cancelBlock;
    }
    return self;
}

#pragma mark - 获取地址数据
- (void)loadData {
    if (self.dataSourceArr && self.dataSourceArr.count > 0) {
        id element = [self.dataSourceArr firstObject];
        // 如果传的值是解析好的模型数组
        if ([element isKindOfClass:[BRProvinceModel class]]) {
            self.provinceModelArr = self.dataSourceArr;
        } else {
            // 传的是JSON数组，就解析数据源
            [self parseDataSource];
        }
    } else {
        // 如果外部没有传入地区数据源，就使用本地的数据源
        /*
            先拿到最外面的 bundle。
            对 framework 链接方式来说就是 framework 的 bundle 根目录，
            对静态库链接方式来说就是 target client 的 main bundle，
            然后再去找下面名为 BRPickerView 的 bundle 对象。
         */
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"BRPickerView" withExtension:@"bundle"];
        NSBundle *pickerViewBundle = [NSBundle bundleWithURL:url];
        
        // 获取本地文件
        NSString *filePath = [pickerViewBundle pathForResource:@"BRCity" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSArray *dataSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (!dataSource || dataSource.count == 0) {
            _isDataSourceValid = NO;
            return;
        }
        self.dataSourceArr = dataSource;
        
        // 解析数据源
        [self parseDataSource];
    }
    
    // 设置默认值
    [self setupDefaultValue];
    
    // 注意必须先刷新UI，再设置默认滚动
    [self.pickerView reloadAllComponents];
    
    // 设置默认滚动
    [self scrollToRow:_provinceIndex secondRow:_cityIndex thirdRow:_areaIndex];
}

#pragma mark - 解析数据源
- (void)parseDataSource {
    NSMutableArray *tempArr1 = [NSMutableArray array];
    for (NSDictionary *proviceDic in self.dataSourceArr) {
        BRProvinceModel *proviceModel = [[BRProvinceModel alloc]init];
        proviceModel.code = proviceDic[@"code"];
        proviceModel.name = proviceDic[@"name"];
        proviceModel.index = [self.dataSourceArr indexOfObject:proviceDic];
        NSArray *citylist = proviceDic[@"citylist"];
        NSMutableArray *tempArr2 = [NSMutableArray array];
        for (NSDictionary *cityDic in citylist) {
            BRCityModel *cityModel = [[BRCityModel alloc]init];
            cityModel.code = cityDic[@"code"];
            cityModel.name = cityDic[@"name"];
            cityModel.index = [citylist indexOfObject:cityDic];
            NSArray *arealist = cityDic[@"arealist"];
            NSMutableArray *tempArr3 = [NSMutableArray array];
            for (NSDictionary *areaDic in arealist) {
                BRAreaModel *areaModel = [[BRAreaModel alloc]init];
                areaModel.code = areaDic[@"code"];
                areaModel.name = areaDic[@"name"];
                areaModel.index = [arealist indexOfObject:areaDic];
                [tempArr3 addObject:areaModel];
            }
            cityModel.arealist = [tempArr3 copy];
            [tempArr2 addObject:cityModel];
        }
        proviceModel.citylist = [tempArr2 copy];
        [tempArr1 addObject:proviceModel];
    }
    self.provinceModelArr = [tempArr1 copy];
}

#pragma mark - 设置默认值
- (void)setupDefaultValue {
    __block NSString *selectProvinceName = nil;
    __block NSString *selectCityName = nil;
    __block NSString *selectAreaName = nil;
    // 1. 获取默认选中的省市区的名称
    if (self.defaultSelectedArr) {
        if (self.defaultSelectedArr.count > 0 && [self.defaultSelectedArr[0] isKindOfClass:[NSString class]]) {
            selectProvinceName = self.defaultSelectedArr[0];
        }
        if (self.defaultSelectedArr.count > 1 && [self.defaultSelectedArr[1] isKindOfClass:[NSString class]]) {
            selectCityName = self.defaultSelectedArr[1];
        }
        if (self.defaultSelectedArr.count > 2 && [self.defaultSelectedArr[2] isKindOfClass:[NSString class]]) {
            selectAreaName = self.defaultSelectedArr[2];
        }
    }
    
    // 2. 根据名称找到默认选中的省市区索引
    @weakify(self)
    [self.provinceModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        BRProvinceModel *model = obj;
        if ([model.name isEqualToString:selectProvinceName]) {
            _provinceIndex = idx;
            self.selectProvinceModel = model;
            *stop = YES;
        } else {
            if (idx == self.provinceModelArr.count - 1) {
                _provinceIndex = 0;
                self.selectProvinceModel = [self.provinceModelArr firstObject];
            }
        }
    }];
    if (self.showType == BRAddressPickerModeCity || self.showType == BRAddressPickerModeArea) {
        self.cityModelArr = [self getCityModelArray:_provinceIndex];
        @weakify(self)
        [self.cityModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            BRCityModel *model = obj;
            if ([model.name isEqualToString:selectCityName]) {
                _cityIndex = idx;
                self.selectCityModel = model;
                *stop = YES;
            } else {
                if (idx == self.cityModelArr.count - 1) {
                    _cityIndex = 0;
                    self.selectCityModel = [self.cityModelArr firstObject];
                }
            }
        }];
    }
    if (self.showType == BRAddressPickerModeArea) {
        self.areaModelArr = [self getAreaModelArray:_provinceIndex cityIndex:_cityIndex];
        @weakify(self)
        [self.areaModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            BRAreaModel *model = obj;
            if ([model.name isEqualToString:selectAreaName]) {
                _areaIndex = idx;
                self.selectAreaModel = model;
                *stop = YES;
            } else {
                if (idx == self.areaModelArr.count - 1) {
                    _areaIndex = 0;
                    self.selectAreaModel = [self.areaModelArr firstObject];
                }
            }
        }];
    }
}

#pragma mark - 滚动到指定行
- (void)scrollToRow:(NSInteger)provinceIndex secondRow:(NSInteger)cityIndex thirdRow:(NSInteger)areaIndex {
    if (self.showType == BRAddressPickerModeProvince) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
    } else if (self.showType == BRAddressPickerModeCity) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
    } else if (self.showType == BRAddressPickerModeArea) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:areaIndex inComponent:2 animated:YES];
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
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTitleBarHeight + 0.5, SCREEN_WIDTH, kPickerHeight)];
        _pickerView.backgroundColor = self.pickerStyle.pickerColor;
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}


#pragma mark - UIPickerViewDataSource
// 1.指定pickerview有几个表盘(几列)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.showType) {
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

// 2.指定每个表盘上有几行数据
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
// 3.设置 pickerView 的 显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    // 设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = self.pickerStyle.separatorColor;
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = self.pickerStyle.separatorColor;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (self.pickerView.frame.size.width) / pickerView.numberOfComponents, 35 * kScaleFit)];
    bgView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5 * kScaleFit, 0, (self.pickerView.frame.size.width) / pickerView.numberOfComponents - 10 * kScaleFit, 35 * kScaleFit)];
    [bgView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.pickerStyle.pickerTextColor;
    label.font = [UIFont systemFontOfSize:18.0f * kScaleFit];
    // 字体自适应属性
    label.adjustsFontSizeToFitWidth = YES;
    // 自适应最小字体缩放比例
    label.minimumScaleFactor = 0.5f;
    if (component == 0) {
        BRProvinceModel *model = self.provinceModelArr[row];
        label.text = model.name;
    }else if (component == 1){
        BRCityModel *model = self.cityModelArr[row];
        label.text = model.name;
    }else if (component == 2){
        BRAreaModel *model = self.areaModelArr[row];
        label.text = model.name;
    }
    return bgView;
}

// 4.选中时回调的委托方法，在此方法中实现省份和城市间的联动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) { // 选择省
        // 保存选择的省份的索引
        _provinceIndex = row;
        switch (self.showType) {
            case BRAddressPickerModeProvince:
            {
                self.selectProvinceModel = self.provinceModelArr[_provinceIndex];
                self.selectCityModel = nil;
                self.selectAreaModel = nil;
            }
                break;
            case BRAddressPickerModeCity:
            {
                self.cityModelArr = [self getCityModelArray:_provinceIndex];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                self.selectProvinceModel = self.provinceModelArr[_provinceIndex];
                self.selectCityModel = self.cityModelArr[0];
                self.selectAreaModel = nil;
            }
                break;
            case BRAddressPickerModeArea:
            {
                self.cityModelArr = [self getCityModelArray:_provinceIndex];
                self.areaModelArr = [self getAreaModelArray:_provinceIndex cityIndex:0];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectProvinceModel = self.provinceModelArr[_provinceIndex];
                if (self.cityModelArr.count > 0) {
                    self.selectCityModel = self.cityModelArr[0];
                } else {
                    self.selectCityModel = nil;
                }
                if (self.areaModelArr.count > 0) {
                    self.selectAreaModel = self.areaModelArr[0];
                } else {
                    self.selectAreaModel = nil;
                }
            }
                break;
            default:
                break;
        }
    }
    if (component == 1) { // 选择市
        // 保存选择的城市的索引
        _cityIndex = row;
        switch (self.showType) {
            case BRAddressPickerModeCity:
            {
                self.selectCityModel = self.cityModelArr[_cityIndex];
                self.selectAreaModel = nil;
            }
                break;
            case BRAddressPickerModeArea:
            {
                self.areaModelArr = [self getAreaModelArray:_provinceIndex cityIndex:_cityIndex];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectCityModel = self.cityModelArr[_cityIndex];
                if (self.areaModelArr.count > 0) {
                    self.selectAreaModel = self.areaModelArr[0];
                } else {
                    self.selectAreaModel = nil;
                }
            }
                break;
            default:
                break;
        }
    }
    if (component == 2) { // 选择区
        // 保存选择的地区的索引
        _areaIndex = row;
        if (self.showType == BRAddressPickerModeArea) {
            self.selectAreaModel = self.areaModelArr[_areaIndex];
        }
    }
    
    // 自动获取数据，滚动完就执行回调
    if (self.isAutoSelect) {
        if (self.resultBlock) {
            self.resultBlock(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
        }
    }
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f * kScaleFit;
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation toView:(UIView *)view {
    // 添加地址选择器
    [self setPickerView:self.pickerView toView:view];
    [self loadData];
    
    __weak typeof(self) weakSelf = self;
    self.doneBlock = ^{
        // 点击确定按钮后，执行block回调
        [weakSelf dismissWithAnimation:animation toView:view];
        if (weakSelf.resultBlock) {
           weakSelf.resultBlock(weakSelf.selectProvinceModel, weakSelf.selectCityModel, weakSelf.selectAreaModel);
        }
    };
    
    [super showWithAnimation:animation toView:view];
}

#pragma mark - 弹出选择器视图
- (void)show {
    [self showWithAnimation:YES toView:nil];
}

#pragma mark - 关闭选择器视图
- (void)dismiss {
    [self dismissWithAnimation:YES toView:nil];
}

#pragma mark - 添加选择器到指定容器视图上
- (void)addPickerToView:(UIView *)view {
    [self showWithAnimation:NO toView:view];
}

#pragma mark - 从指定容器视图上移除选择器
- (void)removePickerFromView:(UIView *)view {
    [self dismissWithAnimation:NO toView:view];
}

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

- (NSArray *)defaultSelectedArr {
    if (!_defaultSelectedArr) {
        _defaultSelectedArr = [NSArray array];
    }
    return _defaultSelectedArr;
}

@end
