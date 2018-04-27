# 1. 框架介绍

BRPickerView 封装的是iOS中常用的选择器组件。高度封装，只需一句代码即可完成调用，使用比较灵活支持自定义主题颜色。选择器类型主要包括：日期选择器、时间选择器、地址选择器、自定义字符串选择器。

【**特别提示**】：

- 当前最新版本为： `2.2.1` 。
- 如果不能找到最新版本，请先执行一下 `pod setup` ，待更新完成后；再执行 `pod search BRPickerView` 进行搜索，就会看到最新版本。

# 2. 效果演示

查看并运行 `BRPickerViewDemo.xcodeproj`

| ![效果图1](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/%E6%95%88%E6%9E%9C%E5%9B%BE1.gif?raw=true) | ![效果图2](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/%E6%95%88%E6%9E%9C%E5%9B%BE2.gif?raw=true) |
| :--------------------------------------: | :--------------------------------------: |
|               框架Demo运行效果图1               |               框架Demo运行效果图2               |

# 3. 更新记录

- **2018-04-27（V2.2.1）**:

  >- 修复bug，适配iPad和横屏显示。
  >- 优化代码，提高框架适应性，降低内存消耗。

- **2018-04-03（V2.2.0）**:

  >- 时间选择器新添加了7种显示类型（BRDatePickerMode），可根据自己项目的需求选择性使用。
  >- 适配横屏，及 iPhoneX 底部安全区域。
  >- 修改了最小时间和最大时间的参数名称（以前版本是传 NSString 类型， 现在传 NSDate 类型）
  >- 修复比较时间大小时出现的bug。

- **2018-03-19（V2.1.3）**:

  >- 修改地址选择器确认选择后的回调参数。
  >- 现修改如下：可通过省市区的模型获取省市区的 name（名称）、code（id）、index（索引）`resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {}`
  >- 去掉第三方依赖库 `MJExtension` ，修改为手动解析地址数据源。

- **2018-03-11（V2.1.2）**:

  >- 重命名了Github用户名，更新项目相关的路径。（提示：pod之前的版本不受影响）

- **2018-02-28（V2.1.1）**：

  >- 修复某些情况下无法用bundle加载本地数据源（BRCity.plist）bug。

- **2018-01-26（V2.1.0）**:

  >- 给地址选择器添加了一个方法（见方法4），提供数据源参数，支持外部传入地区数据源。
  >- 提示：要注意数据源格式，参考 BRCity.json。可以把 BRCity.json 文件的内容放到后台去维护，通过后台接口获取地区数据源（即 BRCity.json 文件的内容）。

- **2018-01-25（V2.0.0）**：

  > - 更新了地址数据源（BRCity.plist），地区信息是2018年最新最全的，与微信的地区信息完全一致。
  > - 支持自定义默认选择地址（格式：@[@"浙江省", @"杭州市", @"西湖区"]），支持下次点击进入地址选择器时，默认地址为上次选择的结果。
  > - 修改了日期选择器、地址选择器、字符串选择器的接口方法（删除了之前的方法2）。
  > - 添加了地址选择器显示类型，支持3种显示：只显示省份、显示省份和城市、显示省市区。


- **2018-01-05（V1.3.0）**:

  > - 添加取消选择的回调方法（点击背景或取消按钮会执行 `cancelBlock` ）
  >
  > - 合并了字符串选择器 数组数据源和plist数据源对应的方法，`dataSource` 参数支持两种类型：
  >
  >   1> 可以直接传数组：NSArray类型；
  >
  >   2> 可以传plist文件名：NSString类型，带后缀名，plist文件的内容必须是数组格式。


- **2018-01-02（V1.2.0）**：

  > - 添加支持自定义主题颜色的方法。

- **2017-11-26（V1.1.0）**：

  > - 更换第三方依赖库。
  >
  >   用MJExtension 替换了 原来的YYModel，以前没有注意导入YYModel，同时又导入YYKit会导致重复导入而冲突（另外使用YYModel时，手动导入和pod导入 其中的头文件和方法名也不一样，所以很容易出错）。


- **2017-11-16（V1.0.0）**：

  > - 初始版本！



# 4. 安装

#### 4.1. CocoaPods

