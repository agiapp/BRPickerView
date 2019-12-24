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
/** 字符串选择器 */
@property (nonatomic, strong) UIPickerView *pickerView;
/** 字符串选择器类型 */
@property (nonatomic, assign) BRStringPickerMode pickerMode;
/** 单列选择的值 */
@property (nonatomic, copy) NSString *mSelectValue;
/** 多列选择的值 */
@property (nonatomic, copy) NSArray <NSString *>* mSelectValues;

@end

@implementation BRStringPickerView

#pragma mark - 1.显示【单列】字符串选择器
+ (void)showPickerWithTitle:(NSString *)title
              dataSourceArr:(NSArray *)dataSourceArr
                selectIndex:(NSInteger)selectIndex
                resultBlock:(BRStringResultModelBlock)resultBlock {
    [self showPickerWithTitle:title dataSourceArr:dataSourceArr selectIndex:selectIndex isAutoSelect:NO resultBlock:resultBlock];
}

#pragma mark - 2.显示【单列】字符串选择器
+ (void)showPickerWithTitle:(NSString *)title
              dataSourceArr:(NSArray *)dataSourceArr
                selectIndex:(NSInteger)selectIndex
               isAutoSelect:(BOOL)isAutoSelect
                resultBlock:(BRStringResultModelBlock)resultBlock {
    BRStringPickerView *strPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
    strPickerView.title = title;
    strPickerView.dataSourceArr = dataSourceArr;
    strPickerView.selectIndex = selectIndex;
    strPickerView.isAutoSelect = isAutoSelect;
    strPickerView.resultModelBlock = resultBlock;
    
    [strPickerView show];
}

#pragma mark - 3.显示【多列】字符串选择器
+ (void)showMultiPickerWithTitle:(NSString *)title
                   dataSourceArr:(NSArray *)dataSourceArr
                    selectIndexs:(NSArray <NSNumber *>*)selectIndexs
                     resultBlock:(BRStringResultModelArrayBlock)resultBlock {
    [self showMultiPickerWithTitle:title dataSourceArr:dataSourceArr selectIndexs:selectIndexs isAutoSelect:NO resultBlock:resultBlock];
}

#pragma mark - 4.显示【多列】字符串选择器
+ (void)showMultiPickerWithTitle:(NSString *)title
                   dataSourceArr:(NSArray *)dataSourceArr
                    selectIndexs:(NSArray <NSNumber *>*)selectIndexs
                    isAutoSelect:(BOOL)isAutoSelect
                     resultBlock:(BRStringResultModelArrayBlock)resultBlock {
    BRStringPickerView *strPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentMulti];
    strPickerView.title = title;
    strPickerView.dataSourceArr = dataSourceArr;
    strPickerView.selectIndexs = selectIndexs;
    strPickerView.isAutoSelect = isAutoSelect;
    strPickerView.resultModelArrayBlock = resultBlock;
    
    [strPickerView show];
}

#pragma mark - 初始化自定义字符串选择器
- (instancetype)initWithPickerMode:(BRStringPickerMode)pickerMode {
    if (self = [super init]) {
        self.pickerMode = pickerMode;
        self.isAutoSelect = NO;
    }
    return self;
}

#pragma mark - setter 方法
- (void)setPlistName:(NSString *)plistName {
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
    if (path && path.length > 0) {
        self.dataSourceArr = [[NSArray alloc] initWithContentsOfFile:path];
    }
}

- (void)setSelectValue:(NSString *)selectValue {
    self.mSelectValue = selectValue;
}

- (void)setSelectValues:(NSArray<NSString *> *)selectValues {
    self.mSelectValues = selectValues;
}

#pragma mark - 设置默认选择的值
- (void)handlerDefaultSelectValue {
    if (self.dataSourceArr.count == 0) {
        return;
    }
    // 给选择器设置默认值
    if (self.pickerMode == BRStringPickerComponentSingle) {
        if (self.selectIndex > 0) {
            self.selectIndex = (self.selectIndex < self.dataSourceArr.count ? self.selectIndex : 0);
        } else {
            if (self.mSelectValue && [self.dataSourceArr containsObject:self.mSelectValue]) {
                self.selectIndex = [self.dataSourceArr indexOfObject:self.mSelectValue];
            } else {
                self.selectIndex = 0;
            }
        }
        [self.pickerView selectRow:self.selectIndex inComponent:0 animated:NO];
        
    } else if (self.pickerMode == BRStringPickerComponentMulti) {
        NSMutableArray *mSelectIndexs = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < self.dataSourceArr.count; i++) {
            NSInteger row = 0;
            if (self.selectIndexs.count > 0) {
                if (i < self.selectIndexs.count) {
                    NSInteger index = [self.selectIndexs[i] integerValue];
                    row = ((index > 0 && index < [self.dataSourceArr[i] count]) ? index : 0);
                }
            } else {
                if (self.mSelectValues.count > 0 && i < self.mSelectValues.count) {
                    NSString *value = self.mSelectValues[i];
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
    switch (self.pickerMode) {
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
    switch (self.pickerMode) {
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
    switch (self.pickerMode) {
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
    if (self.pickerMode == BRStringPickerComponentSingle) {
        label.frame = CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerStyle.rowHeight);
        label.text = self.dataSourceArr[row];
    } else if (self.pickerMode == BRStringPickerComponentMulti) {
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
    if (self.resultModelBlock) {
        BRResultModel *resultModel = [[BRResultModel alloc]init];
        resultModel.index = self.selectIndex;
        resultModel.name = self.selectIndex < self.dataSourceArr.count ? self.dataSourceArr[self.selectIndex] : nil;
        self.resultModelBlock(resultModel);
    }
}

#pragma mark - 处理多列选择结果的回调
- (void)handlerResultModelArrayBlock {
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
            if (self.pickerMode == BRStringPickerComponentSingle) {
                
                [self handlerResultModelBlock];
                
            } else if (self.pickerMode == BRStringPickerComponentMulti) {
                
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

- (NSArray<NSString *> *)mSelectValues {
    if (!_mSelectValues) {
        _mSelectValues = [NSArray array];
    }
    return _mSelectValues;
}

@end
