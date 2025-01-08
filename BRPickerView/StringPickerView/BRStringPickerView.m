//
//  BRStringPickerView.m
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRStringPickerView.h"

@interface BRStringPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    BOOL _dataSourceException; // 数据源格式是否有误
}
/** 选择器 */
@property (nonatomic, strong) UIPickerView *pickerView;
/** 单列选择的值 */
@property (nonatomic, copy) NSString *mSelectValue;
/** 多列选择的值 */
@property (nonatomic, copy) NSArray <NSString *>* mSelectValues;

/** 数据源 */
@property (nullable, nonatomic, copy) NSArray *mDataSourceArr;

@end

@implementation BRStringPickerView

#pragma mark - 1.显示【单列】选择器
+ (void)showPickerWithTitle:(NSString *)title
              dataSourceArr:(NSArray *)dataSourceArr
                selectIndex:(NSInteger)selectIndex
                resultBlock:(BRStringResultModelBlock)resultBlock {
    [self showPickerWithTitle:title dataSourceArr:dataSourceArr selectIndex:selectIndex isAutoSelect:NO resultBlock:resultBlock];
}

#pragma mark - 2.显示【单列】选择器
+ (void)showPickerWithTitle:(NSString *)title
              dataSourceArr:(NSArray *)dataSourceArr
                selectIndex:(NSInteger)selectIndex
               isAutoSelect:(BOOL)isAutoSelect
                resultBlock:(BRStringResultModelBlock)resultBlock {
    // 创建选择器
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

#pragma mark - 3.显示【多列】选择器
+ (void)showMultiPickerWithTitle:(NSString *)title
                   dataSourceArr:(NSArray *)dataSourceArr
                    selectIndexs:(NSArray <NSNumber *>*)selectIndexs
                     resultBlock:(BRStringResultModelArrayBlock)resultBlock {
    [self showMultiPickerWithTitle:title dataSourceArr:dataSourceArr selectIndexs:selectIndexs isAutoSelect:NO resultBlock:resultBlock];
}

#pragma mark - 4.显示【多列】选择器
+ (void)showMultiPickerWithTitle:(NSString *)title
                   dataSourceArr:(NSArray *)dataSourceArr
                    selectIndexs:(NSArray <NSNumber *>*)selectIndexs
                    isAutoSelect:(BOOL)isAutoSelect
                     resultBlock:(BRStringResultModelArrayBlock)resultBlock {
    // 创建选择器
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

#pragma mark - 5.显示【联动】选择器
+ (void)showLinkagePickerWithTitle:(nullable NSString *)title
                     dataSourceArr:(nullable NSArray *)dataSourceArr
                      selectIndexs:(nullable NSArray <NSNumber *> *)selectIndexs
                      isAutoSelect:(BOOL)isAutoSelect
                       resultBlock:(nullable BRStringResultModelArrayBlock)resultBlock {
    // 创建选择器
    BRStringPickerView *strPickerView = [[BRStringPickerView alloc]init];
    strPickerView.pickerMode = BRStringPickerComponentLinkage;
    strPickerView.title = title;
    strPickerView.dataSourceArr = dataSourceArr;
    strPickerView.selectIndexs = selectIndexs;
    strPickerView.isAutoSelect = isAutoSelect;
    strPickerView.resultModelArrayBlock = resultBlock;
    
    // 显示
    [strPickerView show];
}

#pragma mark - 初始化自定义选择器
- (instancetype)initWithPickerMode:(BRStringPickerMode)pickerMode {
    if (self = [super init]) {
        self.pickerMode = pickerMode;
    }
    return self;
}

#pragma mark - 处理选择器数据
- (void)handlerPickerData {
    if (self.dataSourceArr.count == 0) {
        _dataSourceException = YES;
    }
    id item = [self.dataSourceArr firstObject];
    if (self.pickerMode == BRStringPickerComponentSingle) {
        _dataSourceException = [item isKindOfClass:[NSArray class]];
    } else if (self.pickerMode == BRStringPickerComponentMulti) {
        _dataSourceException = [item isKindOfClass:[NSString class]];
    } else if (self.pickerMode == BRStringPickerComponentLinkage) {
        _dataSourceException = ![item isKindOfClass:[BRResultModel class]];
    }
    if (_dataSourceException) {
        NSAssert(!_dataSourceException, @"数据源异常！请检查选择器数据源的格式");
        return;
    }
    
    // 处理选择器当前选择的值
    if (self.pickerMode == BRStringPickerComponentSingle) {
        self.mDataSourceArr = self.dataSourceArr;
        NSInteger selectIndex = 0;
        if (self.selectIndex > 0 && self.selectIndex < self.mDataSourceArr.count) {
            selectIndex = self.selectIndex;
        } else {
            if (self.mSelectValue) {
                id item = [self.mDataSourceArr firstObject];
                if ([item isKindOfClass:[BRResultModel class]]) {
                    for (NSInteger i = 0; i < self.mDataSourceArr.count; i++) {
                        BRResultModel *model = self.mDataSourceArr[i];
                        if ([model.value isEqualToString:self.mSelectValue]) {
                            selectIndex = i;
                            break;
                        }
                    }
                } else {
                    if ([self.mDataSourceArr containsObject:self.mSelectValue]) {
                        selectIndex = [self.mDataSourceArr indexOfObject:self.mSelectValue];
                    }
                }
            }
        }
        self.selectIndex = selectIndex;
        
    } else if (self.pickerMode == BRStringPickerComponentMulti) {
        self.mDataSourceArr = self.dataSourceArr;
        NSMutableArray *selectIndexs = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < self.mDataSourceArr.count; i++) {
            NSArray *itemArr = self.mDataSourceArr[i];
            NSInteger row = 0;
            if (self.selectIndexs.count > 0) {
                if (i < self.selectIndexs.count) {
                    NSInteger index = [self.selectIndexs[i] integerValue];
                    row = ((index > 0 && index < itemArr.count) ? index : 0);
                }
            } else {
                if (self.mSelectValues.count > 0 && i < self.mSelectValues.count) {
                    NSString *value = self.mSelectValues[i];
                    id item = [itemArr firstObject];
                    if ([item isKindOfClass:[BRResultModel class]]) {
                        for (NSInteger j = 0; j < itemArr.count; j++) {
                            BRResultModel *model = itemArr[j];
                            if ([model.value isEqualToString:value]) {
                                row = j;
                                break;
                            }
                        }
                    } else {
                        if ([itemArr containsObject:value]) {
                            row = [itemArr indexOfObject:value];
                        }
                    }
                }
            }
            [selectIndexs addObject:@(row)];
        }
        self.selectIndexs = [selectIndexs copy];
        
    } else if (self.pickerMode == BRStringPickerComponentLinkage) {
        
        NSMutableArray *selectIndexs = [[NSMutableArray alloc]init];
        NSMutableArray *mDataSourceArr = [[NSMutableArray alloc]init];
        
        BRResultModel *selectModel = nil;
        BOOL hasNext = YES;
        NSInteger i = 0;

        NSMutableArray *dataArr = [self.dataSourceArr mutableCopy];
        
        do {
            NSArray *nextArr = [self getNextDataArr:dataArr selectModel:selectModel];
            // 设置 numberOfComponents，防止 key 等于 parentKey 时进入死循环
            if (nextArr.count == 0 || i > self.numberOfComponents - 1) {
                hasNext = NO;
                break;
            }
            
            NSInteger selectIndex = 0;
            if (self.selectIndexs.count > i && [self.selectIndexs[i] integerValue] < nextArr.count) {
                selectIndex = [self.selectIndexs[i] integerValue];
            }
            selectModel = nextArr[selectIndex];
            
            [selectIndexs addObject:@(selectIndex)];
            [mDataSourceArr addObject:nextArr];

            i++;
            
        } while (hasNext);
        
        self.selectIndexs = [selectIndexs copy];
        self.mDataSourceArr = [mDataSourceArr copy];
    }
}

- (NSArray <BRResultModel *>*)getNextDataArr:(NSArray *)dataArr selectModel:(BRResultModel *)selectModel {
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    // parentKey = @"-1"，表示是第一列数据
    NSString *key = selectModel ? selectModel.key : @"-1";
    for (BRResultModel *model in dataArr) {
        if ([model.parentKey isEqualToString:key]) {
            [tempArr addObject:model];
        }
    }
    return [tempArr copy];
}

#pragma mark - 选择器
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
        case BRStringPickerComponentSingle:
            return 1;
            break;
        case BRStringPickerComponentMulti:
        case BRStringPickerComponentLinkage:
            return self.mDataSourceArr.count;
            break;
            
        default:
            break;
    }
}

