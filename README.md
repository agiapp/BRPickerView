# BRPickerView

BRPickerView 封装的是iOS中常用的选择器组件，主要包括：**`BRDatePickerView`** 日期选择器（支持年月日、年月等15种日期样式选择，支持设置星期、至今等）、**`BRTextPickerView`** 文本选择器（支持单列、多列、省市区、省市、省、自定义多级联动选择）。支持自定义主题样式，适配深色模式，支持将选择器组件添加到指定容器视图。

⚠️【特别说明】

>- 从 `V2.9.0` 版本起，新增了`BRTextPickerView` 组件，用于替代 `BRAddressPickerView` 和 `BRStringPickerView` 两个旧组件（目前这两个旧组件做了兼容，可以继续使用，后续会废弃掉，建议使用 `BRTextPickerView` 新组件进行替代）
>- `V2.8.8`之前老版本，在iOS18+系统上，会因 `maskView` 命名出现崩溃问题，请及时升级到最新版本。
>- 如果不能找到最新版本，请先执行一下 `pod repo update ` 更新本地仓库，使 CocoaPods 能识别最新可用的库版本。 

#### 📒 稀土掘金：https://juejin.cn/post/6844903605468676104



# 效果演示

查看并运行 `BRPickerViewDemo.xcodeproj`

