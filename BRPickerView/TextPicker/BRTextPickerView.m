//
//  BRTextPickerView.m
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//
//  最新代码下载地址：https://github.com/agiapp/BRPickerView

#import "BRTextPickerView.h"

@interface BRTextPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
/** 选择器 */
@property (nonatomic, strong) UIPickerView *pickerView;
/** 当前显示的数据源 */
@property (nonatomic, copy) NSArray *dataList;

// 记录滚动中的位置
@property(nonatomic, assign) NSInteger rollingComponent;
@property(nonatomic, assign) NSInteger rollingRow;

@end

@implementation BRTextPickerView

#pragma mark - 1.显示【单列】选择器
+ (void)showPickerWithTitle:(NSString *)title
              dataSourceArr:(NSArray *)dataSourceArr
                selectIndex:(NSInteger)selectIndex
                resultBlock:(BRSingleResultBlock)resultBlock {
    // 创建选择器
    BRTextPickerView *strPickerView = [[BRTextPickerView alloc]init];
    strPickerView.pickerMode = BRTextPickerComponentSingle;
    strPickerView.title = title;
    strPickerView.dataSourceArr = dataSourceArr;
    strPickerView.selectIndex = selectIndex;
    strPickerView.singleResultBlock = resultBlock;
    
    // 显示
    [strPickerView show];
}

#pragma mark - 2.显示【多列】选择器
+ (void)showMultiPickerWithTitle:(NSString *)title
                   dataSourceArr:(NSArray *)dataSourceArr
                    selectIndexs:(NSArray <NSNumber *>*)selectIndexs
                     resultBlock:(BRMultiResultBlock)resultBlock {
    // 创建选择器
    BRTextPickerView *strPickerView = [[BRTextPickerView alloc]init];
    strPickerView.pickerMode = BRTextPickerComponentMulti;
    strPickerView.title = title;
    strPickerView.dataSourceArr = dataSourceArr;
    strPickerView.selectIndexs = selectIndexs;
    strPickerView.multiResultBlock = resultBlock;
    
    // 显示
    [strPickerView show];
}

#pragma mark - 3.显示【联动】选择器
+ (void)showCascadePickerWithTitle:(nullable NSString *)title
                     dataSourceArr:(nullable NSArray *)dataSourceArr
                      selectIndexs:(nullable NSArray <NSNumber *> *)selectIndexs
                       resultBlock:(nullable BRMultiResultBlock)resultBlock {
    // 创建选择器
    BRTextPickerView *strPickerView = [[BRTextPickerView alloc]init];
    strPickerView.pickerMode = BRTextPickerComponentCascade;
    strPickerView.title = title;
    strPickerView.dataSourceArr = dataSourceArr;
    strPickerView.selectIndexs = selectIndexs;
    strPickerView.multiResultBlock = resultBlock;
    
    // 显示
    [strPickerView show];
}

#pragma mark - 初始化自定义选择器
- (instancetype)initWithPickerMode:(BRTextPickerMode)pickerMode {
    if (self = [super init]) {
        self.pickerMode = pickerMode;
    }
    return self;
}