// 2.设置 pickerView 每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.pickerMode) {
        case BRStringPickerComponentSingle:
            return self.mDataSourceArr.count;
            break;
        case BRStringPickerComponentMulti:
        case BRStringPickerComponentLinkage:
        {
            NSArray *itemArr = self.mDataSourceArr[component];
            return itemArr.count;
        }
            break;
            
        default:
            break;
    }
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
    if (self.pickerMode == BRStringPickerComponentSingle) {
        id item = self.mDataSourceArr[row];
        if ([item isKindOfClass:[BRResultModel class]]) {
            BRResultModel *model = (BRResultModel *)item;
            label.text = model.value;
        } else {
            label.text = item;
        }
    } else if (self.pickerMode == BRStringPickerComponentMulti || self.pickerMode == BRStringPickerComponentLinkage) {
        NSArray *itemArr = self.mDataSourceArr[component];
        id item = [itemArr objectAtIndex:row];
        if ([item isKindOfClass:[BRResultModel class]]) {
            BRResultModel *model = (BRResultModel *)item;
            label.text = model.value;
        } else {
            label.text = item;
        }
    }
    
    // 2.设置选择器中间选中行的样式
    [self.pickerStyle setupPickerSelectRowStyle:pickerView titleForRow:row forComponent:component];
    
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
        case BRStringPickerComponentLinkage:
        {
            if (component < self.selectIndexs.count) {
                NSMutableArray *selectIndexs = [[NSMutableArray alloc]init];
                for (NSInteger i = 0; i < self.selectIndexs.count; i++) {
                    if (i < component) {
                        [selectIndexs addObject:self.selectIndexs[i]];
                    } else if (i == component) {
                        [selectIndexs addObject:@(row)];
                    } else {
                        [selectIndexs addObject:@(0)];
                    }
                }
                self.selectIndexs = [selectIndexs copy];
            }
            
            // 刷新选择器数据
            [self reloadData];
            
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
    id item = self.selectIndex < self.mDataSourceArr.count ? self.mDataSourceArr[self.selectIndex] : nil;
    if ([item isKindOfClass:[BRResultModel class]]) {
        BRResultModel *model = (BRResultModel *)item;
        model.index = self.selectIndex;
        return model;
    } else {
        BRResultModel *model = [[BRResultModel alloc]init];
        model.index = self.selectIndex;
        model.value = item;
        return model;
    }
}

