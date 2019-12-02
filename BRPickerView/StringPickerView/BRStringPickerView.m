//
//  BRStringPickerView.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRStringPickerView.h"

@interface BRStringPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    BOOL _isDataSourceValid; // 数据源是否合法
}
/** 字符串选择器 */
@property (nonatomic, strong) UIPickerView *pickerView;
/** 字符串选择器类型 */
@property (nonatomic, assign) BRStringPickerMode showType;
/** 选择结果的回调 */
@property (nonatomic, copy) BRStringResultBlock resultBlock;
/** 单列选择的值 */
@property (nonatomic, copy) NSString *currentSelectValue;
/** 多列选择的值 */
@property (nonatomic, copy) NSArray <NSString *>* currentSelectValues;

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
        [strPickerView show];
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
        [strPickerView show];
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
            self.currentSelectValue = defaultSelValue;
        } else if ([[self.dataSourceArr firstObject] isKindOfClass:[NSArray class]]) {
            self.showType = BRStringPickerComponentMulti;
            self.currentSelectValues = defaultSelValue;
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
    
    return dataArr;
}

#pragma mark - setter 方法
- (void)setPlistName:(NSString *)plistName {
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
    if (path && path.length > 0) {
        self.dataSourceArr = [[NSArray alloc] initWithContentsOfFile:path];
    }
}

- (void)setSelectValue:(NSString *)selectValue {
    self.currentSelectValue = selectValue;
}

- (void)setSelectValueArr:(NSArray<NSString *> *)selectValueArr {
    self.currentSelectValues = selectValueArr;
}

#pragma mark - 设置默认选择的值
- (void)handlerDefaultSelectValue {
    if (self.dataSourceArr.count == 0) {
        return;
    }
    // 给选择器设置默认值
    if (self.showType == BRStringPickerComponentSingle) {
        if (self.selectIndex > 0) {
            self.selectIndex = (self.selectIndex < self.dataSourceArr.count ? self.selectIndex : 0);
        } else {
            if (self.currentSelectValue && [self.dataSourceArr containsObject:self.currentSelectValue]) {
                self.selectIndex = [self.dataSourceArr indexOfObject:self.currentSelectValue];
            } else {
                self.selectIndex = 0;
            }
        }
        [self.pickerView selectRow:self.selectIndex inComponent:0 animated:NO];
        
    } else if (self.showType == BRStringPickerComponentMulti) {
        NSMutableArray *mSelectIndexs = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < self.dataSourceArr.count; i++) {
            NSInteger row = 0;
            if (self.selectIndexs.count > 0) {
                if (i < self.selectIndexs.count) {
                    NSInteger index = [self.selectIndexs[i] integerValue];
                    row = ((index > 0 && index < [self.dataSourceArr[i] count]) ? index : 0);
                }
            } else {
                if (self.currentSelectValues.count > 0 && i < self.currentSelectValues.count) {
                    NSString *value = self.currentSelectValues[i];
                    if ([self.dataSourceArr[i] containsObject:value]) {
                        row = [self.dataSourceArr[i] indexOfObject:value];
                    }
                }
            }
            [self.pickerView selectRow:row inComponent:i animated:NO];
            [mSelectIndexs addObject:@(row)];
        }
        
        self.selectIndexs = [mSelectIndexs copy];
    }
}