| ![效果图1](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/a.gif?raw=true) | ![效果图2](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/b.gif?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                     框架Demo运行效果图1                      |                     框架Demo运行效果图2                      |

# 安装

#### CocoaPods

1. 在 Podfile 中添加 `pod 'BRPickerView'`
2. 执行 `pod install` 或 `pod update` 
3. 导入头文件 ` #import <BRPickerView.h>`

>安装说明：
>
>**pod 'BRPickerView'** ：默认是安装全部组件（包含：`BRDatePickerView` 、 `BRTextPickerView` ，和废弃的`BRAddressPickerView` 、`BRStringPickerView` 组件），等价于：`pod 'BRPickerView/All'`
>
>**pod 'BRPickerView/Default'** ：仅安装`BRDatePickerView` 和 `BRTextPickerView` 组件

#### SPM Supported

1. 依次点击 Xcode 的菜单 File  > Add Package Dependencies...
2. 输出 `https://github.com/agiapp/BRPickerView`搜索并选择，然后点击 Add Package


#### 手动导入

1. 将与 `README.md` 同级目录下的 `BRPickerView` 文件夹拽入项目中（注意：删除PrivacyInfo.xcprivacy文件）

2. 导入头文件 ` #import "BRPickerView.h"`。


# 系统要求

- iOS 9.0+
- ARC

# 使用

### 时间选择器：`BRDatePickerView`

查看 BRDatePickerView.h 头文件，里面提供了两种使用方式，参见源码。

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
    
    // ----- 以下14种是自定义样式 -----
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
    BRDatePickerModeMS,
    
    /** 【yyyy-qq】年季度 */
    BRDatePickerModeYQ,
    /** 【yyyy-MM-ww】年月周 */
    BRDatePickerModeYMW,
    /** 【yyyy-ww】年周 */
    BRDatePickerModeYW
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

| ![样式1：BRDatePickerModeTime](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type1.png?raw=true) | ![样式2：BRDatePickerModeDate](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type2.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                 样式1：BRDatePickerModeDate                  |              样式2：BRDatePickerModeDateAndTime              |
|                                                              |                                                              |
| ![样式3：BRDatePickerModeDateAndTime](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type3.png?raw=true) | ![样式4：BRDatePickerModeCountDownTimer](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type4.png?raw=true) |
|                 样式3：BRDatePickerModeTime                  |            样式4：BRDatePickerModeCountDownTimer             |

- 以下11种样式是使用 UIPickerView 类进行封装的。

| ![样式5：BRDatePickerModeYMDHMS](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type5.png?raw=true) | ![样式6：BRDatePickerModeYMDHM](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type6.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                样式5：BRDatePickerModeYMDHMS                 |                 样式6：BRDatePickerModeYMDHM                 |
|                                                              |                                                              |
| ![样式7：BRDatePickerModeYMDH](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type7.png?raw=true) | ![样式8：BRDatePickerModeMDHM](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type8.png?raw=true) |
|                 样式7：BRDatePickerModeYMDH                  |                 样式8：BRDatePickerModeMDHM                  |
|                                                              |                                                              |
| ![样式9：BRDatePickerModeYMDE](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type9.png?raw=true) | ![样式10：BRDatePickerModeYMD](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type10.png?raw=true) |
|                  样式9：BRDatePickerModeYMD                  |                  样式10：BRDatePickerModeYM                  |
|                                                              |                                                              |
| ![样式11：BRDatePickerModeYM](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type11.png?raw=true) | ![样式12：BRDatePickerModeY](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type12.png?raw=true) |
|                  样式11：BRDatePickerModeY                   |                  样式12：BRDatePickerModeMD                  |
|                                                              |                                                              |
| ![样式13：BRDatePickerModeMD](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type13.png?raw=true) | ![样式14：BRDatePickerModeHMS](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type14.png?raw=true) |
|                 样式13：BRDatePickerModeHMS                  |                  样式14：BRDatePickerModeHM                  |
|                                                              |                                                              |
| ![样式15：BRDatePickerModeHM](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type15.png?raw=true) |                                                              |
|                  样式15：BRDatePickerModeMS                  |                                                              |

- 其它日期样式

| ![设置显示星期](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_week1.png?raw=true) | ![设置显示星期](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_week2.png?raw=true) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 设置显示星期：datePickerView.showWeek = YES;                 | 设置显示星期：datePickerView.showWeek = YES;                 |
|                                                              |                                                              |
| ![设置添加至今](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_now.png?raw=true) | ![设置显示今天](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_today.png?raw=true) |
| 设置添加至今：datePickerView.addToNow = YES;                 | 设置显示今天：datePickerView.showToday = YES;                |
|                                                              |                                                              |
| ![日期单位单行显示样式](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_unit.png?raw=true) | ![自定义选择器选中行颜色](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_row.png?raw=true) |
| 日期单位显示样式：datePickerView.showUnitType = BRShowUnitTypeOnlyCenter; | 设置选择器中间选中行的背景颜色：selectRowColor               |

```objective-c
// 设置选择器中间选中行的样式
BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
customStyle.selectRowColor = [UIColor blueColor];
customStyle.selectRowTextFont = [UIFont boldSystemFontOfSize:20.0f];
customStyle.selectRowTextColor = [UIColor redColor];
datePickerView.pickerStyle = customStyle;
```

| ![英式日期年月日](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_en1.png?raw=true) | ![英式日期年月](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_en2.png?raw=true) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 样式：BRDatePickerModeYMD （默认非中文环境显示英式日期）     | 样式：BRDatePickerModeYM （默认非中文环境显示英式日期）      |

- 几种常见的弹框样式模板

| ![模板样式1](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/template_style1.png?raw=true) | ![模板样式2](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/template_style2.png?raw=true) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 弹框样式模板1：datePickerView.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor blueColor]]; | 弹框样式模板2：datePickerView.pickerStyle = [BRPickerStyle pickerStyleWithDoneTextColor:[UIColor blueColor]]; |
|                                                              |                                                              |
| ![模板样式3](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/template_style3.png?raw=true) | ![添加选择器的头视图](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/date_type_top.png?raw=true) |
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



### 文本选择器：`BRTextPickerView`

查看 BRTextPickerView.h 头文件，提供了三种类型：

```objective-c
/// 文本选择器类型
typedef NS_ENUM(NSInteger, BRTextPickerMode) {
    /** 单列选择器 */
    BRTextPickerComponentSingle,
    /** 多列选择器 */
    BRTextPickerComponentMulti,
    /** 多列联动选择器 */
    BRTextPickerComponentCascade
};
```

#### 1. 单列文本选择器

- 使用示例：

```objective-c
/// 单列文本选择器
BRTextPickerView *textPickerView = [[BRTextPickerView alloc]initWithPickerMode:BRTextPickerComponentSingle];
textPickerView.title = @"学历";
// 设置数据源
textPickerView.dataSourceArr = @[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"];
textPickerView.selectIndex = self.mySelectIndex;
textPickerView.singleResultBlock = ^(BRTextModel * _Nullable model, NSInteger index) {
  	NSLog(@"选择的值：%@", model.text);
    self.mySelectIndex = index;
    textField.text = model.text;
};
[textPickerView show];
```

- 设置数据源有3种方式

```objective-c
// 方式1：传字符串数组
textPickerView.dataSourceArr = @[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"];
```

```objective-c
// 方式2：直接传入 plist 文件名（可以将上面的字符串数组放到本地plist文件中，如：education_data.plist）
textPickerView.fileName = @"education_data.plist";
```

```objective-c
// 方式3：传入一维模型数组(NSArray <BRTextModel *>*)
NSArray *dataArr = @[@{@"code": @"1", @"text": @"大专以下"},
                     @{@"code": @"2", @"text": @"大专"},
                     @{@"code": @"3", @"text": @"本科"},
                     @{@"code": @"4", @"text": @"硕士"},
                     @{@"code": @"5", @"text": @"博士"},
                     @{@"code": @"6", @"text": @"博士后"}];
// 将上面数组 转为 模型数组（组件内封装的工具方法）
NSArray<BRTextModel *> *modelArr = [NSArray br_modelArrayWithJson:dataArr mapper:nil];
textPickerView.dataSourceArr = modelArr;
```

说明：当字典key 与 BRTextModel模型的属性不匹配时，需要指定模型属性与字典key的映射关系

```objective-c
/// 单列文本选择器
BRTextPickerView *textPickerView = [[BRTextPickerView alloc]initWithPickerMode:BRTextPickerComponentSingle];
textPickerView.title = @"融资情况";
// 方式3：传入一维模型数组(NSArray <BRTextModel *>*)
NSArray *dataArr = @[@{@"key": @"1001", @"value": @"无融资", @"remark": @""},
                     @{@"key": @"2001", @"value": @"天使轮", @"remark": @""},
                     @{@"key": @"3001", @"value": @"A轮", @"remark": @""},
                     @{@"key": @"4001", @"value": @"B轮", @"remark": @""},
                     @{@"key": @"5001", @"value": @"C轮以后", @"remark": @""},
                     @{@"key": @"6001", @"value": @"已上市", @"remark": @""}];
// 指定 BRTextModel模型的属性 与 字典key 的映射关系
NSDictionary *mapper = @{ @"code": @"key", @"text": @"value", @"extras": @"remark" };
// 将上面数组 转为 模型数组（组件内封装的工具方法）
NSArray<BRTextModel *> *modelArr = [NSArray br_modelArrayWithJson:dataArr mapper:mapper];
textPickerView.dataSourceArr = modelArr;
textPickerView.singleResultBlock = ^(BRTextModel * _Nullable model, NSInteger index) {
  	NSLog(@"选择的值：%@", model.text);
};
[textPickerView show];
```

- 单列文本选择器效果图：

| ![自定义单列字符串](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/text_single_xueli.png?raw=true) | ![融资情况](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/text_single_rongzi.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |



#### 2. 多列文本选择器

- 使用示例：

```objective-c
/// 多列文本选择器
BRTextPickerView *textPickerView = [[BRTextPickerView alloc]initWithPickerMode:BRTextPickerComponentMulti];
textPickerView.title = @"多列文本选择器";
// 设置数据源
textPickerView.dataSourceArr = @[@[@"语文", @"数学", @"英语"], @[@"优秀", @"良好"]];
textPickerView.selectIndexs = self.mySelectIndexs;
textPickerView.multiResultBlock = ^(NSArray<BRTextModel *> * _Nullable models, NSArray<NSNumber *> * _Nullable indexs) {
		self.mySelectIndexs = indexs;
    // 将模型数组元素的 text 属性值，通过分隔符-连接成字符串（组件内封装的工具方法）
    NSString *selectText = [models br_joinText:@"-"];
    NSLog(@"选择的结果：%@", selectText);
};
[textPickerView show];
```

- 多列文本选择器设置数据源同单列一样，也有3种方式：

```objective-c
// 方式1：多维字符串数组
textPickerView.dataSourceArr = @[@[@"语文", @"数学", @"英语"], @[@"优秀", @"良好"]];
```

```objective-c
// 方式2：直接传入 plist 文件名（可以将上面的数组放到本地plist文件中，如：grade_level_data.plist）
textPickerView.fileName = @"grade_level_data.plist";
```

```objective-c
// 方式3：传入多维模型数组
NSArray *subjectDataArr = @[@{@"subject_id": @"11", @"subject": @"语文"}, @{@"subject_id": @"12", @"subject": @"数学"}, @{@"subject_id": @"13", @"subject": @"英语"}];
NSArray *gradeDataArr = @[@{@"grade_id": @"1", @"grade": @"优秀"}, @{@"grade_id": @"2", @"grade": @"良好"}];
// 将上面数组 转为 模型数组（组件内封装的工具方法）
NSArray *subjectModelArr = [NSArray br_modelArrayWithJson:subjectDataArr mapper:@{ @"code": @"subject_id", @"text": @"subject" }];
NSArray *gradeModelArr = [NSArray br_modelArrayWithJson:gradeDataArr mapper:@{ @"code": @"grade_id", @"text": @"grade" }];
textPickerView.dataSourceArr = @[subjectModelArr, gradeModelArr];
```

- 另外还可以设置更多自定义样式

```objective-c
/// 多列文本选择器
BRTextPickerView *textPickerView = [[BRTextPickerView alloc]initWithPickerMode:BRTextPickerComponentMulti];
textPickerView.title = @"自定义多列字符串";
textPickerView.dataSourceArr = @[@[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12"], @[@"00", @"10", @"20", @"30", @"40", @"50"]];
textPickerView.selectIndexs = self.mySelectIndexs;
textPickerView.multiResultBlock = ^(NSArray<BRTextModel *> * _Nullable models, NSArray<NSNumber *> * _Nullable indexs) {
  	self.mySelectIndexs = indexs;
    // 将模型数组元素的 text 属性值，通过:分隔符 连接成字符串（组件内封装的工具方法）
    NSString *selectText = [models br_joinText:@":"];
    NSLog(@"选择的结果：%@", selectText);
};

// 设置自定义样式
BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
// 设置 picker 的列宽
customStyle.columnWidth = 30;
// 设置 picker 的列间隔
customStyle.columnSpacing = 60;
// 设置圆角矩形背景
// 方式1：使用系统自带样式，保留iOS14之后系统默认的圆角样式。
customStyle.clearPickerNewStyle = NO;
// 方式2：可以使用UIView自定义一个圆角矩形视图rectView，并添加到 alertView 上也能实现同样的效果（[textPickerView.alertView addSubview:rectView];）
// 设置选择器中间选中行的样式
customStyle.selectRowTextFont = [UIFont boldSystemFontOfSize:20.0f];
customStyle.selectRowTextColor = [UIColor blueColor];
textPickerView.pickerStyle = customStyle;

[textPickerView show];
```

- 多列文本选择器效果图：

| ![多列文本选择器](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/text_multi_grade.png?raw=true) | ![多列文本选择器](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/text_multi_time.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |



#### 3. 多列联动文本选择器

- 使用示例：

```objective-c
/// 多列联动文本选择器
BRTextPickerView *textPickerView = [[BRTextPickerView alloc]initWithPickerMode:BRTextPickerComponentCascade];
textPickerView.title = @"多列联动文本选择器";
NSArray *dataArr = @[
    @{
        @"text" : @"浙江省",
        @"children" : @[
            @{ @"text": @"杭州市", @"children": @[@{ @"text": @"西湖区" }, @{ @"text": @"滨江区" }] },
            @{ @"text": @"宁波市", @"children": @[@{ @"text": @"海曙区" }, @{ @"text": @"江北区" }] },
            @{ @"text": @"温州市", @"children": @[@{ @"text": @"鹿城区" }, @{ @"text": @"龙湾区" }] }
      ]
    },
    @{
        @"text" : @"江苏省",
        @"children" : @[
            @{ @"text": @"南京市", @"children": @[@{ @"text": @"玄武区" }, @{ @"text": @"秦淮区" }] },
            @{ @"text": @"苏州市", @"children": @[@{ @"text": @"虎丘区" }, @{ @"text": @"吴中区" }] }
      ]
    },
    @{
        @"text" : @"辽宁省",
        @"children" : @[
            @{ @"text": @"沈阳市", @"children": @[@{ @"text": @"沈河区" }, @{ @"text": @"和平区" }] },
            @{ @"text": @"大连市", @"children": @[@{ @"text": @"中山区" }, @{ @"text": @"金州区" }] }
      ]
    }
];
// 设置数据源：传树状结构模型数组(NSArray <BRTextModel *>*)
textPickerView.dataSourceArr = [NSArray br_modelArrayWithJson:dataArr mapper:nil];
textPickerView.selectIndexs = self.mySelectIndexs;
textPickerView.multiResultBlock = ^(NSArray<BRTextModel *> * _Nullable models, NSArray<NSNumber *> * _Nullable indexs) {
    self.mySelectIndexs = indexs;
  	// 将模型数组元素的 text 属性值，通过-分隔符 连接成字符串（组件内封装的工具方法）
    NSString *selectText = [models br_joinText:@"-"];
    NSLog(@"选择的结果：%@", selectText);
};
[textPickerView show];
```



- 实现省、市、区/县选择（使用本地数据源：region_tree_data.json）

```objective-c
// 地区
BRTextPickerView *textPickerView = [[BRTextPickerView alloc]initWithPickerMode:BRTextPickerComponentCascade];
textPickerView.title = @"请选择地区";
// 设置数据源：传入本地json文件名（可以下载Demo中的 region_tree_data.json 文件放到自己的项目中，该数据源来源于高德地图最新数据）
textPickerView.fileName = @"region_tree_data.json";
// 设置选择器显示的列数(即层级数)，默认是根据数据源层级动态计算显示。如：设置1则只显示前1列数据（即只显示省）；设置2则只显示前2列数据（即只显示省、市）；设置3则只显示前3列数据（即显示省、市、区）
textPickerView.showColumnNum = 3;
textPickerView.selectIndexs = self.addressSelectIndexs;
textPickerView.multiResultBlock = ^(NSArray<BRTextModel *> * _Nullable models, NSArray<NSNumber *> * _Nullable indexs) {
    self.addressSelectIndexs = indexs;
    // 将模型数组元素的 text 属性值，通过-分隔符 连接成字符串（组件内封装的工具方法）
    NSString *selectText = [models br_joinText:@"-"];
    NSLog(@"选择的结果：%@", selectText);
    textField.text = selectText;
};
[textPickerView show];
```

- 地址文本选择器的3种显示效果

| ![地区](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/text_cascade_area.png?raw=true) | ![城市](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/text_cascade_city.png?raw=true) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 样式1：textPickerView.showColumnNum = 3;                     | 样式2：textPickerView.showColumnNum = 2;                     |
|                                                              |                                                              |
| ![省份](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/text_cascade_province.png?raw=true) |                                                              |
| 样式3：textPickerView.showColumnNum = 1;                     |                                                              |

>高德地图行政区划数据源（省、市、区/县），数据更新于2024年7月
>
>- 原数据：[amap_region_data.json](https://raw.githubusercontent.com/agiapp/BRPickerView/master/BRPickerViewDemo/DataFile/amap_region_data.json)
>- 处理后的树状结构数据1：[region_tree_data.json](https://raw.githubusercontent.com/agiapp/BRPickerView/master/BRPickerViewDemo/DataFile/region_tree_data.json) （组件使用本地数据源时，需要下载的文件）
>- 处理后的树状结构数据2：[region_list_data.json](https://raw.githubusercontent.com/agiapp/BRPickerView/master/BRPickerViewDemo/DataFile/region_list_data.json)



- 处理树状结构数据

```json
{
    "status": "1",
    "info": "OK",
    "districts": [
        {
            "adcode": "330000",
            "name": "浙江省",
            "districts" : [
                { "adcode" : "330100", "name": "杭州市", "districts": [{ "adcode" : "330106", "name": "西湖区" }, { "adcode" : "330108", "name": "滨江区" }] },
                { "adcode" : "330200", "name": "宁波市", "districts": [{ "adcode" : "330203", "name": "海曙区" }, { "adcode" : "330205", "name": "江北区" }] },
                { "adcode" : "330300", "name": "温州市", "districts": [{ "adcode" : "330302", "name": "鹿城区" }, { "adcode" : "330303", "name": "龙湾区" }] }
            ]
        },
        {
            "adcode": "320000",
            "name": "江苏省",
            "districts" : [
                { "adcode" : "320100", "name": "南京市", "districts": [{ "adcode" : "320102", "name": "玄武区" }, { "adcode" : "320104", "name": "秦淮区" }] },
                { "adcode" : "320500", "name": "苏州市", "districts": [{ "adcode" : "320505", "name": "虎丘区" }, { "adcode" : "320506", "name": "吴中区" }] }
            ]
        },
        {
            "adcode": "210000",
            "name": "辽宁省",
            "districts" : [
                { "adcode" : "210100", "name": "沈阳市", "districts": [{ "adcode" : "210103", "name": "沈河区" }, { "adcode" : "210102", "name": "和平区" }] },
                { "adcode" : "210200", "name": "大连市", "districts": [{ "adcode" : "210202", "name": "中山区" }, { "adcode" : "210213", "name": "金州区" }] }
            ]
        }
    ]
}
```

```objective-c
/// 多列联动文本选择器
BRTextPickerView *textPickerView = [[BRTextPickerView alloc]initWithPickerMode:BRTextPickerComponentCascade];
textPickerView.title = @"多列联动文本选择器";

// 接收网络请求结果数据（下面省略号表示省略部分代码）
NSArray *dataArr = ...... responseObject[@"districts"];
// 指定 BRTextModel模型的属性 与 字典key 的映射关系
NSDictionary *mapper = @{ @"code": @"adcode", @"text": @"name", @"children": @"districts" };
// 将上面数组 转为 模型数组（组件内封装的工具方法）
NSArray<BRTextModel *> *modelArr = [NSArray br_modelArrayWithJson:dataArr mapper:mapper];
textPickerView.dataSourceArr = modelArr;
textPickerView.multiResultBlock = ^(NSArray<BRTextModel *> * _Nullable models, NSArray<NSNumber *> * _Nullable indexs) {
    // 将模型数组元素的 text 属性值，通过-分隔符 连接成字符串（组件内封装的工具方法）
  	NSString *selectText = [models br_joinText:@"-"];
    NSLog(@"选择的结果：%@", selectText);
};
[textPickerView show];
```

- 处理扁平结构数据

```json
{
  "Code" : 200,
  "Msg" : "获取成功",
  "Result" : [
      {
        "ParentID" : "-1",
        "ParentName" : "",
        "CategoryID" : "330000",
        "CategoryName" : "浙江省"
      },
      {
        "ParentID" : "-1",
        "ParentName" : "",
        "CategoryID" : "320000",
        "CategoryName" : "江苏省"
      },
      {
        "ParentID" : "-1",
        "ParentName" : "",
        "CategoryID" : "210000",
        "CategoryName" : "辽宁省"
      },
      {
        "ParentID" : "330000",
        "ParentName" : "浙江省",
        "CategoryID" : "330100",
        "CategoryName" : "杭州市"
      },
      {
        "ParentID" : "330000",
        "ParentName" : "浙江省",
        "CategoryID" : "330200",
        "CategoryName" : "宁波市"
      },
      {
        "ParentID" : "330000",
        "ParentName" : "浙江省",
        "CategoryID" : "330300",
        "CategoryName" : "温州市"
      },
      {
        "ParentID" : "320000",
        "ParentName" : "江苏省",
        "CategoryID" : "320100",
        "CategoryName" : "南京市"
      },
      {
        "ParentID" : "320000",
        "ParentName" : "江苏省",
        "CategoryID" : "320500",
        "CategoryName" : "苏州市"
      },
      {
        "ParentID" : "210000",
        "ParentName" : "辽宁省",
        "CategoryID" : "210100",
        "CategoryName" : "沈阳市"
      },
      {
        "ParentID" : "210000",
        "ParentName" : "辽宁省",
        "CategoryID" : "210200",
        "CategoryName" : "大连市"
      }
  ]
}
```

```objective-c
/// 多列联动文本选择器
BRTextPickerView *textPickerView = [[BRTextPickerView alloc]initWithPickerMode:BRTextPickerComponentCascade];
textPickerView.title = @"多列联动文本选择器";

// 接收网络请求结果数据（下面省略号表示省略部分代码）
NSArray *dataArr = ...... responseObject[@"Result"];
// 指定 BRTextModel模型的属性 与 字典key 的映射关系
NSDictionary *mapper = @{ @"parentCode": @"ParentID", @"code": @"CategoryID", @"text": @"CategoryName" };
// 1.先将上面数组 转为 模型数组（组件内封装的工具方法）。如果数据源是多个数组，需要自己先手动组装成一个NSArray<BRTextModel *>类型的扁平结构模型数组。
NSArray<BRTextModel *> *listModelArr = [NSArray br_modelArrayWithJson:dataArr mapper:mapper];
// 2.将扁平结构模型数组 转成 树状结构模型数组（组件内封装的工具方法）
NSArray<BRTextModel *> *treeModelArr = [listModelArr br_buildTreeArray];
textPickerView.dataSourceArr = treeModelArr;

textPickerView.multiResultBlock = ^(NSArray<BRTextModel *> * _Nullable models, NSArray<NSNumber *> * _Nullable indexs) {
    // 将模型数组元素的 text 属性值，通过-分隔符 连接成字符串（组件内封装的工具方法）
  	NSString *selectText = [models br_joinText:@"-"];
    NSLog(@"选择的结果：%@", selectText);
    // 获取选择模型指定属性（如：code）组成的数组（组件内封装的工具方法）
    NSArray *selectIDs = [models br_getValueArr:@"code"];
};

// 设置选择器中间选中行的样式
BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
customStyle.selectRowTextFont = [UIFont boldSystemFontOfSize:20.0f];
customStyle.selectRowTextColor = [UIColor blueColor];
customStyle.columnWidth = 80;
customStyle.columnSpacing = 10;
textPickerView.pickerStyle = customStyle;

[textPickerView show];
```

- 多列联动文本选择器效果图：

| ![三列联动文本选择器](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/text_cascade_three.png?raw=true) | ![两列字符串选择器](https://github.com/agiapp/BRPickerView/blob/master/BRPickerViewDemo/images/text_cascade_two.png?raw=true) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |



补充说明：对于一些需要特殊定制弹框的应用场景，可以使用下面的方法把日期选择器/文本选择器到指定容器视图上，实现个性化的弹框需求。

```objective-c
/// 扩展一：添加选择器到指定容器视图上
/// 应用场景：可将中间的滚轮选择器 pickerView 视图（不包含蒙层及标题栏）添加到任何自定义视图上（会自动填满容器视图），也方便自定义更多的弹框样式
/// 补充说明：如果是自定义确定按钮，需要回调默认选择的值：只需在自定义确定按钮的点击事件方法里执行一下 doneBlock 回调（目的是去触发组件内部执行 resultBlock 回调，进而回调默认选择的值）
/// @param view 容器视图
- (void)addPickerToView:(nullable UIView *)view;
```



# 更新记录

#### 2025-05-27（V2.9.7）

- 修改 Swift Package Manager 集成方式

#### 2025-05-21（V2.9.6）

- fix：[#318](https://github.com/agiapp/BRPickerView/issues/318) 

#### 2025-04-22（V2.9.5）

- fix：[#319](https://github.com/agiapp/BRPickerView/issues/319) 、[#326](https://github.com/agiapp/BRPickerView/issues/326) 、[#340](https://github.com/agiapp/BRPickerView/issues/340) 

#### 2025-03-16（V2.9.3）

- [#336](https://github.com/agiapp/BRPickerView/issues/336) ：优化选择年月日时分秒时，UI显示最后一个秒显示不全问题

#### 2024-07-24（V2.9.1）

- 新增 maxTextLines 属性
- 取消 selectRowAnimated 属性 readonly 限制

#### 2024-07-17（V2.9.0）

- 新增 BRTextPickerView 文本选择组件（用于替代BRAddressPickerView、BRStringPickerView组件）

#### 2024-07-02（V2.8.8）

- [#310](https://github.com/agiapp/BRPickerView/issues/310) ：更新本地省市区数据源数据

- [#314](https://github.com/agiapp/BRPickerView/issues/314) ：修改maskView视图命名，解决因命名冲突在iOS 18 上出现的崩溃问题

#### 2024-05-28（V2.8.7）

- 解决已知问题：[#308](https://github.com/agiapp/BRPickerView/issues/308) 、[#309](https://github.com/agiapp/BRPickerView/issues/309) 
- 时间选择器新增 `twelveHourMode` 属性，支持设置12小时制
- 支持 Swift Package Manager

#### 2024-04-28（V2.8.5）

- 解决已知问题：[#305](https://github.com/agiapp/BRPickerView/issues/305) 
- 添加可设置选择器组件的列宽属性：`columnWidth`
- 添加可设置`BRStringPickerView` 选择器组件的列间隔属性：`columnSpacing`

#### 2024-04-23（V2.8.2）

- 解决已知问题：[#304](https://github.com/agiapp/BRPickerView/issues/304) 

- Add PrivacyInfo.xcprivacy

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

- 解决已知问题：[#232](https://github.com/agiapp/BRPickerView/issues/232) 、[#231](https://github.com/agiapp/BRPickerView/issues/231)  、[#230](https://github.com/agiapp/BRPickerView/issues/230)  、[#227](https://github.com/agiapp/BRPickerView/issues/227)  、[#225](https://github.com/agiapp/BRPickerView/issues/225) 、[#219](https://github.com/agiapp/BRPickerView/issues/219) 、[#206](https://github.com/agiapp/BRPickerView/issues/206) 

#### 2020-09-25（V2.7.3）

- 适配选择器iOS14的样式：[#189](https://github.com/agiapp/BRPickerView/issues/189) 、[#191](https://github.com/agiapp/BRPickerView/issues/191)

#### 2020-09-23（V2.7.2）

- 日期选择器新增添加自定义字符串属性：`firstRowContent` 和 `lastRowContent`
- 解决日期选择器设置最小日期时，存在的联动不正确的问题：[#184](https://github.com/agiapp/BRPickerView/issues/184) 

#### 2020-08-28（V2.7.0）

- 日期选择器添加 `nonSelectableDates` 属性：[#178](https://github.com/agiapp/BRPickerView/issues/178) 
- 优化选中行文本显示：[#177](https://github.com/agiapp/BRPickerView/issues/177) 

#### 2020-08-16（V2.6.8）

- 优化代码，适配 iPad 分屏显示
- 新增 `keyView` 属性（即组件的父视图：可以将组件添加到 自己获取的 keyWindow 上，或页面的 view 上）

#### 2020-08-09（V2.6.7）

- 适配 iOS14

#### 2020-08-06（V2.6.6）

- 修复 [#163](https://github.com/agiapp/BRPickerView/issues/163) 和  [#170](https://github.com/agiapp/BRPickerView/issues/170) 

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

- 修复 [#138](https://github.com/agiapp/BRPickerView/issues/138) 和 [#142](https://github.com/agiapp/BRPickerView/issues/142)
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
