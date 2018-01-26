//
//  BRAddressPickerView.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/borenfocus/BRPickerView

#import "BRAddressPickerView.h"
#import "BRAddressModel.h"
#import "MJExtension.h"

@interface BRAddressPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL isDataSourceValid;    // 数据源是否合法
    NSString *_selectProvince; // 保存选中的省
    NSString *_selectCity;     // 保存选中的市
    NSString *_selectArea;     // 保存选中的区
    NSInteger _selectProvinceIndex; // 记录省选中的位置
}
// 时间选择器（默认大小: 320px × 216px）
@property (nonatomic, strong) UIPickerView *pickerView;
// 保存传入的数据源
@property (nonatomic, strong) NSArray *dataSource;
// 省市区模型数据
@property (nonatomic, strong) NSMutableArray *addressModelArr;
// 省
@property(nonatomic, strong) NSArray *provinceNameArr;
// 市
@property(nonatomic, strong) NSArray *cityNameArr;
// 区
@property(nonatomic, strong) NSArray *areaNameArr;
// 显示类型
@property (nonatomic, assign) BRAddressPickerMode showType;

// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
// 主题色
@property (nonatomic, strong) UIColor *themeColor;
// 选中后的回调
@property (nonatomic, copy) BRAddressResultBlock resultBlock;
// 取消选择的回调
@property (nonatomic, copy) BRAddressCancelBlock cancelBlock;

@end

@implementation BRAddressPickerView

