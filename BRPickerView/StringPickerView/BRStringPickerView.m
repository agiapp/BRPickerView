//
//  BRStringPickerView.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRStringPickerView.h"
#import "BRPickerViewMacro.h"

@interface BRStringPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    BOOL _isDataSourceValid; // 数据源是否合法
}
// 字符串选择器
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) BRStringPickerMode showType;
/** 选择结果的回调 */
@property (nonatomic, copy) BRStringResultBlock resultBlock;

@end

@implementation BRStringPickerView

#pragma mark - 1.显示自定义字符串选择器
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                      resultBlock:(BRStringResultBlock)resultBlock {
    BRStringPickerView *strPickerView = [[BRStringPickerView alloc]initWithTitle:title dataSource:dataSource defaultSelValue:defaultSelValue isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil];
    NSAssert(strPickerView->_isDataSourceValid, @"数据源不合法！请检查字符串选择器数据源的格式");
    if (strPickerView->_isDataSourceValid) {
        [strPickerView showWithAnimation:YES toView:nil];
    }
}

#pragma mark - 2.显示自定义字符串选择器（支持 设置自动选择 和 自定义主题颜色）
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                       themeColor:(UIColor *)themeColor
                      resultBlock:(BRStringResultBlock)resultBlock {
    [self showStringPickerWithTitle:title dataSource:dataSource defaultSelValue:defaultSelValue isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 3.显示自定义字符串选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                       themeColor:(UIColor *)themeColor
                      resultBlock:(BRStringResultBlock)resultBlock
                      cancelBlock:(BRCancelBlock)cancelBlock {
    BRStringPickerView *strPickerView = [[BRStringPickerView alloc]initWithTitle:title dataSource:dataSource defaultSelValue:defaultSelValue isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    NSAssert(strPickerView->_isDataSourceValid, @"数据源不合法！请检查字符串选择器数据源的格式");
    if (strPickerView->_isDataSourceValid) {
        [strPickerView showWithAnimation:YES toView:nil];
    }
}

#pragma mark - 初始化自定义字符串选择器
- (instancetype)initWithPickerMode:(BRStringPickerMode)pickerMode {
    if (self = [super init]) {
        self.showType = pickerMode;
        self.isAutoSelect = NO;
        _isDataSourceValid = YES;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                   dataSource:(id)dataSource
              defaultSelValue:(id)defaultSelValue
                 isAutoSelect:(BOOL)isAutoSelect
                   themeColor:(UIColor *)themeColor
                  resultBlock:(BRStringResultBlock)resultBlock
                  cancelBlock:(BRCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.title = title;
        self.dataSourceArr = [self getDataSourceArr:dataSource];
        if ([[self.dataSourceArr firstObject] isKindOfClass:[NSString class]]) {
            self.showType = BRStringPickerComponentSingle;
            self.selectValue = defaultSelValue;
        } else if ([[self.dataSourceArr firstObject] isKindOfClass:[NSArray class]]) {
            self.showType = BRStringPickerComponentMulti;
            self.selectValueArr = defaultSelValue;
        }
        
        self.isAutoSelect = isAutoSelect;
        
        // 兼容旧版本，快速设置主题样式
        if (themeColor && [themeColor isKindOfClass:[UIColor class]]) {
            self.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:themeColor];
        }
        
        self.resultBlock = resultBlock;
        self.cancelBlock = cancelBlock;
        _isDataSourceValid = YES;
    }
    return self;
}

- (NSArray *)getDataSourceArr:(id)dataSource {
    // 1.先判断传入的数据源是否合法
    if (!dataSource) {
        _isDataSourceValid = NO;
    }
    NSArray *dataArr = nil;
    if ([dataSource isKindOfClass:[NSArray class]] && [dataSource count] > 0) {
        dataArr = [NSArray arrayWithArray:dataSource];
    } else if ([dataSource isKindOfClass:[NSString class]] && [dataSource length] > 0) {
        NSString *plistName = dataSource;
        NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
        dataArr = [[NSArray alloc] initWithContentsOfFile:path];
        if (!dataArr || dataArr.count == 0) {
            _isDataSourceValid = NO;
        }
    } else {
        _isDataSourceValid = NO;
    }
    // 判断数组是否合法（即数组的所有元素是否是同一种数据类型）
    if (_isDataSourceValid) {
        Class itemClass = [[dataArr firstObject] class];
        for (id obj in dataArr) {
            if (![obj isKindOfClass:itemClass]) {
                _isDataSourceValid = NO;
                break;
            }
        }
    }
    
    return dataArr;
}

- (void)setPlistName:(NSString *)plistName {
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
    self.dataSourceArr = [[NSArray alloc] initWithContentsOfFile:path];
}

#pragma mark - 设置默认选择的值
- (void)handlerDefaultSelectData {
    if (self.dataSourceArr.count == 0) {
        return;
    }
    // 给选择器设置默认值
    if (self.showType == BRStringPickerComponentSingle) {
        if (!self.selectValue || ![self.dataSourceArr containsObject:self.selectValue]) {
            self.selectValue = [self.dataSourceArr firstObject];
        }
        NSInteger row = [self.dataSourceArr indexOfObject:self.selectValue];
        // 默认滚动的行
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    } else if (self.showType == BRStringPickerComponentMulti) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSInteger i = 0; i < self.dataSourceArr.count; i++) {
            NSString *selValue = nil;
            if (self.selectValueArr && self.selectValueArr.count > 0 && i < self.selectValueArr.count && [self.dataSourceArr[i] containsObject:self.selectValueArr[i]]) {
                [tempArr addObject:self.selectValueArr[i]];
                selValue = self.selectValueArr[i];
            } else {
                [tempArr addObject:[self.dataSourceArr[i] firstObject]];
                selValue = [self.dataSourceArr[i] firstObject];
            }
            NSInteger row = [self.dataSourceArr[i] indexOfObject:selValue];
            // 默认滚动的行
            [self.pickerView selectRow:row inComponent:i animated:NO];
        }
        self.selectValueArr = tempArr;
    }
}

#pragma mark - 字符串选择器
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
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.showType) {
        case BRStringPickerComponentSingle:
            return 1;
            break;
        case BRStringPickerComponentMulti:
            return self.dataSourceArr.count;
            break;
            
        default:
            break;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.showType) {
        case BRStringPickerComponentSingle:
            return self.dataSourceArr.count;
            break;
        case BRStringPickerComponentMulti:
            return [self.dataSourceArr[component] count];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.showType) {
        case BRStringPickerComponentSingle:
        {
            self.selectValue = self.dataSourceArr[row];
            // 设置是否自动回调
            if (self.isAutoSelect) {
                [self handlerResultModelBlock];
            }
        }
            break;
        case BRStringPickerComponentMulti:
        {
            if (component < self.selectValueArr.count) {
                NSMutableArray *mutableArr = [self.selectValueArr mutableCopy];
                [mutableArr replaceObjectAtIndex:component withObject:self.dataSourceArr[component][row]];
                self.selectValueArr = [mutableArr copy];
            }
            
            // 设置是否自动回调
            if (self.isAutoSelect) {
                [self handlerResultModelArrayBlock];
            }
        }
            break;
            
        default:
            break;
    }
}

