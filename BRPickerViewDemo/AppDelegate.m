//
//  AppDelegate.m
//  BRPickerViewDemo
//
//  Created by renbo on 2017/8/11.
//  Copyright © 2017 irenb. All rights reserved.
//

#import "AppDelegate.h"
#import "TestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupRootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupRootViewController {
    TestViewController *testVC = [[TestViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:testVC];
    // 设置navigationBar所有子控件的颜色
    nav.navigationBar.tintColor = [UIColor blackColor];
    
    // 解决 iOS15 导航栏(Navigation)变白(导航栏不见)
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundColor = [UIColor whiteColor]; // 设置navigationBar背景颜色
        // 静止样式
        nav.navigationBar.standardAppearance = appearance;
        // 滚动样式（带scroll滑动的页面。iOS13新增scrollEdgeAppearance属性，在iOS15之前此属性只应用在大标题导航栏上，在iOS15中此属性适用于所有导航栏）
        nav.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        nav.navigationBar.barTintColor = [UIColor whiteColor]; // 设置navigationBar背景颜色
    }

    self.window.rootViewController = nav;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