#pragma mark - 获取【多列】选择器选择的值
- (NSArray *)getResultModelArr {
    NSMutableArray *resultModelArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < self.mDataSourceArr.count; i++) {
        NSInteger index = [self.selectIndexs[i] integerValue];
        NSArray *dataArr = self.mDataSourceArr[i];
        
        id item = index < dataArr.count ? dataArr[index] : nil;
        if ([item isKindOfClass:[BRResultModel class]]) {
            BRResultModel *model = (BRResultModel *)item;
            model.index = index;
            [resultModelArr addObject:model];
        } else {
            BRResultModel *model = [[BRResultModel alloc]init];
            model.index = index;
            model.value = item;
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
    } else if (self.pickerMode == BRStringPickerComponentMulti || self.pickerMode == BRStringPickerComponentLinkage) {
        for (NSInteger i = 0; i < self.selectIndexs.count; i++) {
            NSNumber *index = [self.selectIndexs objectAtIndex:i];
            [self.pickerView selectRow:[index integerValue] inComponent:i animated:NO];
        }
    }
}

- (void)addPickerToView:(UIView *)view {
    // 1.添加选择器
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
        if (weakSelf.pickerMode == BRStringPickerComponentSingle) {
            if (weakSelf.resultModelBlock) {
                weakSelf.resultModelBlock([weakSelf getResultModel]);
            }
        } else if (weakSelf.pickerMode == BRStringPickerComponentMulti || weakSelf.pickerMode == BRStringPickerComponentLinkage) {
            if (weakSelf.resultModelArrayBlock) {
                weakSelf.resultModelArrayBlock([weakSelf getResultModelArr]);
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
- (NSArray *)mDataSourceArr {
    if (!_mDataSourceArr) {
        _mDataSourceArr = [NSArray array];
    }
    return _mDataSourceArr;
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

- (NSInteger)numberOfComponents {
    if (_numberOfComponents <= 0) {
        _numberOfComponents = 3;
    }
    return _numberOfComponents;
}

@end