#pragma mark - 处理选择器数据 和 默认选择状态
- (void)handlerPickerData {
    // 1.检查数据源数据格式是否有误
    BOOL dataSourceError = NO;
    if (self.dataSourceArr.count == 0) {
        dataSourceError = YES;
    }
    id item = [self.dataSourceArr firstObject];
    if (self.pickerMode == BRTextPickerComponentSingle) {
        dataSourceError = !([item isKindOfClass:[NSString class]] || [item isKindOfClass:[BRTextModel class]]);
    } else if (self.pickerMode == BRTextPickerComponentMulti) {
        dataSourceError = ![item isKindOfClass:[NSArray class]];
    } else if (self.pickerMode == BRTextPickerComponentCascade) {
        dataSourceError = ![item isKindOfClass:[BRTextModel class]];
    }
    if (dataSourceError) {
        BRErrorLog(@"数据源异常！请检查选择器数据源的格式");
        return;
    }
    
    // 2.处理默认选择状态
    if (self.pickerMode == BRTextPickerComponentSingle) {
        self.dataList = self.dataSourceArr;
        if (self.selectIndex < 0 || self.selectIndex >= self.dataList.count) {
            self.selectIndex = 0;
        }
    } else if (self.pickerMode == BRTextPickerComponentMulti) {
        self.dataList = self.dataSourceArr;
        NSMutableArray *selectIndexs = [[NSMutableArray alloc]init];
        for (NSInteger component = 0; component < self.dataList.count; component++) {
            NSArray *itemArr = self.dataList[component];
            NSInteger row = 0;
            if (self.selectIndexs.count > 0 && component < self.selectIndexs.count) {
                NSInteger index = [self.selectIndexs[component] integerValue];
                row = ((index > 0 && index < itemArr.count) ? index : 0);
            }
            [selectIndexs addObject:@(row)];
        }
        self.selectIndexs = [selectIndexs copy];
    } else if (self.pickerMode == BRTextPickerComponentCascade) {
        NSMutableArray *dataList = [[NSMutableArray alloc]init];
        [dataList addObject:self.dataSourceArr];
        NSMutableArray *selectIndexs = [[NSMutableArray alloc]init];
        
        BOOL hasNext = self.dataSourceArr.count > 0;
        NSInteger i = 0;
        NSInteger selectIndex = self.selectIndexs.count > 0 && i < self.selectIndexs.count ? [self.selectIndexs[i] integerValue] : 0;
        [selectIndexs addObject:@(selectIndex)];
        BRTextModel *selectModel = self.dataSourceArr[selectIndex];
        while (hasNext) {
            NSArray *nextArr = selectModel.children;
            if (!nextArr || nextArr.count == 0) {
                hasNext = NO;
                break;
            }
            [dataList addObject:nextArr];
            
            i++;
            selectIndex = self.selectIndexs.count > 0 && i < self.selectIndexs.count ? [self.selectIndexs[i] integerValue] : 0;
            [selectIndexs addObject:@(selectIndex)];
            selectModel = nextArr[selectIndex];
        }
        
        // 控制选择器固定显示的列数
        if (self.showColumnNum > 0) {
            NSInteger dataListCount = dataList.count;
            if (self.showColumnNum < dataListCount) {
                // 显示子集数据
                dataList = [[dataList subarrayWithRange:NSMakeRange(0, self.showColumnNum)] mutableCopy];
                selectIndexs = [[selectIndexs subarrayWithRange:NSMakeRange(0, self.showColumnNum)] mutableCopy];
            } else {
                // 补全占位数据
                for (NSInteger i = 0; i < self.showColumnNum - dataListCount; i++) {
                    // 添加空白占位数据
                    BRTextModel *placeholderModel = [[BRTextModel alloc]init];
                    NSArray *placeholderArr = @[placeholderModel];
                    [dataList addObject:placeholderArr];
                    [selectIndexs addObject:@(0)];
                }
            }
        }
        self.dataList = [dataList copy];
        self.selectIndexs = [selectIndexs copy];
    }
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
// 1.返回组件数量
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.pickerMode) {
        case BRTextPickerComponentSingle:
            return 1;
        case BRTextPickerComponentMulti:
        case BRTextPickerComponentCascade:
        {
            if (self.pickerStyle.columnSpacing > 0) {
                return self.dataList.count * 2 - 1;
            }
            return self.dataList.count;
        }
            
        default:
            break;
    }
}

// 2.返回每个组件的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.pickerMode) {
        case BRTextPickerComponentSingle:
            return self.dataList.count;
        case BRTextPickerComponentMulti:
        case BRTextPickerComponentCascade:
        {
            if (self.pickerStyle.columnSpacing > 0) {
                if (component % 2 == 1) {
                    return 1;
                } else {
                    component = component / 2;
                }
            }
            NSArray *itemArr = self.dataList[component];
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
        label.numberOfLines = self.pickerStyle.maxTextLines;
        // 字体自适应属性
        label.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        label.minimumScaleFactor = 0.5f;
    }
    
    // 2.设置选择器中间选中行的样式
    [self.pickerStyle setupPickerSelectRowStyle:pickerView titleForRow:row forComponent:component];
    
    // 3.记录选择器滚动过程中选中的列和行
    [self handlePickerViewRollingStatus:pickerView component:component];

    // 设置文本
    if (self.pickerMode == BRTextPickerComponentSingle) {
        id item = self.dataList[row];
        if ([item isKindOfClass:[BRTextModel class]]) {
            BRTextModel *model = (BRTextModel *)item;
            label.text = model.text;
        } else {
            label.text = item;
        }
    } else if (self.pickerMode == BRTextPickerComponentMulti || self.pickerMode == BRTextPickerComponentCascade) {
        // 如果有设置列间距，且是第奇数列，则不显示内容（即空白间隔列）
        if (self.pickerStyle.columnSpacing > 0) {
            if (component % 2 == 1) {
                label.text = @"";
                return label;
            } else {
                component = component / 2;
            }
        }
        
        NSArray *itemArr = self.dataList[component];
        id item = [itemArr objectAtIndex:row];
        if ([item isKindOfClass:[BRTextModel class]]) {
            BRTextModel *model = (BRTextModel *)item;
            label.text = model.text;
        } else {
            label.text = item;
        }
    }
    
    return label;
}