#pragma mark - 字符串选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight, SCREEN_WIDTH, self.pickerStyle.pickerHeight)];
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
            self.selectIndex = row;
            // 设置是否自动回调
            if (self.isAutoSelect) {
                [self handlerResultModelBlock];
            }
        }
            break;
        case BRStringPickerComponentMulti:
        {
            if (component < self.selectIndexs.count) {
                NSMutableArray *mutableArr = [self.selectIndexs mutableCopy];
                [mutableArr replaceObjectAtIndex:component withObject:@(row)];
                self.selectIndexs = [mutableArr copy];
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
    
    // 设置分割线的颜色
    for (UIView *subView in pickerView.subviews) {
        if (subView && [subView isKindOfClass:[UIView class]] && subView.frame.size.height <= 1) {
            subView.backgroundColor = self.pickerStyle.separatorColor;
        }
    }
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.pickerStyle.pickerTextColor;
    label.font = self.pickerStyle.pickerTextFont;
    // 字体自适应属性
    label.adjustsFontSizeToFitWidth = YES;
    // 自适应最小字体缩放比例
    label.minimumScaleFactor = 0.5f;
    if (self.showType == BRStringPickerComponentSingle) {
        label.frame = CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerStyle.rowHeight);
        label.text = self.dataSourceArr[row];
    } else if (self.showType == BRStringPickerComponentMulti) {
        label.frame = CGRectMake(0, 0, self.pickerView.frame.size.width / pickerView.numberOfComponents, self.pickerStyle.rowHeight);
        label.text = self.dataSourceArr[component][row];
    }
    
    return label;
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.pickerStyle.rowHeight;
}

#pragma mark - 处理单列选择结果的回调
- (void)handlerResultModelBlock {
    // 1.用法一 的回调
    if (self.resultModelBlock) {
        BRResultModel *resultModel = [[BRResultModel alloc]init];
        resultModel.index = self.selectIndex;
        resultModel.name = self.selectIndex < self.dataSourceArr.count ? self.dataSourceArr[self.selectIndex] : nil;
        self.resultModelBlock(resultModel);
    }
    
    // 2.用法二 的回调（兼容旧版本）
    if(self.resultBlock) {
        NSString *selectValue = self.selectIndex < self.dataSourceArr.count ? self.dataSourceArr[self.selectIndex] : nil;
        self.resultBlock(selectValue);
    }
}

#pragma mark - 处理多列选择结果的回调
- (void)handlerResultModelArrayBlock {
    // 1.用法一 的回调
    if (self.resultModelArrayBlock) {
        NSMutableArray *resultModelArr = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < self.selectIndexs.count; i++) {
            NSInteger index = [self.selectIndexs[i] integerValue];
            NSArray *dataArr = self.dataSourceArr[i];
            BRResultModel *resultModel = [[BRResultModel alloc]init];
            resultModel.index = index;
            resultModel.name = index < dataArr.count ? dataArr[index] : nil;
            [resultModelArr addObject:resultModel];
        }
        self.resultModelArrayBlock([resultModelArr copy]);
    }
    
    // 2.用法二 的回调（兼容旧版本）
    if(self.resultBlock) {
        NSMutableArray *mSelectValueArr = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < self.selectIndexs.count; i++) {
            NSInteger index = [self.selectIndexs[i] integerValue];
            NSArray *dataArr = self.dataSourceArr[i];
            NSString *selectValue = index < dataArr.count ? dataArr[index] : nil;
            [mSelectValueArr addObject:selectValue];
        }
        self.resultBlock([mSelectValueArr copy]);
    }
    
}

#pragma mark - 重写父类方法
- (void)addPickerToView:(UIView *)view {
    [self handlerDefaultSelectValue];
    // 添加字符串选择器
    [self setPickerView:self.pickerView toView:view];
    
    @weakify(self)
    self.doneBlock = ^{
        @strongify(self)
        // 点击确定按钮后，执行block回调
        [self removePickerFromView:view];
        
        if (!self.isAutoSelect) {
            if (self.showType == BRStringPickerComponentSingle) {
                
                [self handlerResultModelBlock];
                
            } else if (self.showType == BRStringPickerComponentMulti) {
                
                [self handlerResultModelArrayBlock];
                
            }
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

- (NSArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSArray array];
    }
    return _dataSourceArr;
}

- (NSArray<NSNumber *> *)selectIndexs {
    if (!_selectIndexs) {
        _selectIndexs = [NSArray array];
    }
    return _selectIndexs;
}

- (NSArray<NSString *> *)currentSelectValues {
    if (!_currentSelectValues) {
        _currentSelectValues = [NSArray array];
    }
    return _currentSelectValues;
}

@end
