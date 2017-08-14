# 框架介绍
BRPickerView是iOS的选择器组件，主要包括：日期选择器、时间选择器、地址选择器、自定义字符串选择器。

# 效果演示

查看并运行 `BRPickerViewDemo.xcodeproj`



# 安装

### CocoaPods

1. 在 Podfile 中添加 `pod 'BRPickerView'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入头文件 ` #import <BRPickerView.h>`。

### 手动导入

1. 将与 `README.md` 同级目录下的 `BRPickerView` 文件夹拽入项目中
2. 导入头文件 ` #import "BRPickerView.h"`。

# 系统要求

- iOS 8.0+
- ARC

# 使用

- 时间选择器：`BRDatePickerView`

  ```objective-c
  /**
   *  显示时间选择器
   *
   *  @param title            标题
   *  @param type             类型（时间、日期、日期和时间、倒计时）
   *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
   *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
   *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
   *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
   *  @param resultBlock      选择结果的回调
   *
   */
  + (void)showDatePickerWithTitle:(NSString *)title dateType:(UIDatePickerMode)type defaultSelValue:(NSString *)defaultSelValue minDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr isAutoSelect:(BOOL)isAutoSelect resultBlock:(BRDateResultBlock)resultBlock;
  ```

  方法使用：

  ```objective-c
  [BRDatePickerView showDatePickerWithTitle:@"出生年月" dateType:UIDatePickerModeDate defaultSelValue:weakSelf.birthdayTF.text minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                  weakSelf.birthdayTF.text = selectValue;
              }];
  ```

- 地址选择器：`BRAddressPickerView`

  ```objective-c
  /**
   *  显示地址选择器
   *
   *  @param defaultSelectedArr       默认选中的值(传数组，元素为对应的索引值。如：@[@10, @1, @1])
   *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
   *  @param resultBlock              选择后的回调
   *
   */
  + (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr isAutoSelect:(BOOL)isAutoSelect resultBlock:(BRAddressResultBlock)resultBlock;
  ```

  方法使用：

  ```objective-c
  [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@10, @0, @3] isAutoSelect:YES resultBlock:^(NSArray *selectAddressArr) {
                  weakSelf.addressTF.text = [NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1], selectAddressArr[2]];
              }];
  ```

- 自定义字符串选择器：`BRStringPickerView`

  ```objective-c
  /**
   *  显示自定义字符串选择器
   *
   *  @param title            标题
   *  @param dataSource       数组数据源
   *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
   *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
   *  @param resultBlock      选择后的回调
   *
   */
  + (void)showStringPickerWithTitle:(NSString *)title
                         dataSource:(NSArray *)dataSource
                    defaultSelValue:(id)defaultSelValue
                       isAutoSelect:(BOOL)isAutoSelect
                        resultBlock:(BRStringResultBlock)resultBlock;
                        
  /**
   *  显示自定义字符串选择器
   *
   *  @param title            标题
   *  @param plistName        plist文件名
   *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
   *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
   *  @param resultBlock      选择后的回调
   *
   */
  + (void)showStringPickerWithTitle:(NSString *)title
                          plistName:(NSString *)plistName
                    defaultSelValue:(id)defaultSelValue
                       isAutoSelect:(BOOL)isAutoSelect
                        resultBlock:(BRStringResultBlock)resultBlock;
  ```

  方法使用：

  ```objective-c
  [BRStringPickerView showStringPickerWithTitle:@"学历" dataSource:@[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"] defaultSelValue:@"本科" isAutoSelect:YES resultBlock:^(id selectValue) {
                  weakSelf.educationTF.text = selectValue;
              }];
  ```

# 许可证

BRPickerView 使用 MIT 许可证，详情见 LICENSE 文件。