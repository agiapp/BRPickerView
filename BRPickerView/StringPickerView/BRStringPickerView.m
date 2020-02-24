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
    BOOL _invalidDataSource; // 数据源格式是否有误
}
/** 字符串选择器 */
@property (nonatomic, strong) UIPickerView *pickerView;
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
    // 创建字符串选择器
    BRStringPickerView *strPickerView = [[BRStringPickerView alloc]init];
    strPickerView.pickerMode = BRStringPickerComponentSingle;
    strPickerView.title = title;
    strPickerView.dataSourceArr = dataSourceArr;
    strPickerView.selectIndex = selectIndex;
    strPickerView.isAutoSelect = isAutoSelect;
    strPickerView.resultModelBlock = resultBlock;
    
    // 显示
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
    // 创建字符串选择器
    BRStringPickerView *strPickerView = [[BRStringPickerView alloc]init];
    strPickerView.pickerMode = BRStringPickerComponentMulti;
    strPickerView.title = title;
    strPickerView.dataSourceArr = dataSourceArr;
    strPickerView.selectIndexs = selectIndexs;
    strPickerView.isAutoSelect = isAutoSelect;
    strPickerView.resultModelArrayBlock = resultBlock;
    
    // 显示
    [strPickerView show];
}

#pragma mark - 初始化自定义字符串选择器
- (instancetype)initWithPickerMode:(BRStringPickerMode)pickerMode {
    if (self = [super init]) {
        self.pickerMode = pickerMode;
    }
    return self;
}

#pragma mark - 处理选择器数据
- (void)handlerPickerData {
    if (self.dataSourceArr.count == 0) {
        _invalidDataSource = YES;
    }
    if (self.pickerMode == BRStringPickerComponentSingle) {
        id element = [self.dataSourceArr firstObject];
        if ([element isKindOfClass:[NSArray class]]) {
            _invalidDataSource = YES;
        }
    } else if (self.pickerMode == BRStringPickerComponentMulti) {
        id element = [self.dataSourceArr firstObject];
        if ([element isKindOfClass:[NSString class]]) {
            _invalidDataSource = YES;
        }
    }
    
    if (_invalidDataSource) {
        NSAssert(!_invalidDataSource, @"无效数据源！请检查字符串选择器数据源的格式");
        return;
    }
    
    // 处理选择器当前选择的值
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
            [mSelectIndexs addObject:@(row)];
        }
        self.selectIndexs = [mSelectIndexs copy];
    }
}

#pragma mark - 字符串选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight + pickerHeaderViewHeight, SCREEN_WIDTH, self.pickerStyle.pickerHeight)];
        if (self.pickerStyle.selectRowColor) {
            _pickerView.backgroundColor = [UIColor clearColor];
        } else {
            _pickerView.backgroundColor = self.pickerStyle.pickerColor;
        }
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource
// 1.设置 pickerView 的列数
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

// 2.设置 pickerView 每列的行数
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
// 3.设置 pickerView 的显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    // 设置分割线的颜色
    for (UIView *subView in pickerView.subviews) {
        if (subView && [subView isKindOfClass:[UIView class]] && subView.frame.size.height <= 1) {
            subView.backgroundColor = self.pickerStyle.separatorColor;
        }
    }
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.pickerStyle.pickerTextColor;
        label.font = self.pickerStyle.pickerTextFont;
        // 字体自适应属性
        label.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        label.minimumScaleFactor = 0.5f;
    }
    if (self.pickerMode == BRStringPickerComponentSingle) {
        label.frame = CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerStyle.rowHeight);
        id element = self.dataSourceArr[row];
        if ([element isKindOfClass:[BRResultModel class]]) {
            BRResultModel *model = (BRResultModel *)element;
            label.text = model.value;
        } else {
            label.text = element;
        }
    } else if (self.pickerMode == BRStringPickerComponentMulti) {
        label.frame = CGRectMake(0, 0, self.pickerView.frame.size.width / pickerView.numberOfComponents, self.pickerStyle.rowHeight);
        id element = self.dataSourceArr[component][row];
        if ([element isKindOfClass:[BRResultModel class]]) {
            BRResultModel *model = (BRResultModel *)element;
            label.text = model.value;
        } else {
            label.text = element;
        }
    }
    
    return label;
}