1. 在 Podfile 中添加 `pod 'BRPickerView'`。

2. 执行 `pod install` 或 `pod update` 。

3. 导入头文件 ` #import <BRPickerView.h>`。


#### 4.2. 手动导入

1. 将与 `README.md` 同级目录下的 `BRPickerView` 文件夹拽入项目中

2. 导入头文件 ` #import "BRPickerView.h"`。


# 5. 系统要求

- iOS 8.0+
- ARC

# 6. 使用

#### 6.1. 时间选择器：`BRDatePickerView`

​	查看 BRDatePickerView.h 头文件，里面提供了3个方法，可根据自己的需求选择其中的一个方法进行使用。

```objective-c
/**
 *  1.显示时间选择器
 *
 *  @param title            标题
 *  @param dateType         日期显示类型
 *  @param defaultSelValue  默认选中的时间（值为空/值格式错误时，默认就选中现在的时间）
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(BRDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                    resultBlock:(BRDateResultBlock)resultBlock;

/**
 *  2.显示时间选择器（支持 设置自动选择 和 自定义主题颜色）
 *
 *  @param title            标题
 *  @param dateType         日期显示类型
 *  @param defaultSelValue  默认选中的时间（值为空/值格式错误时，默认就选中现在的时间）
 *  @param minDate          最小时间，可为空（请使用 NSDate+BRPickerView 分类中和显示类型格式对应的方法创建 minDate）
 *  @param maxDate          最大时间，可为空（请使用 NSDate+BRPickerView 分类中和显示类型格式对应的方法创建 maxDate）
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(BRDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(BRDateResultBlock)resultBlock;

/**
 *  3.显示时间选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param title            标题
 *  @param dateType         日期显示类型
 *  @param defaultSelValue  默认选中的时间（值为空/值格式错误时，默认就选中现在的时间）
 *  @param minDate          最小时间，可为空（请使用 NSDate+BRPickerView 分类中和显示类型格式对应的方法创建 minDate）
 *  @param maxDate          最大时间，可为空（请使用 NSDate+BRPickerView 分类中和显示类型格式对应的方法创建 maxDate）
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择结果的回调
 *  @param cancelBlock      取消选择的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(BRDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(BRDateResultBlock)resultBlock
                    cancelBlock:(BRDateCancelBlock)cancelBlock;
```

- 使用示例（参考Demo）：

```objective-c
NSDate *minDate = [NSDate br_setYear:1990 month:3 day:12];
NSDate *maxDate = [NSDate date];
[BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:BRDatePickerModeYMD defaultSelValue:weakSelf.birthdayTF.text minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
    weakSelf.birthdayTF.text = selectValue;
} cancelBlock:^{
    NSLog(@"点击了背景或取消按钮");
}];
```

- 时间选择器的显示类型：

```objective-c
/// 弹出日期类型
typedef NS_ENUM(NSInteger, BRDatePickerMode) {
    // --- 以下4种是系统自带的样式 ---
    // UIDatePickerModeTime
    BRDatePickerModeTime,              // HH:mm
    // UIDatePickerModeDate
    BRDatePickerModeDate,              // yyyy-MM-dd
    // UIDatePickerModeDateAndTime
    BRDatePickerModeDateAndTime,       // yyyy-MM-dd HH:mm
    // UIDatePickerModeCountDownTimer
    BRDatePickerModeCountDownTimer,    // HH:mm
    // --- 以下7种是自定义样式 ---
    // 年月日时分
    BRDatePickerModeYMDHM,      // yyyy-MM-dd HH:mm
    // 月日时分
    BRDatePickerModeMDHM,       // MM-dd HH:mm
    // 年月日
    BRDatePickerModeYMD,        // yyyy-MM-dd
    // 年月
    BRDatePickerModeYM,         // yyyy-MM
    // 年
    BRDatePickerModeY,          // yyyy
    // 月日
    BRDatePickerModeMD,         // MM-dd
    // 时分
    BRDatePickerModeHM          // HH:mm
};
```

- 时间选择器显示类型的效果图：

> 以下4种样式是使用 UIDatePicker 类 进行封装的，支持循环滚动