#pragma mark - 1.显示地址选择器
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                 resultBlock:(BRAddressResultBlock)resultBlock {
    [self showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:nil defaultSelected:defaultSelectedArr isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil];
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
                         cancelBlock:(BRAddressCancelBlock)cancelBlock {
    [self showAddressPickerWithShowType:showType dataSource:nil defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
}

#pragma mark - 4.显示地址选择器（支持 设置选择器类型、传入地区数据源、设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showAddressPickerWithShowType:(BRAddressPickerMode)showType
                           dataSource:(NSArray *)dataSource
                      defaultSelected:(NSArray *)defaultSelectedArr
                         isAutoSelect:(BOOL)isAutoSelect
                           themeColor:(UIColor *)themeColor
                          resultBlock:(BRAddressResultBlock)resultBlock
                          cancelBlock:(BRAddressCancelBlock)cancelBlock {
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc] initWithShowType:showType dataSource:dataSource defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    if (addressPickerView->isDataSourceValid) {
        [addressPickerView showWithAnimation:YES];
    } else {
        NSLog(@"数据源不合法！");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"参数异常！" message:@"请检查地址选择器的数据源是否有误" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - 初始化地址选择器
- (instancetype)initWithShowType:(BRAddressPickerMode)showType
                      dataSource:(NSArray *)dataSource
                 defaultSelected:(NSArray *)defaultSelectedArr
                    isAutoSelect:(BOOL)isAutoSelect
                      themeColor:(UIColor *)themeColor
                     resultBlock:(BRAddressResultBlock)resultBlock
                     cancelBlock:(BRAddressCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.showType = showType;
        self.dataSource = dataSource;
        isDataSourceValid = YES;
        // 默认选中
        if (defaultSelectedArr) {
            if (defaultSelectedArr.count > 0 && [defaultSelectedArr[0] isKindOfClass:[NSString class]]) {
                _selectProvince = defaultSelectedArr[0];
            }
            if (defaultSelectedArr.count > 1 && [defaultSelectedArr[1] isKindOfClass:[NSString class]]) {
                _selectCity = defaultSelectedArr[1];
            }
            if (defaultSelectedArr.count > 2 && [defaultSelectedArr[2] isKindOfClass:[NSString class]]) {
                _selectArea = defaultSelectedArr[2];
            }
        }
        self.isAutoSelect = isAutoSelect;
        self.themeColor = themeColor;
        self.resultBlock = resultBlock;
        self.cancelBlock = cancelBlock;
        
        [self loadData];
        if (isDataSourceValid) {
            [self initUI];
        }
    }
    return self;
}

#pragma mark - 获取地址数据
- (void)loadData {
    // 如果外部没有传入地区数据源，就使用本地的数据源
    if (!self.dataSource || self.dataSource.count == 0) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"BRCity.plist" ofType:nil];
        NSArray *dataSource = [NSArray arrayWithContentsOfFile:filePath];
        if (!dataSource || dataSource.count == 0) {
            isDataSourceValid = NO;
            return;
        }
        self.dataSource = dataSource;
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dic in self.dataSource) {
        // 此处用 MJExtension 进行解析
        BRProvinceModel *proviceModel = [BRProvinceModel mj_objectWithKeyValues:dic];
        [self.addressModelArr addObject:proviceModel];
        [tempArr addObject:proviceModel.provinceName];
    }
    self.provinceNameArr = [tempArr copy];
    NSInteger provinceIndex = 0;
    NSInteger cityIndex = 0;
    NSInteger areaIndex = 0;
    if ([self.provinceNameArr containsObject:_selectProvince]) {
        provinceIndex = [self.provinceNameArr indexOfObject:_selectProvince];
    } else {
        // 值无效时（即不存在传入的省份值，就默认选择第一个省份）
        _selectProvince = [self.provinceNameArr firstObject];
    }
    _selectProvinceIndex = provinceIndex;
    self.cityNameArr = [self getCityNameArray:provinceIndex];
    if ([self.cityNameArr containsObject:_selectCity]) {
        cityIndex = [self.cityNameArr indexOfObject:_selectCity];
    } else {
        // 值无效时（即不存在传入的城市值，就默认选择第一个城市）
        _selectCity = [self.cityNameArr firstObject];
    }
    self.areaNameArr = [self getAreaNameArray:provinceIndex cityIndex:cityIndex];
    if ([self.areaNameArr containsObject:_selectArea]) {
        areaIndex = [self.areaNameArr indexOfObject:_selectArea];
    } else {
        // 值无效时（即不存在传入的区域值，就默认选择第一个区域）
        _selectArea = [self.areaNameArr firstObject];
    }
    // 默认滚动
    [self scrollToRow:provinceIndex secondRow:cityIndex thirdRow:areaIndex];
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

// 根据 省索引 获取 城市名数组
- (NSArray *)getCityNameArray:(NSInteger)provinceIndex {
    BRProvinceModel *provinceModel = self.addressModelArr[provinceIndex];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (BRCityModel *model in provinceModel.citylist) {
        [tempArray addObject:model.cityName];
    }
    return [tempArray copy];
}

// 根据 省索引和城市索引 获取 区域名数组
- (NSArray *)getAreaNameArray:(NSInteger)provinceIndex cityIndex:(NSInteger)cityIndex {
    BRProvinceModel *provinceModel = self.addressModelArr[provinceIndex];
    BRCityModel *cityModel = provinceModel.citylist[cityIndex];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (BRAreaModel *model in cityModel.arealist) {
        [tempArray addObject:model.areaName];
    }
    return [tempArray copy];
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    if (self.showType == BRAddressPickerModeProvince) {
        self.titleLabel.text = @"请选择省份";
    } else if (self.showType == BRAddressPickerModeCity) {
        self.titleLabel.text = @"请选择城市";
    } else {
        self.titleLabel.text = @"请选择地区";
    }
    // 添加时间选择器
    [self.alertView addSubview:self.pickerView];
    if (self.themeColor && [self.themeColor isKindOfClass:[UIColor class]]) {
        [self setupThemeColor:self.themeColor];
    }
    [self.pickerView reloadAllComponents];
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    // 1.获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kDatePicHeight + kTopViewHeight;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kDatePicHeight + kTopViewHeight;
        self.alertView.frame = rect;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.leftBtn removeFromSuperview];
        [self.rightBtn removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.topView removeFromSuperview];
        [self.pickerView removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        self.pickerView = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    [self dismissWithAnimation:YES];
    // 点击确定按钮后，执行回调
    if(self.resultBlock) {
        NSArray *arr = @[_selectProvince, _selectCity, _selectArea];
        self.resultBlock(arr);
    }
}

#pragma mark - 地址选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, SCREEN_WIDTH, kDatePicHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
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
        return self.provinceNameArr.count;
    }
    if (component == 1) {
        // 返回市个数
        return self.cityNameArr.count;
    }
    if (component == 2) {
        // 返回区个数
        return self.areaNameArr.count;
    }
    return 0;
    
}

