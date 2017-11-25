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

@interface BRAddressPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger rowOfProvince; // 保存省份对应的下标
    NSInteger rowOfCity;     // 保存市对应的下标
    NSInteger rowOfTown;     // 保存区对应的下标
}

// 时间选择器（默认大小: 320px × 216px）
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *addressModelArr;

// 默认选中的值（@[省索引, 市索引, 区索引]）
@property (nonatomic, strong) NSArray *defaultSelectedArr;
// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
// 选中后的回调
@property (nonatomic, copy) BRAddressResultBlock resultBlock;

@end

@implementation BRAddressPickerView

#pragma mark - 显示地址选择器
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr isAutoSelect:(BOOL)isAutoSelect resultBlock:(BRAddressResultBlock)resultBlock {
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc] initWithDefaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect resultBlock:resultBlock];
    [addressPickerView showWithAnimation:YES];
}

#pragma mark - 初始化地址选择器
- (instancetype)initWithDefaultSelected:(NSArray *)defaultSelectedArr isAutoSelect:(BOOL)isAutoSelect resultBlock:(BRAddressResultBlock)resultBlock {
    if (self = [super init]) {
        // 默认选中
        if (defaultSelectedArr.count == 3) {
            self.defaultSelectedArr = defaultSelectedArr;
        } else {
            self.defaultSelectedArr = @[@10, @0, @0];
        }
        self.isAutoSelect = isAutoSelect;
        self.resultBlock = resultBlock;
        [self loadData];
        [self initUI];
    }
    return self;
}

#pragma mark - 获取地址数据
- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"BRCity" ofType:@"plist"];
    NSArray *arrData = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *dic in arrData) {
        // 此处用 YYModel 进行解析
        BRProvinceModel *proviceModel = [BRProvinceModel mj_objectWithKeyValues:dic];
        [self.addressModelArr addObject:proviceModel];
    }
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = @"请选择城市";
    // 添加时间选择器
    [self.alertView addSubview:self.pickerView];
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
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
    
    NSInteger recordRowOfProvince = [self.defaultSelectedArr[0] integerValue];
    NSInteger recordRowOfCity = [self.defaultSelectedArr[1] integerValue];
    NSInteger recordRowOfTown = [self.defaultSelectedArr[2] integerValue];
    
    // 2.滚动到默认行
    [self scrollToRow:recordRowOfProvince secondRow:recordRowOfCity thirdRow:recordRowOfTown];
    
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
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    NSLog(@"点击确定按钮后，执行block回调");
    [self dismissWithAnimation:YES];
    if(self.resultBlock) {
        NSArray *arr = [self getChooseCityArr];
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
    }
    return _pickerView;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    BRProvinceModel *provinceModel = self.addressModelArr[rowOfProvince];
    BRCityModel *cityModel = provinceModel.city[rowOfCity];
    if (component == 0) {
        //返回省个数
        return self.addressModelArr.count;
    }
    if (component == 1) {
        //返回市个数
        return provinceModel.city.count;
    }
    if (component == 2) {
        //返回区个数
        return cityModel.town.count;
    }
    return 0;
    
}

#pragma mark - PickerView的代理方法
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *showTitleValue = @"";
    if (component == 0) {//省
        BRProvinceModel *provinceModel = self.addressModelArr[row];
        showTitleValue = provinceModel.name;
    }
    if (component == 1) {//市
        BRProvinceModel *provinceModel = self.addressModelArr[rowOfProvince];
        BRCityModel *cityModel = provinceModel.city[row];
        showTitleValue = cityModel.name;
    }
    if (component == 2) {//区
        BRProvinceModel *provinceModel = self.addressModelArr[rowOfProvince];
        BRCityModel *cityModel = provinceModel.city[rowOfCity];
        if (cityModel.town.count > 0) {
            BRTownModel *townModel = cityModel.town[row];
            showTitleValue = townModel.name;
        }
    }
    return showTitleValue;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 30) / 3, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.0f];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        rowOfProvince = row;
        rowOfCity = 0;
        rowOfTown = 0;
    } else if (component == 1) {
        rowOfCity = row;
        rowOfTown = 0;
    } else if (component == 2) {
        rowOfTown = row;
    }
    // 滚动到指定行
    [self scrollToRow:rowOfProvince secondRow:rowOfCity thirdRow:rowOfTown];
    
    // 自动获取数据，滚动完就回调
    if (self.isAutoSelect) {
        NSArray *arr = [self getChooseCityArr];
        if (self.resultBlock) {
            self.resultBlock(arr);
        }
    }
}

#pragma mark - Tool
- (NSArray *)getChooseCityArr {
    NSArray *arr;
    if (rowOfProvince < self.addressModelArr.count) {
        BRProvinceModel *provinceModel = self.addressModelArr[rowOfProvince];
        if (rowOfCity < provinceModel.city.count) {
            BRCityModel *cityModel = provinceModel.city[rowOfCity];
            if (rowOfTown < cityModel.town.count) {
                BRTownModel *townModel = cityModel.town[rowOfTown];
                arr = @[provinceModel.name, cityModel.name, townModel.name];
            }
        }
    }
    return arr;
}

#pragma mark - 滚动到指定行
- (void)scrollToRow:(NSInteger)firstRow secondRow:(NSInteger)secondRow thirdRow:(NSInteger)thirdRow {
    if (firstRow < self.addressModelArr.count) {
        rowOfProvince = firstRow;
        BRProvinceModel *provinceModel = self.addressModelArr[firstRow];
        if (secondRow < provinceModel.city.count) {
            rowOfCity = secondRow;
            [self.pickerView reloadComponent:1];
            BRCityModel *cityModel = provinceModel.city[secondRow];
            if (thirdRow < cityModel.town.count) {
                rowOfTown = thirdRow;
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:firstRow inComponent:0 animated:YES];
                [self.pickerView selectRow:secondRow inComponent:1 animated:YES];
                [self.pickerView selectRow:thirdRow inComponent:2 animated:YES];
            }
        }
    }
    
//    // 是否自动滚动回调
//    if (self.isAutoSelect) {
//        NSArray *arr = [self getChooseCityArr];
//        if (self.resultBlock != nil) {
//            self.resultBlock(arr);
//        }
//    }
}

- (NSMutableArray *)addressModelArr {
    if (!_addressModelArr) {
        _addressModelArr = [[NSMutableArray alloc]init];
    }
    return _addressModelArr;
}

@end
