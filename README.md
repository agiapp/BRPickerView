# BRPickerView

BRPickerView 封装的是iOS中常用的选择器组件，主要包括：日期选择器（支持年月日、年月等15种日期样式选择，支持设置星期、至今等）、地址选择器（支持省市区、省市、省三种地区选择）、自定义字符串选择器（支持单列、多列、二级联动、三级联动选择）。支持自定义主题样式，适配深色模式，支持将选择器组件添加到指定容器视图。

【说明】

- 当前最新版本为： `2.8.0` 。
- 如果不能找到最新版本，请先执行一下 `pod repo update` 更新本地仓库，待更新完成后；再执行 `pod search BRPickerView` 进行搜索，就会看到最新版本。

# 效果演示

查看并运行 `BRPickerViewDemo.xcodeproj`

| ![效果图1](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/a.gif?raw=true) | ![效果图2](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/b.gif?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                     框架Demo运行效果图1                      |                     框架Demo运行效果图2                      |

# 安装

#### 1. CocoaPods

1. 在 Podfile 中添加 `pod 'BRPickerView'`。

2. 执行 `pod install` 或 `pod update` 。

3. 导入头文件 ` #import <BRPickerView.h>`。


#### 2. 手动导入

1. 将与 `README.md` 同级目录下的 `BRPickerView` 文件夹拽入项目中

2. 导入头文件 ` #import "BRPickerView.h"`。


# 系统要求

- iOS 8.0+
- ARC

# 使用

#### 1. 时间选择器：`BRDatePickerView`

​	查看 BRDatePickerView.h 头文件，里面提供了两种使用方式，参见源码。

```objective-c
/// 日期选择器格式
typedef NS_ENUM(NSInteger, BRDatePickerMode) {
    // ----- 以下4种是系统样式（兼容国际化日期格式） -----
    /** 【yyyy-MM-dd】UIDatePickerModeDate（美式日期：MM-dd-yyyy；英式日期：dd-MM-yyyy）*/
    BRDatePickerModeDate,
    /** 【yyyy-MM-dd HH:mm】 UIDatePickerModeDateAndTime */
    BRDatePickerModeDateAndTime,
    /** 【HH:mm】UIDatePickerModeTime */
    BRDatePickerModeTime,
    /** 【HH:mm】UIDatePickerModeCountDownTimer */
    BRDatePickerModeCountDownTimer,
    
    // ----- 以下11种是自定义样式 -----
    /** 【yyyy-MM-dd HH:mm:ss】年月日时分秒 */
    BRDatePickerModeYMDHMS,
    /** 【yyyy-MM-dd HH:mm】年月日时分 */
    BRDatePickerModeYMDHM,
    /** 【yyyy-MM-dd HH】年月日时 */
    BRDatePickerModeYMDH,
    /** 【MM-dd HH:mm】月日时分 */
    BRDatePickerModeMDHM,
    /** 【yyyy-MM-dd】年月日（兼容国际化日期：dd-MM-yyyy）*/
    BRDatePickerModeYMD,
    /** 【yyyy-MM】年月（兼容国际化日期：MM-yyyy）*/
    BRDatePickerModeYM,
    /** 【yyyy】年 */
    BRDatePickerModeY,
    /** 【MM-dd】月日 */
    BRDatePickerModeMD,
    /** 【HH:mm:ss】时分秒 */
    BRDatePickerModeHMS,
    /** 【HH:mm】时分 */
    BRDatePickerModeHM,
    /** 【mm:ss】分秒 */
    BRDatePickerModeMS
};
```

- 使用示例（参考Demo）：

```objective-c
// 1.创建日期选择器
BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
// 2.设置属性
datePickerView.pickerMode = BRDatePickerModeYMD;
datePickerView.title = @"选择年月日";
// datePickerView.selectValue = @"2019-10-30";
datePickerView.selectDate = [NSDate br_setYear:2019 month:10 day:30];
datePickerView.minDate = [NSDate br_setYear:1949 month:3 day:12];
datePickerView.maxDate = [NSDate date];
datePickerView.isAutoSelect = YES;
datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
    NSLog(@"选择的值：%@", selectValue);
};
// 设置自定义样式
BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
customStyle.pickerColor = BR_RGB_HEX(0xd9dbdf, 1.0f);
customStyle.pickerTextColor = [UIColor redColor];
customStyle.separatorColor = [UIColor redColor];
datePickerView.pickerStyle = customStyle;

// 3.显示
[datePickerView show];
```

**时间选择器显示类型的效果图（默认样式）：**

- 以下4种样式是使用 UIDatePicker 类 进行封装的，支持循环滚动

| ![样式1：BRDatePickerModeTime](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type1.png?raw=true) | ![样式2：BRDatePickerModeDate](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type2.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                 样式1：BRDatePickerModeDate                  |              样式2：BRDatePickerModeDateAndTime              |
|                                                              |                                                              |
| ![样式3：BRDatePickerModeDateAndTime](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type3.png?raw=true) | ![样式4：BRDatePickerModeCountDownTimer](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type4.png?raw=true) |
|                 样式3：BRDatePickerModeTime                  |            样式4：BRDatePickerModeCountDownTimer             |

- 以下11种样式是使用 UIPickerView 类进行封装的。

| ![样式5：BRDatePickerModeYMDHMS](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type5.png?raw=true) | ![样式6：BRDatePickerModeYMDHM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type6.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                样式5：BRDatePickerModeYMDHMS                 |                 样式6：BRDatePickerModeYMDHM                 |
|                                                              |                                                              |
| ![样式7：BRDatePickerModeYMDH](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type7.png?raw=true) | ![样式8：BRDatePickerModeMDHM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type8.png?raw=true) |
|                 样式7：BRDatePickerModeYMDH                  |                 样式8：BRDatePickerModeMDHM                  |
|                                                              |                                                              |
| ![样式9：BRDatePickerModeYMDE](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type9.png?raw=true) | ![样式10：BRDatePickerModeYMD](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type10.png?raw=true) |
|                  样式9：BRDatePickerModeYMD                  |                  样式10：BRDatePickerModeYM                  |
|                                                              |                                                              |
| ![样式11：BRDatePickerModeYM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type11.png?raw=true) | ![样式12：BRDatePickerModeY](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type12.png?raw=true) |
|                  样式11：BRDatePickerModeY                   |                  样式12：BRDatePickerModeMD                  |
|                                                              |                                                              |
| ![样式13：BRDatePickerModeMD](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type13.png?raw=true) | ![样式14：BRDatePickerModeHMS](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type14.png?raw=true) |
|                 样式13：BRDatePickerModeHMS                  |                  样式14：BRDatePickerModeHM                  |
|                                                              |                                                              |
| ![样式15：BRDatePickerModeHM](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type15.png?raw=true) |                                                              |
|                  样式15：BRDatePickerModeMS                  |                                                              |

- 其它日期样式

| ![设置显示星期](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_week1.png?raw=true) | ![设置显示星期](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_week2.png?raw=true) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 设置显示星期：datePickerView.showWeek = YES;                 | 设置显示星期：datePickerView.showWeek = YES;                 |
|                                                              |                                                              |
| ![设置添加至今](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_now.png?raw=true) | ![设置显示今天](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_today.png?raw=true) |
| 设置添加至今：datePickerView.addToNow = YES;                 | 设置显示今天：datePickerView.showToday = YES;                |
|                                                              |                                                              |
| ![日期单位单行显示样式](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_unit.png?raw=true) | ![自定义选择器选中行颜色](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_row.png?raw=true) |
| 日期单位显示样式：datePickerView.showUnitType = BRShowUnitTypeOnlyCenter; | 设置选择器中间选中行的背景颜色：selectRowColor               |

```objective-c
// 设置选择器中间选中行的样式
BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
customStyle.selectRowColor = [UIColor blueColor];
customStyle.selectRowTextFont = [UIFont boldSystemFontOfSize:20.0f];
customStyle.selectRowTextColor = [UIColor redColor];
datePickerView.pickerStyle = customStyle;
```

| ![英式日期年月日](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_en1.png?raw=true) | ![英式日期年月](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_en2.png?raw=true) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 样式：BRDatePickerModeYMD （默认非中文环境显示英式日期）     | 样式：BRDatePickerModeYM （默认非中文环境显示英式日期）      |

- 几种常见的弹框样式模板

| ![模板样式1](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/template_style1.png?raw=true) | ![模板样式2](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/template_style2.png?raw=true) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 弹框样式模板1：datePickerView.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor blueColor]]; | 弹框样式模板2：datePickerView.pickerStyle = [BRPickerStyle pickerStyleWithDoneTextColor:[UIColor blueColor]]; |
|                                                              |                                                              |
| ![模板样式3](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/template_style3.png?raw=true) | ![添加选择器的头视图](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_top.png?raw=true) |
| 弹框样式模板3：datePickerView.pickerStyle = [BRPickerStyle pickerStyleWithDoneBtnImage:[UIImage imageNamed:@"icon_close"]]; | 添加选择器的头视图：pickerHeaderView                         |

```objective-c
// 添加选择器头视图（pickerHeaderView）
UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
headerView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1f];
NSArray *unitArr = @[@"年", @"月", @"日"];
for (NSInteger i = 0; i < unitArr.count; i++) {
    CGFloat width = SCREEN_WIDTH / unitArr.count;
    CGFloat orginX = i * (SCREEN_WIDTH / unitArr.count);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(orginX, 0, width, 36)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textColor = [UIColor darkGrayColor];
    label.text = unitArr[i];
    [headerView addSubview:label];
}
datePickerView.pickerHeaderView = headerView;
```

#### 2. 地址选择器：`BRAddressPickerView`

​	查看 BRAddressPickerView.h 头文件，里面提供了两种使用方式，参见源码。

- 使用示例（参考Demo）：

```objective-c
/// 地址选择器
BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]init];
addressPickerView.pickerMode = BRAddressPickerModeArea;
addressPickerView.title = @"请选择地区";
//addressPickerView.selectValues = @[@"浙江省", @"杭州市", @"西湖区"];
addressPickerView.selectIndexs = @[@10, @0, @4];
addressPickerView.isAutoSelect = YES;
addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
    NSLog(@"选择的值：%@", [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name]);
};

[addressPickerView show];
```

- 地址选择器的3种显示类型（showType 的3个枚举值）：

| ![省份](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/BRAddressPickerModeProvince.png?raw=true) | ![城市](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/BRAddressPickerModeCity.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|              样式1：BRAddressPickerModeProvince              |                样式2：BRAddressPickerModeCity                |
|                                                              |                                                              |
| ![地区](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/BRAddressPickerModeArea.png?raw=true) |                                                              |
|                样式3：BRAddressPickerModeArea                |                                                              |

#### 3.  自定义字符串选择器：`BRStringPickerView`

​	查看 BRStringPickerView.h 头文件，里面提供了两种使用方式，参见源码。

- 使用示例（参考Demo）：

```objective-c
/// 1.单列字符串选择器（传字符串数组）
BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
stringPickerView.pickerMode = BRStringPickerComponentSingle;
stringPickerView.title = @"学历";
stringPickerView.dataSourceArr = @[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"];
stringPickerView.selectIndex = 2;
stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
    NSLog(@"选择的值：%@", resultModel.value);
};

[stringPickerView show];


/// 2.单列字符串选择器（可以传模型数组）
NSArray *infoArr = @[@{@"key": @"1001", @"value": @"无融资", @"remark": @""},
                     @{@"key": @"2001", @"value": @"天使轮", @"remark": @""},
                     @{@"key": @"3001", @"value": @"A轮", @"remark": @""},
                     @{@"key": @"4001", @"value": @"B轮", @"remark": @""},
                     @{@"key": @"5001", @"value": @"C轮以后", @"remark": @""},
                     @{@"key": @"6001", @"value": @"已上市", @"remark": @""}];
NSMutableArray *modelArr = [[NSMutableArray alloc]init];
for (NSDictionary *dic in infoArr) {
    BRResultModel *model = [[BRResultModel alloc]init];
    model.key = dic[@"key"];
    model.value = dic[@"value"];
    model.remark = dic[@"remark"];
    [modelArr addObject:model];
}
BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
stringPickerView.pickerMode = BRStringPickerComponentSingle;
stringPickerView.title = @"融资情况";
stringPickerView.dataSourceArr = [modelArr copy];
stringPickerView.selectIndex = 2;
stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
    NSLog(@"选择的索引：%@", @(resultModel.index));
    NSLog(@"选择的值：%@", resultModel.value);
};

[stringPickerView show];


/// 3.多列字符串选择器
BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
stringPickerView.pickerMode = BRStringPickerComponentMulti;
stringPickerView.title = @"自定义多列字符串";
stringPickerView.dataSourceArr = @[@[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物"], @[@"优秀", @"良好", @"及格", @"不及格"]];
stringPickerView.selectIndexs = @[@2, @1];
stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> *resultModelArr) {
    NSLog(@"选择的值：%@", [NSString stringWithFormat:@"%@，%@", resultModelArr[0].value, resultModelArr[1].value]);
};

// 设置选择器中间选中行的样式
BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
customStyle.selectRowTextFont = [UIFont boldSystemFontOfSize:20.0f];
customStyle.selectRowTextColor = [UIColor blueColor];
stringPickerView.pickerStyle = customStyle;

[stringPickerView show];
```

- 字符串选择器效果图：

| ![自定义单列字符串](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/string_single.png?raw=true) | ![融资情况](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/string_rongzi.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                       单列字符串选择器                       |                       单列字符串选择器                       |
|                                                              |                                                              |
| ![多列字符串选择器](https://github.com/91renb/BRPickerView/blob/master/BRPickerViewDemo/images/string_more.png?raw=true) |                                                              |
|                       多列字符串选择器                       |                                                              |

# 更新记录

#### 2022-07-08（V2.8.0）

- 优化代码。

#### 2022-06-16（V2.7.8）

- 优化代码。

#### 2022-03-30（V2.7.7）

- 优化代码。

#### 2021-10-09（V2.7.6）

- 适配iOS15

#### 2021-05-28（V2.7.5）

- 日期选择器新增属性：`monthNames` 和 `customUnit`

- 解决已知问题：[#232](https://github.com/91renb/BRPickerView/issues/232) 、[#231](https://github.com/91renb/BRPickerView/issues/231)  、[#230](https://github.com/91renb/BRPickerView/issues/230)  、[#227](https://github.com/91renb/BRPickerView/issues/227)  、[#225](https://github.com/91renb/BRPickerView/issues/225) 、[#219](https://github.com/91renb/BRPickerView/issues/219) 、[#206](https://github.com/91renb/BRPickerView/issues/206) 

#### 2020-09-25（V2.7.3）

- 适配选择器iOS14的样式：[#189](https://github.com/91renb/BRPickerView/issues/189) 、[#191](https://github.com/91renb/BRPickerView/issues/191)

#### 2020-09-23（V2.7.2）

- 日期选择器新增添加自定义字符串属性：`firstRowContent` 和 `lastRowContent`
- 解决日期选择器设置最小日期时，存在的联动不正确的问题：[#184](https://github.com/91renb/BRPickerView/issues/184) 

#### 2020-08-28（V2.7.0）

- 日期选择器添加 `nonSelectableDates` 属性：[#178](https://github.com/91renb/BRPickerView/issues/178) 
- 优化选中行文本显示：[#177](https://github.com/91renb/BRPickerView/issues/177) 

#### 2020-08-16（V2.6.8）

- 优化代码，适配 iPad 分屏显示
- 新增 `keyView` 属性（即组件的父视图：可以将组件添加到 自己获取的 keyWindow 上，或页面的 view 上）

#### 2020-08-09（V2.6.7）

- 适配 iOS14

#### 2020-08-06（V2.6.6）

- 修复 [#163](https://github.com/91renb/BRPickerView/issues/163) 和  [#170](https://github.com/91renb/BRPickerView/issues/170) 

#### 2020-07-18（V2.6.5）

- 字符串选择器新增支持多级联动选择

#### 2020-06-24（V2.6.3）

- 日期选择器新增属性：`timeZone` 和 `addCustomString`

#### 2020-05-12（V2.6.2）

- 实现 [#145](#145) 和  [#146](#146) 需求

#### 2020-04-30（V2.6.0）

- 新增样式属性：`selectRowTextColor` 和 `selectRowTextFont`
- 日期选择器新增数字显示属性：`numberFullName`
- 优化代码，添加 `BRDatePickerModeYMD` 支持国际化英式日期

- 修复 [#143](#143)

#### 2020-04-27（V2.5.8）

- 修复 [#138](https://github.com/91renb/BRPickerView/issues/138) 和 [#142](https://github.com/91renb/BRPickerView/issues/142)
- 日期选择器新增 `descending` 属性，支持降序的时间列表
- 更新地址选择器地区数据源

#### 2020-03-31（V2.5.7）

- 优化代码，解决已知问题

#### 2020-02-26（V2.5.6）

- 优化代码，兼容部分国际化日期样式

#### 2020-02-24（V2.5.5）

- 添加设置选择器选中行背景颜色的功能，新增属性 `selectRowColor`

#### 2020-01-31（V2.5.3）

- 新增属性：`pickerHeaderView`、`pickerFooterView`
- 新增刷新选择器数据方法：`reloadData`

#### 2020-01-05（V2.5.1）

- 优化代码，添加 `BRDatePickerModeYM` 支持国际化英式日期

#### 2020-01-02（V2.5.0）

- 日期选择器新增属性：`showUnitType`（日期单位显示样式）、`minuteInterval`、`secondInterval`
- 封装了常用的几种模板样式，使用更加简单便捷
- 框架内默认适配深色模式显示

#### 2019-12-26（V2.4.6）

- 添加支持动态更新属性 `title` 、 `selectDate`、`pickerMode` 的值
- 日期选择器添加 `showWeek` 属性，及新增 `BRDatePickerModeMS` 日期类型
- 优化选择器【用法二】的使用，新增选择器滚动选择时回调的属性

#### 2019-11-28（V2.4.5）

- 日期选择器新增选择 ”至今“ 和 显示 ”今天“ 的功能，见以下两个属性：

  `showToday` ：控制是否显示 “今天” ，默认为 NO

  `addToNow`：控制是否添加选择 “至今”，默认为 NO

#### 2019-11-26（V2.4.3）

- 日期选择器新增以下三种选择类型：

  `BRDatePickerModeYMDHMS`（年月日时分秒）、`BRDatePickerModeYMDE`（年月日星期）、`BRDatePickerModeHMS`（时分秒）

- 更新地址选择器地区数据源

#### 2019-11-07（V2.4.2）

- 日期选择器添加：BRDatePickerModeYMDH（yyyy-MM-dd HH）类型
- 地址选择器添加：selectIndexs 属性，可根据索引去设置默认选择
- 适配横屏及刘海屏安全区域显示效果

#### 2019-11-04（V2.4.0）

- 优化选择器子目录管理，方便轻量级、模块化集成

  `pod 'BRPickerView'`	// 集成全部的功能

  `pod 'BRPickerView/DatePickerView'`	// 仅集成日期选择器的功能

  `pod 'BRPickerView/AddressPickerView'`	// 仅集成地址选择器的功能

  `pod 'BRPickerView/StringPickerView'`	// 仅集成字符串选择器的功能

#### 2019-11-01（V2.3.8）

- 优化代码，添加更多的自定义样式属性

#### 2019-10-30（V2.3.6）

- 优化代码，添加国际化支持

#### 2019-10-26（V2.3.5）

- 添加传统的创建对象设置属性的使用方式
- 开放设置选择器颜色及样式，适配深色模式
- 更新省市区数据源，数据与政府官网最新公布的一致（参见：[行政区划代码](http://www.mca.gov.cn/article/sj/xzqh/2019/)）
- 支持将选择器添加到指定容器视图上（见BaseView.h文件，扩展一方法）
- 支持将子视图添加到选择器上（见BaseView.h文件，扩展二方法）
- 优化代码，配置Pod库的层级目录

#### 2018-04-27（V2.2.1）:

- 修复bug，适配iPad和横屏显示。
- 优化代码，提高框架适应性，降低内存消耗。

#### 2018-04-03（V2.2.0）

- 时间选择器新添加了7种显示类型（BRDatePickerMode），可根据自己项目的需求选择性使用。
- 适配横屏，及 iPhoneX 底部安全区域。
- 修改了最小时间和最大时间的参数名称（以前版本是传 NSString 类型， 现在传 NSDate 类型）
- 修复比较时间大小时出现的bug。

#### 2018-03-19（V2.1.3）

- 修改地址选择器确认选择后的回调参数。
- 现修改如下：可通过省市区的模型获取省市区的 name（名称）、code（id）、index（索引）`resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {}`
- 去掉第三方依赖库 `MJExtension` ，修改为手动解析地址数据源。

#### 2018-03-11（V2.1.2）

- 重命名了Github用户名，更新项目相关的路径。（提示：pod之前的版本不受影响）

#### 2018-02-28（V2.1.1）

- 修复某些情况下无法用bundle加载本地数据源（BRCity.plist）bug。

#### 2018-01-26（V2.1.0）

- 给地址选择器添加了一个方法（见方法4），提供数据源参数，支持外部传入地区数据源。
- 提示：要注意数据源格式，参考 BRCity.json。可以把 BRCity.json 文件的内容放到后台去维护，通过后台接口获取地区数据源（即 BRCity.json 文件的内容）。

#### 2018-01-25（V2.0.0）

- 更新了地址数据源（BRCity.plist），地区信息是2018年最新最全的，与微信的地区信息完全一致。
- 支持自定义默认选择地址（格式：@[@"浙江省", @"杭州市", @"西湖区"]），支持下次点击进入地址选择器时，默认地址为上次选择的结果。
- 修改了日期选择器、地址选择器、字符串选择器的接口方法（删除了之前的方法2）。
- 添加了地址选择器显示类型，支持3种显示：只显示省份、显示省份和城市、显示省市区。

#### 2018-01-05（V1.3.0）

- 添加取消选择的回调方法（点击背景或取消按钮会执行 `cancelBlock` ）
- 合并了字符串选择器 数组数据源和plist数据源对应的方法，`dataSource` 参数支持两种类型：

#### 2018-01-02（V1.2.0）

- 添加支持自定义主题颜色的方法。

#### 2017-11-26（V1.1.0）

- 更换第三方依赖库。
- 用MJExtension 替换了 原来的YYModel，以前没有注意导入YYModel，同时又导入YYKit会导致重复导入而冲突（另外使用YYModel时，手动导入和pod导入 其中的头文件和方法名也不一样，所以很容易出错）。

#### 2017-11-16（V1.0.0）

- 初始版本！

# 许可证

BRPickerView 使用 MIT 许可证，详情见 LICENSE 文件。