#pragma mark - UIPickerViewDelegate
// 3.设置 pickerView 的 显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    // 设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH) / 3, 35 * kScaleFit)];
    bgView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5 * kScaleFit, 0, (SCREEN_WIDTH) / 3 - 10 * kScaleFit, 35 * kScaleFit)];
    [bgView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:18.0f * kScaleFit];
    // 字体自适应属性
    label.adjustsFontSizeToFitWidth = YES;
    // 自适应最小字体缩放比例
    label.minimumScaleFactor = 0.5f;
    if (component == 0) {
        label.text = self.provinceNameArr[row];
    }else if (component == 1){
        label.text = self.cityNameArr[row];
    }else if (component == 2){
        label.text = self.areaNameArr[row];
    }
    return bgView;
}

// 4.选中时回调的委托方法，在此方法中实现省份和城市间的联动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) { // 选择省
        _selectProvinceIndex = row;
        switch (self.showType) {
            case BRAddressPickerModeProvince:
            {
                _selectProvince = self.provinceNameArr[row];
                _selectCity = @"";
                _selectArea = @"";
            }
                break;
            case BRAddressPickerModeCity:
            {
                self.cityNameArr = [self getCityNameArray:row];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                _selectProvince = self.provinceNameArr[row];
                _selectCity = self.cityNameArr[0];
                _selectArea = @"";
            }
                break;
            case BRAddressPickerModeArea:
            {
                self.cityNameArr = [self getCityNameArray:row];
                self.areaNameArr = [self getAreaNameArray:row cityIndex:0];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                _selectProvince = self.provinceNameArr[row];
                _selectCity = self.cityNameArr[0];
                _selectArea = self.areaNameArr[0];
            }
                break;
            default:
                break;
        }
    }
    if (component == 1) { // 选择市
        switch (self.showType) {
            case BRAddressPickerModeCity:
            {
                _selectCity = self.cityNameArr[row];
                _selectArea = @"";
            }
                break;
            case BRAddressPickerModeArea:
            {
                self.areaNameArr = [self getAreaNameArray:_selectProvinceIndex cityIndex:row];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                _selectCity = self.cityNameArr[row];
                _selectArea = self.areaNameArr[0];
            }
                break;
            default:
                break;
        }
    }
    if (component == 2) { // 选择区
        if (self.showType == BRAddressPickerModeArea) {
            _selectArea = self.areaNameArr[row];
        }
    }
    
    // 自动获取数据，滚动完就执行回调
    if (self.isAutoSelect) {
        NSArray *arr = @[_selectProvince, _selectCity, _selectArea];
        if (self.resultBlock) {
            self.resultBlock(arr);
        }
    }
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f * kScaleFit;
}

- (NSMutableArray *)addressModelArr {
    if (!_addressModelArr) {
        _addressModelArr = [[NSMutableArray alloc]init];
    }
    return _addressModelArr;
}

- (NSArray *)provinceNameArr {
    if (!_provinceNameArr) {
        _provinceNameArr = [NSArray array];
    }
    return _provinceNameArr;
}

- (NSArray *)cityNameArr {
    if (!_cityNameArr) {
        _cityNameArr = [NSArray array];
    }
    return _cityNameArr;
}

- (NSArray *)areaNameArr {
    if (!_areaNameArr) {
        _areaNameArr = [NSArray array];
    }
    return _areaNameArr;
}

@end