| ![样式1：UIDatePickerModeTime](https://github.com/91renb/BRPickerView/blob/fca58dbf6ac3c5f7f781e13cefdc27fdeaf59476/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type1.png?raw=true) | ![样式2：UIDatePickerModeDate](https://github.com/91renb/BRPickerView/blob/fca58dbf6ac3c5f7f781e13cefdc27fdeaf59476/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type2.png?raw=true) |
| :--------------------------------------: | :--------------------------------------: |
|         样式1：BRDatePickerModeTime         |         样式2：BRDatePickerModeDate         |
|                                          |                                          |
| ![样式3：UIDatePickerModeDateAndTime](https://github.com/91renb/BRPickerView/blob/fca58dbf6ac3c5f7f781e13cefdc27fdeaf59476/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type3.png?raw=true) | ![样式4：UIDatePickerModeCountDownTimer](https://github.com/91renb/BRPickerView/blob/fca58dbf6ac3c5f7f781e13cefdc27fdeaf59476/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type4.png?raw=true) |
|     样式3：BRDatePickerModeDateAndTime      |    样式4：BRDatePickerModeCountDownTimer    |

> 以下7种样式是使用 UIPickerView 类 进行封装的。

| ![样式5： BRDatePickerModeYMDHM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type5.png?raw=true) | ![样式6： BRDatePickerModeMDHM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type6.png?raw=true) |
| :--------------------------------------: | :--------------------------------------: |
|        样式5： BRDatePickerModeYMDHM        |        样式6： BRDatePickerModeMDHM         |
|                                          |                                          |
| ![样式7： BRDatePickerModeYMD](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type7.png?raw=true) | ![样式8： BRDatePickerModeYM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type8.png?raw=true) |
|         样式7： BRDatePickerModeYMD         |         样式8： BRDatePickerModeYM          |
|                                          |                                          |
| ![样式9： BRDatePickerModeY](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type9.png?raw=true) | ![样式10： BRDatePickerModeMD](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type10.png?raw=true) |
|          样式9： BRDatePickerModeY          |         样式10： BRDatePickerModeMD         |
|                                          |                                          |
| ![样式11：BRDatePickerModeHM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/date_type11.png?raw=true) |                                          |
|        样式11：  BRDatePickerModeHM         |                                          |

#### 6.2. 地址选择器：`BRAddressPickerView`

​	查看 BRAddressPickerView.h 头文件，里面提供了4个方法，可根据自己的需求选择其中的一个方法进行使用。

```objective-c
/**
 *  1.显示地址选择器
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                 resultBlock:(BRAddressResultBlock)resultBlock;

/**
 *  2.显示地址选择器（支持 设置自动选择 和 自定义主题颜色）
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
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
 *  3.显示地址选择器（支持 设置选择器类型、设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param showType                 地址选择器显示类型
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor               自定义主题颜色
 *  @param resultBlock              选择后的回调
 *  @param cancelBlock              取消选择的回调
 *
 */
+ (void)showAddressPickerWithShowType:(BRAddressPickerMode)showType
                      defaultSelected:(NSArray *)defaultSelectedArr
                         isAutoSelect:(BOOL)isAutoSelect
                           themeColor:(UIColor *)themeColor
                          resultBlock:(BRAddressResultBlock)resultBlock
                          cancelBlock:(BRAddressCancelBlock)cancelBlock;

/**
 *  4.显示地址选择器（支持 设置选择器类型、传入地区数据源、设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param showType                 地址选择器显示类型
 *  @param dataSource               地区数据源
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor               自定义主题颜色
 *  @param resultBlock              选择后的回调
 *  @param cancelBlock              取消选择的回调
 *
 */
+ (void)showAddressPickerWithShowType:(BRAddressPickerMode)showType
                           dataSource:(NSArray *)dataSource
                      defaultSelected:(NSArray *)defaultSelectedArr
                         isAutoSelect:(BOOL)isAutoSelect
                           themeColor:(UIColor *)themeColor
                          resultBlock:(BRAddressResultBlock)resultBlock
                          cancelBlock:(BRAddressCancelBlock)cancelBlock;
```

- 使用示例（参考Demo）：

```objective-c
// 【转换】：以@" "子字符串为基准将字符串分离成数组，如：@"浙江省 杭州市 西湖区" ——》@[@"浙江省", @"杭州市", @"西湖区"]
NSArray *defaultSelArr = [weakSelf.addressTF.text componentsSeparatedByString:@" "];
[BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea defaultSelected:defaultSelArr isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
    weakSelf.addressTF.text = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
} cancelBlock:^{
    NSLog(@"点击了背景视图或取消按钮");
}];
```

- 地址选择器的3种显示类型（showType 的3个枚举值）：

| ![省份](https://github.com/91renb/BRPickerView/blob/0fb77e50ea397cbcb41be8778045eda7a77293bd/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/BRAddressPickerModeProvince.png?raw=true) | ![城市](https://github.com/91renb/BRPickerView/blob/0fb77e50ea397cbcb41be8778045eda7a77293bd/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/BRAddressPickerModeCity.png?raw=true) |
| :--------------------------------------: | :--------------------------------------: |
|     样式1：BRAddressPickerModeProvince      |       样式2：BRAddressPickerModeCity        |
| ![地区](https://github.com/91renb/BRPickerView/blob/0fb77e50ea397cbcb41be8778045eda7a77293bd/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/BRAddressPickerModeArea.png?raw=true) |                                          |
|       样式3：BRAddressPickerModeArea        |                                          |

#### 6.3.  自定义字符串选择器：`BRStringPickerView`

​	查看 BRStringPickerView.h 头文件，里面提供了3个方法，可根据自己的需求选择其中的一个方法进行使用。

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
 *  2.显示自定义字符串选择器（支持 设置自动选择 和 自定义主题颜色）
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
 *  3.显示自定义字符串选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
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

- 使用示例（参考Demo）：

```objective-c
// 自定义单列字符串
//NSArray *dataSource = @[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"];
NSString *dataSource = @"testData1.plist"; // 可以将数据源（上面的数组）放到plist文件中
[BRStringPickerView showStringPickerWithTitle:@"学历" dataSource:dataSource defaultSelValue:weakSelf.educationTF.text isAutoSelect:YES themeColor:nil resultBlock:^(id selectValue) {
    weakSelf.educationTF.text = selectValue;
} cancelBlock:^{
    NSLog(@"点击了背景视图或取消按钮");
}];

// 自定义多列字符串
NSArray *dataSource = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
//NSString *dataSource = @"testData3.plist"; // 可以将数据源（上面的数组）放到plist文件中
NSArray *defaultSelArr = [weakSelf.otherTF.text componentsSeparatedByString:@"，"];
[BRStringPickerView showStringPickerWithTitle:@"自定义多列字符串" dataSource:dataSource defaultSelValue:defaultSelArr isAutoSelect:YES themeColor:RGB_HEX(0xff7998, 1.0f) resultBlock:^(id selectValue) {
    weakSelf.otherTF.text = [NSString stringWithFormat:@"%@，%@", selectValue[0], selectValue[1]];
} cancelBlock:^{
    NSLog(@"点击了背景视图或取消按钮");
}];
```

- 字符串选择器效果图：

| ![自定义单列字符串](https://github.com/91renb/BRPickerView/blob/d400c274ff270ac4c805ac8b33f9ea3988e927e4/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/string_single.png?raw=true) | ![自定义多列字符串](https://github.com/91renb/BRPickerView/blob/d400c274ff270ac4c805ac8b33f9ea3988e927e4/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/string_more.png?raw=true) |
| :--------------------------------------: | :--------------------------------------: |
|            单列字符串选择器（默认主题色样式）             |            双列字符串选择器（自定义主题色样式）            |

| ![3列效果图](https://github.com/91renb/BRPickerView/blob/fca58dbf6ac3c5f7f781e13cefdc27fdeaf59476/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/string_more3.png?raw=true) | ![4列效果图](https://github.com/91renb/BRPickerView/blob/fca58dbf6ac3c5f7f781e13cefdc27fdeaf59476/BRPickerViewDemo/%E6%95%88%E6%9E%9C%E5%9B%BE/string_more4.png?raw=true) |
| :--------------------------------------: | :--------------------------------------: |
|            3列字符串选择器（自定义主题色样式）            |            4列字符串选择器（自定义主题色样式）            |

# 7. 许可证

BRPickerView 使用 MIT 许可证，详情见 LICENSE 文件。