// 自定义 pickerView 的 label
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    //设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = self.pickerStyle.separatorColor;
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = self.pickerStyle.separatorColor;
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.pickerStyle.pickerTextColor;
    label.font = [UIFont systemFontOfSize:18.0f * kScaleFit];
    // 字体自适应属性
    label.adjustsFontSizeToFitWidth = YES;
    // 自适应最小字体缩放比例
    label.minimumScaleFactor = 0.5f;
    if (self.showType == BRStringPickerComponentSingle) {
        label.frame = CGRectMake(0, 0, self.pickerView.frame.size.width, 35.0f * kScaleFit);
        label.text = self.dataSourceArr[row];
    } else if (self.showType == BRStringPickerComponentMulti) {
        label.frame = CGRectMake(0, 0, self.pickerView.frame.size.width / pickerView.numberOfComponents, 35.0f * kScaleFit);
        label.text = self.dataSourceArr[component][row];
    }
    
    return label;
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f * kScaleFit;
}

#pragma mark - 处理单列选择结果的回调
- (void)handlerResultModelBlock {
    // 1.使用方式一的回调
    if (self.resultModelBlock) {
        BRResultModel *resultModel = [[BRResultModel alloc]init];
        resultModel.selectValue = self.selectValue;
        resultModel.index = [self.dataSourceArr indexOfObject:self.selectValue];
        self.resultModelBlock(resultModel);
    }
    
    // 2.使用方式二的回调（兼容旧版本）
    if(self.resultBlock) {
        self.resultBlock(self.selectValue);
    }
    
}

#pragma mark - 处理多列选择结果的回调
- (void)handlerResultModelArrayBlock {
    // 1.使用方式一的回调
    if (self.resultModelArrayBlock) {
        NSMutableArray *resultModelArr = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < self.selectValueArr.count; i++) {
            NSString *selectValue = self.selectValueArr[i];
            NSArray *dataArr = self.dataSourceArr[i];
            
            BRResultModel *resultModel = [[BRResultModel alloc]init];
            resultModel.selectValue = selectValue;
            resultModel.index = [dataArr indexOfObject:selectValue];
            
            [resultModelArr addObject:resultModel];
        }
        self.resultModelArrayBlock([resultModelArr copy]);
    }
    
    // 2.使用方式二的回调（兼容旧版本）
    if(self.resultBlock) {
        self.resultBlock(self.selectValueArr);
    }
    
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation toView:(UIView *)view {
    [self handlerDefaultSelectData];
    // 添加字符串选择器
    [self setPickerView:self.pickerView toView:view];
    
    @weakify(self)
    self.doneBlock = ^{
        @strongify(self)
        // 点击确定按钮后，执行block回调
        [self dismissWithAnimation:animation toView:view];
        
        if (!self.isAutoSelect) {
            if (self.showType == BRStringPickerComponentSingle) {
                
                [self handlerResultModelBlock];
                
            } else if (self.showType == BRStringPickerComponentMulti) {
                
                [self handlerResultModelArrayBlock];
                
            }
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

- (NSArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSArray array];
    }
    return _dataSourceArr;
}

- (NSArray<NSString *> *)selectValueArr {
    if (!_selectValueArr) {
        _selectValueArr = [[NSArray alloc]init];
    }
    return _selectValueArr;
}


@end
