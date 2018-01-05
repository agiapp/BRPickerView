# 框架介绍
BRPickerView是iOS的选择器组件，主要包括：日期选择器、时间选择器、地址选择器、自定义字符串选择器。

#### 更新记录

- 2018-01-05（V1.3.0）:

  >1. 添加取消选择的回调方法（点击背景或取消按钮会执行 `cancelBlock` ）
  >2. 合并了字符串选择器 数组数据源和plist数据源对应的方法，`dataSource` 参数支持两种类型：
  >   - 1> 可以直接传数组：NSArray类型；
  >   - 2> 可以传plist文件名：NSString类型，带后缀名，plist文件的内容必须是数组格式。


- 2018-01-02（V1.2.0）：

  >添加支持自定义主题颜色的方法

  | ![默认主题颜色的样式](https://github.com/borenfocus/BRPickerView/blob/ace50fb90d32e80a3a94116a925c631e13c6f4cc/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/default_theme.png?raw=true) | ![自定义主题颜色的样式](https://github.com/borenfocus/BRPickerView/blob/ace50fb90d32e80a3a94116a925c631e13c6f4cc/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/custom_theme.png?raw=true) |
  | :--------------------------------------: | :--------------------------------------: |
  |                默认主题颜色的样式                 |                自定义主题颜色的样式                |

- 2017-11-26（V1.1.0）：

  >替换了第三方依赖库，用MJExtension 替换了 原来的YYModel，以前没有注意导入YYModel，同时又导入YYKit会导致重复导入而冲突（另外使用YYModel时，手动导入和pod导入 其中的头文件和方法名也不一样，所以很容易出错），推荐使用1.1.0版本！！！


- 2017-11-16（V1.0.0）：

  >初始版本。

# 效果演示

查看并运行 `BRPickerViewDemo.xcodeproj`

| ![Demo运行效果图](https://github.com/borenfocus/BRPickerView/blob/ace50fb90d32e80a3a94116a925c631e13c6f4cc/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/%E6%95%88%E6%9E%9C%E5%9B%BE.gif?raw=true) |
| :--------------------------------------: |
|               框架Demo运行效果图                |

# 安装

#### CocoaPods

1. 在 Podfile 中添加 `pod 'BRPickerView'`。

2. 执行 `pod install` 或 `pod update` 。

   推荐使用：`pod update --verbose --no-repo-update`  (安装速度快一点)

3. 导入头文件 ` #import <BRPickerView.h>`。

   >注意：
   >
   >​	先搜索框架：pod search BRPickerView （最新版本号为1.2.0）
   >
   >​	如果无法搜索到框架（或没有显示最新版本），执行下面操作：
   >
   >​		1》pod setup
   >
   >​		2》rm ~/Library/Caches/CocoaPods/search_index.json
   >
   >​		3》pod search BRPickerView
   >
   >导入指定版本的框架：pod 'BRPickerView', '~> 1.2.0'

#### 手动导入

1. 将与 `README.md` 同级目录下的 `BRPickerView` 文件夹拽入项目中

2. 导入头文件 ` #import "BRPickerView.h"`。

   > 注意：
   >
   > 本框架依赖第三方MJExtension，所以手动导入框架时，还需要导入MJExtension框架。

# 系统要求

- iOS 8.0+
- ARC

# 使用

#### 1. 时间选择器：`BRDatePickerView`

​	查看 BRDatePickerView.h 头文件，里面提供了4个方法，可根据自己的需求选择其中的一个方法进行使用。

```objective-c
/**
 *  1.显示时间选择器
 *
 *  @param title            标题
 *  @param type             类型（枚举类型：UIDatePickerModeTime、UIDatePickerModeDate、UIDatePickerModeDateAndTime、UIDatePickerModeCountDownTimer）
 *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(UIDatePickerMode)type
                defaultSelValue:(NSString *)defaultSelValue
                    resultBlock:(BRDateResultBlock)resultBlock;

/**
 *  2.显示时间选择器（支持 设置自动选择）
 *
 *  @param title            标题
 *  @param type             类型（枚举类型：UIDatePickerModeTime、UIDatePickerModeDate、UIDatePickerModeDateAndTime、UIDatePickerModeCountDownTimer）
 *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
 *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
 *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(UIDatePickerMode)type
                defaultSelValue:(NSString *)defaultSelValue
                     minDateStr:(NSString *)minDateStr
                     maxDateStr:(NSString *)maxDateStr
                   isAutoSelect:(BOOL)isAutoSelect
                    resultBlock:(BRDateResultBlock)resultBlock;

/**
 *  3.显示时间选择器（支持 设置自动选择 和 自定义主题颜色）
 *
 *  @param title            标题
 *  @param type             类型（枚举类型：UIDatePickerModeTime、UIDatePickerModeDate、UIDatePickerModeDateAndTime、UIDatePickerModeCountDownTimer）
 *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
 *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
 *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(UIDatePickerMode)type
                defaultSelValue:(NSString *)defaultSelValue
                     minDateStr:(NSString *)minDateStr
                     maxDateStr:(NSString *)maxDateStr
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(BRDateResultBlock)resultBlock;

/**
 *  4.显示时间选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param title            标题
 *  @param type             类型（枚举类型：UIDatePickerModeTime、UIDatePickerModeDate、UIDatePickerModeDateAndTime、UIDatePickerModeCountDownTimer）
 *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
 *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
 *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择结果的回调
 *  @param cancelBlock      取消选择的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(UIDatePickerMode)type
                defaultSelValue:(NSString *)defaultSelValue
                     minDateStr:(NSString *)minDateStr
                     maxDateStr:(NSString *)maxDateStr
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(BRDateResultBlock)resultBlock
                    cancelBlock:(BRDateCancelBlock)cancelBlock;
```

- 日期选择器的四种类型（dateType的4个枚举值）：

| ![样式1：UIDatePickerModeTime](https://github.com/borenfocus/BRPickerView/blob/0e4519a28bd0ce462b9e2c15d63834645228a605/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type1.png?raw=true) | ![样式2：UIDatePickerModeDate](https://github.com/borenfocus/BRPickerView/blob/0e4519a28bd0ce462b9e2c15d63834645228a605/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type2.png?raw=true) |
| :--------------------------------------: | :--------------------------------------: |
|         样式1：UIDatePickerModeTime         |         样式2：UIDatePickerModeDate         |
|                                          |                                          |
| ![样式3：UIDatePickerModeDateAndTime](https://github.com/borenfocus/BRPickerView/blob/0e4519a28bd0ce462b9e2c15d63834645228a605/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type3.png?raw=true) | ![样式4：UIDatePickerModeCountDownTimer](https://github.com/borenfocus/BRPickerView/blob/0e4519a28bd0ce462b9e2c15d63834645228a605/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type4.png?raw=true) |
|     样式3：UIDatePickerModeDateAndTime      |    样式4：UIDatePickerModeCountDownTimer    |



#### 2. 地址选择器：`BRAddressPickerView`

​	查看 BRAddressPickerView.h 头文件，里面提供了4个方法，可根据自己的需求选择其中的一个方法进行使用。

```objective-c
/**
 *  1.显示地址选择器
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，元素为对应的索引值。如：@[@10, @1, @1])
 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                 resultBlock:(BRAddressResultBlock)resultBlock;

/**
 *  2.显示地址选择器（支持 设置自动选择）
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，元素为对应的索引值。如：@[@10, @1, @1])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                 resultBlock:(BRAddressResultBlock)resultBlock;

/**
 *  3.显示地址选择器（支持 设置自动选择 和 自定义主题颜色）
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，元素为对应的索引值。如：@[@10, @1, @1])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor               自定义主题颜色
 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                  themeColor:(UIColor *)themeColor
                                 resultBlock:(BRAddressResultBlock)resultBlock;

/**
 *  4.显示地址选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，元素为对应的索引值。如：@[@10, @1, @1])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor               自定义主题颜色
 *  @param resultBlock              选择后的回调
 *  @param cancelBlock              取消选择的回调
 *
 */
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                  themeColor:(UIColor *)themeColor
                                 resultBlock:(BRAddressResultBlock)resultBlock
                                 cancelBlock:(BRAddressCancelBlock)cancelBlock;
```

方法使用：

```objective-c
[BRAddressPickerView showAddressPickerWithDefaultSelected:@[@10, @0, @3] isAutoSelect:YES resultBlock:^(NSArray *selectAddressArr) {
	weakSelf.addressTF.text = [NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1], selectAddressArr[2]];
}];
```

效果图：

![地址选择器](https://github.com/borenfocus/BRPickerView/blob/3e7ed8835f188c7ad7f49b1baa3f528266088750/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/%E5%9C%B0%E5%9D%80.png?raw=true)

#### 3.  自定义字符串选择器：`BRStringPickerView`

​	查看 BRStringPickerView.h 头文件，里面提供了6个方法，可根据自己的需求选择其中的一个方法进行使用。

```objective-c
/**
 *  1.显示自定义字符串选择器
 *
 *  @param title            标题
 *  @param dataSource       数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                      resultBlock:(BRStringResultBlock)resultBlock;

/**
 *  2.显示自定义字符串选择器（支持 设置自动选择）
 *
 *  @param title            标题
 *  @param dataSource       数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                      resultBlock:(BRStringResultBlock)resultBlock;

/**
 *  3.显示自定义字符串选择器（支持 设置自动选择 和 自定义主题颜色）
 *
 *  @param title            标题
 *  @param dataSource       数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                       themeColor:(UIColor *)themeColor
                      resultBlock:(BRStringResultBlock)resultBlock;

/**
 *  4.显示自定义字符串选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param title            标题
 *  @param dataSource       数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择后的回调
 *  @param cancelBlock      取消选择的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                       themeColor:(UIColor *)themeColor
                      resultBlock:(BRStringResultBlock)resultBlock
                      cancelBlock:(BRStringCancelBlock)cancelBlock;
```

方法使用：

```objective-c
// 自定义单列字符串
NSArray *dataSources = @[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"];
[BRStringPickerView showStringPickerWithTitle:@"学历" dataSource:dataSources defaultSelValue:@"本科" isAutoSelect:YES themeColor:[UIColor blueColor] resultBlock:^(id selectValue) {
	weakSelf.educationTextField.text = selectValue;
}];
// 自定义多列字符串
NSArray *dataSources = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
[BRStringPickerView showStringPickerWithTitle:@"自定义多列字符串" dataSource:dataSources defaultSelValue:@[@"第3周", @"第3天"] isAutoSelect:YES resultBlock:^(id selectValue) {
	weakSelf.otherTextField.text = [NSString stringWithFormat:@"%@，%@", selectValue[0], selectValue[1]];
}];
```

效果图：

| ![自定义单列字符串](https://github.com/borenfocus/BRPickerView/blob/018260fc8b2a20e335182b017e2b4e51ad79a3dd/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/%E8%87%AA%E5%AE%9A%E4%B9%89%E5%8D%95%E5%88%97%E5%AD%97%E7%AC%A6%E4%B8%B2.png?raw=true) | ![自定义多列字符串](https://github.com/borenfocus/BRPickerView/blob/018260fc8b2a20e335182b017e2b4e51ad79a3dd/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/%E8%87%AA%E5%AE%9A%E4%B9%89%E5%A4%9A%E5%88%97%E5%AD%97%E7%AC%A6%E4%B8%B2.png?raw=true) |
| :--------------------------------------: | :--------------------------------------: |
|                 自定义单列字符串                 |                 自定义多列字符串                 |

# 许可证

BRPickerView 使用 MIT 许可证，详情见 LICENSE 文件。