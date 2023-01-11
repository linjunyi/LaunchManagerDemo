//
//  AppDelegate.m
//  Test
//
//  Created by 林君毅 on 2023/1/4.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "FBLaunchManager.h"
#import "StatisticsLaunch.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *vc = [ViewController new];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    [[FBLaunchManager sharedInstance] executeLaunchersForStage:FBLaunchStageDidFinishLaunch];
    NSLog(@"Total Launch Time : %.4f", statisticsLaunchTime());
    
    return YES;
}

@end