#pragma mark - 处理选择器滚动状态
- (void)handlePickerViewRollingStatus:(UIPickerView *)pickerView component:(NSInteger)component {
    // 获取选择器组件滚动中选中的行
    NSInteger selectRow = [pickerView selectedRowInComponent:component];
    if (selectRow >= 0) {
        self.rollingComponent = component;
        // 根据滚动方向动态计算 rollingRow
        NSInteger lastRow = self.rollingRow;
        // 调整偏移量：当用户快速滚动并点击确定按钮时，可能导致选择不准确。这里简单的实现向前/向后多滚动一行（也可以根据滚动速度来调整偏移量）
        NSInteger offset = 1;
        if (lastRow >= 0) {
            // 向上滚动
            if (selectRow > lastRow) {
                self.rollingRow = selectRow + offset;
            } else if (selectRow < lastRow) {
                // 向下滚动
                self.rollingRow = selectRow - offset;
            } else {
                // 保持当前位置
                self.rollingRow = selectRow;
            }
        } else {
            // 首次滚动，默认向上滚动
            self.rollingRow = selectRow + offset;
        }
    }
}

// 获取选择器是否滚动中状态
- (BOOL)getRollingStatus:(UIView *)view {
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            // 如果 UIPickerView 正在拖拽或正在减速，返回YES
            return YES;
        }
    }
    
    for (UIView *subView in view.subviews) {
        if ([self getRollingStatus:subView]) {
            return YES;
        }
    }
    
    return NO;
}

// 选择器是否正在滚动
- (BOOL)isRolling {
    return [self getRollingStatus:self.pickerView];
}

// 4.滚动 pickerView 执行的回调方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.pickerMode) {
        case BRTextPickerComponentSingle:
        {
            self.selectIndex = row;
            // 滚动选择时执行 singleChangeBlock
            self.singleChangeBlock ? self.singleChangeBlock([self getSingleSelectModel], self.selectIndex): nil;
        }
            break;
        case BRTextPickerComponentMulti:
        {
            // 处理选择器有设置列间距时，选择器的滚动问题
            if (self.pickerStyle.columnSpacing > 0) {
                if (component % 2 == 1) {
                    return;
                } else {
                    component = component / 2;
                }
            }
            
            if (component < self.selectIndexs.count) {
                NSMutableArray *mutableArr = [self.selectIndexs mutableCopy];
                [mutableArr replaceObjectAtIndex:component withObject:@(row)];
                self.selectIndexs = [mutableArr copy];
            }
            
            // 滚动选择时执行 multiChangeBlock
            self.multiChangeBlock ? self.multiChangeBlock([self getMultiSelectModels], self.selectIndexs): nil;
        }
            break;
        case BRTextPickerComponentCascade:
        {
            // 处理选择器有设置列间距时，选择器的滚动问题
            if (self.pickerStyle.columnSpacing > 0) {
                if (component % 2 == 1) {
                    return;
                } else {
                    component = component / 2;
                }
            }
            
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
            
            // 滚动选择时执行 multiChangeBlock
            self.multiChangeBlock ? self.multiChangeBlock([self getMultiSelectModels], self.selectIndexs): nil;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 获取【单列】选择器选择的值
- (BRTextModel *)getSingleSelectModel {
    id item = self.selectIndex < self.dataList.count ? self.dataList[self.selectIndex] : nil;
    if ([item isKindOfClass:[BRTextModel class]]) {
        BRTextModel *model = (BRTextModel *)item;
        model.index = self.selectIndex;
        return model;
    } else {
        BRTextModel *model = [[BRTextModel alloc]init];
        model.index = self.selectIndex;
        model.text = item;
        return model;
    }
}

#pragma mark - 获取【多列】选择器选择的值
- (NSArray *)getMultiSelectModels {
    NSMutableArray *modelArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < self.dataList.count; i++) {
        NSInteger index = [self.selectIndexs[i] integerValue];
        NSArray *dataArr = self.dataList[i];
        
        id item = index < dataArr.count ? dataArr[index] : nil;
        if ([item isKindOfClass:[BRTextModel class]]) {
            BRTextModel *model = (BRTextModel *)item;
            model.index = index;
            [modelArr addObject:model];
        } else {
            BRTextModel *model = [[BRTextModel alloc]init];
            model.index = index;
            model.text = item;
            [modelArr addObject:model];
        }
    }
    return [modelArr copy];
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.pickerStyle.rowHeight;
}