// 4.滚动 pickerView 执行的回调方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.pickerMode) {
        case BRStringPickerComponentSingle:
        {
            self.selectIndex = row;
            
            // 滚动选择时执行 changeModelBlock
            if (self.changeModelBlock) {
                self.changeModelBlock([self getResultModel]);
            }
            
            // 设置自动选择时，滚动选择时就执行 resultModelBlock
            if (self.isAutoSelect) {
                if (self.resultModelBlock) {
                    self.resultModelBlock([self getResultModel]);
                }
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
            
            // 滚动选择时执行 changeModelArrayBlock
            if (self.changeModelArrayBlock) {
                self.changeModelArrayBlock([self getResultModelArr]);
            }
            
            // 设置自动选择时，滚动选择时就执行 resultModelArrayBlock
            if (self.isAutoSelect) {
                if (self.resultModelArrayBlock) {
                    self.resultModelArrayBlock([self getResultModelArr]);
                }
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 获取【单列】选择器选择的值
- (BRResultModel *)getResultModel {
    id element = self.selectIndex < self.dataSourceArr.count ? self.dataSourceArr[self.selectIndex] : nil;
    if ([element isKindOfClass:[BRResultModel class]]) {
        BRResultModel *model = (BRResultModel *)element;
        model.index = self.selectIndex;
        return model;
    } else {
        BRResultModel *model = [[BRResultModel alloc]init];
        model.index = self.selectIndex;
        model.value = element;
        return model;
    }
}

#pragma mark - 获取【多列】选择器选择的值
- (NSArray *)getResultModelArr {
    NSMutableArray *resultModelArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < self.selectIndexs.count; i++) {
        NSInteger index = [self.selectIndexs[i] integerValue];
        NSArray *dataArr = self.dataSourceArr[i];
        
        id element = index < dataArr.count ? dataArr[index] : nil;
        if ([element isKindOfClass:[BRResultModel class]]) {
            BRResultModel *model = (BRResultModel *)element;
            model.index = index;
            [resultModelArr addObject:model];
        } else {
            BRResultModel *model = [[BRResultModel alloc]init];
            model.index = index;
            model.value = element;
            [resultModelArr addObject:model];
        }
    }
    return [resultModelArr copy];
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
    // 3.滚动到选择的值
    if (self.pickerMode == BRStringPickerComponentSingle) {
        [self.pickerView selectRow:self.selectIndex inComponent:0 animated:NO];
    } else if (self.pickerMode == BRStringPickerComponentMulti) {
        for (NSInteger i = 0; i < self.selectIndexs.count; i++) {
            NSNumber *index = [self.selectIndexs objectAtIndex:i];
            [self.pickerView selectRow:[index integerValue] inComponent:i animated:NO];
        }
    }
}

- (void)addPickerToView:(UIView *)view {
    // 1.添加字符串选择器
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
        [self.alertView addSubview:self.pickerView];
    }
    
    // 2.绑定数据
    [self reloadData];
    
    @weakify(self)
    self.doneBlock = ^{
        @strongify(self)
        // 点击确定按钮后，执行block回调
        [self removePickerFromView:view];
        
        if (self.pickerMode == BRStringPickerComponentSingle) {
            if (self.resultModelBlock) {
                self.resultModelBlock([self getResultModel]);
            }
        } else if (self.pickerMode == BRStringPickerComponentMulti) {
            if (self.resultModelArrayBlock) {
                self.resultModelArrayBlock([self getResultModelArr]);
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

#pragma mark - getter 方法
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
