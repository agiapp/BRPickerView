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
    [self showAddressPickerWithDefaultSelected:defaultSelectedArr isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 2.显示地址选择器（支持 设置自动选择）
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                 resultBlock:(BRAddressResultBlock)resultBlock {
    [self showAddressPickerWithDefaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:nil resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 3.显示地址选择器（支持 设置自动选择 和 自定义主题颜色）
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                  themeColor:(UIColor *)themeColor
                                 resultBlock:(BRAddressResultBlock)resultBlock {
    [self showAddressPickerWithDefaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 4.显示地址选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                  themeColor:(UIColor *)themeColor
                                 resultBlock:(BRAddressResultBlock)resultBlock
                                 cancelBlock:(BRAddressCancelBlock)cancelBlock {
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc] initWithDefaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    [addressPickerView showWithAnimation:YES];
}

#pragma mark - 初始化地址选择器
- (instancetype)initWithDefaultSelected:(NSArray *)defaultSelectedArr
                           isAutoSelect:(BOOL)isAutoSelect
                             themeColor:(UIColor *)themeColor
                            resultBlock:(BRAddressResultBlock)resultBlock
                            cancelBlock:(BRAddressCancelBlock)cancelBlock {
    if (self = [super init]) {
        // 默认选中
        if (defaultSelectedArr.count == 3) {
            self.defaultSelectedArr = defaultSelectedArr;
        } else {
            self.defaultSelectedArr = @[@10, @0, @0];
        }
        self.isAutoSelect = isAutoSelect;
        self.themeColor = themeColor;
        self.resultBlock = resultBlock;
        self.cancelBlock = cancelBlock;
        
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
        // 此处用 MJExtension 进行解析
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
    if (self.themeColor && [self.themeColor isKindOfClass:[UIColor class]]) {
        [self setupThemeColor:self.themeColor];
    }
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
    if (self.cancelBlock) {
        self.cancelBlock();
    }
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
// 1.指定pickerview有几个表盘
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// 2.指定每个表盘上有几行数据
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

#pragma mark - UIPickerViewDelegate
// 3.指定每行显示的内容（此处和tableview类似）
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *showTitleValue = nil;
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

// 4.选中时回调的委托方法，在此方法中实现省份和城市间的联动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //选中省份表盘时，根据row的值改变城市数组，刷新城市数组，实现联动
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

// 自定义 pickerView 的 label
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 35 * kScaleFit)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:18.0f * kScaleFit];
    // 字体自适应属性
    label.adjustsFontSizeToFitWidth = YES;
    // 自适应最小字体缩放比例
    label.minimumScaleFactor = 0.5f;
    // 调用上一个委托方法，获得要展示的title
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

#pragma mark - Tool
- (NSArray *)getChooseCityArr {
    NSArray *arr = nil;
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

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f * kScaleFit;
}

@end