// 设置列宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.pickerStyle.columnSpacing > 0 && component % 2 == 1) {
        return self.pickerStyle.columnSpacing;
    }
    NSInteger columnCount = [self numberOfComponentsInPickerView:pickerView];
    CGFloat columnWidth = self.pickerView.bounds.size.width / columnCount - 5;
    if (self.pickerStyle.columnWidth > 0 && self.pickerStyle.columnWidth <= columnWidth) {
        return self.pickerStyle.columnWidth;
    }
    return columnWidth;
}

#pragma mark - 重写父类方法
- (void)reloadData {
    // 1.处理数据源
    [self handlerPickerData];
    // 2.刷新选择器
    [self.pickerView reloadAllComponents];
    // 3.滚动到选择的值
    if (self.pickerMode == BRTextPickerComponentSingle) {
        [self.pickerView selectRow:self.selectIndex inComponent:0 animated:self.selectRowAnimated];
    } else if (self.pickerMode == BRTextPickerComponentMulti || self.pickerMode == BRTextPickerComponentCascade) {
        for (NSInteger i = 0; i < self.selectIndexs.count; i++) {
            NSNumber *row = [self.selectIndexs objectAtIndex:i];
            NSInteger component = i;
            if (self.pickerStyle.columnSpacing > 0) {
                component = i * 2;
            }
            [self.pickerView selectRow:[row integerValue] inComponent:component animated:self.selectRowAnimated];
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
    // 点击确定按钮的回调：点击确定按钮后，执行这个block回调
    self.doneBlock = ^{
        if (weakSelf.isRolling) {
            NSLog(@"选择器滚动还未结束");
            // 问题：如果滚动选择器过快，然后在滚动过程中快速点击确定按钮，会导致 didSelectRow 代理方法还没有执行，出现没有选中的情况。
            // 解决：这里手动处理一下，如果滚动还未结束，强制执行一次 didSelectRow 代理方法，选择当前滚动的行。
            [weakSelf pickerView:weakSelf.pickerView didSelectRow:weakSelf.rollingRow inComponent:weakSelf.rollingComponent];
        }
    
        // 点击确定，执行选择结果回调
        if (weakSelf.pickerMode == BRTextPickerComponentSingle) {
            weakSelf.singleResultBlock ? weakSelf.singleResultBlock([weakSelf getSingleSelectModel], weakSelf.selectIndex): nil;
        } else if (weakSelf.pickerMode == BRTextPickerComponentMulti || weakSelf.pickerMode == BRTextPickerComponentCascade) {
            weakSelf.multiResultBlock ? weakSelf.multiResultBlock([weakSelf getMultiSelectModels], weakSelf.selectIndexs): nil;
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
- (void)setFileName:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    if (filePath && filePath.length > 0) {
        if ([fileName hasSuffix:@".plist"]) {
            // 获取本地 plist文件 数据源
            NSArray *dataArr = [[NSArray alloc] initWithContentsOfFile:filePath];
            if (dataArr && dataArr.count > 0) {
                self.dataSourceArr = dataArr;
            }
        } else if ([fileName hasSuffix:@".json"]) {
            // 获取本地 JSON文件 数据源
            NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
            NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (dataArr && dataArr.count > 0) {
                self.dataSourceArr = [NSArray br_modelArrayWithJson:dataArr mapper:nil];
            }
        }
    }
}

@end
