//
//  main.m
//  Test
//
//  Created by 林君毅 on 2023/1/4.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StatisticsLaunch.h"

int main(int argc, char * argv[]) {
    NSLog(@"Pre Main Launch Time : %.4f", statisticsLaunchTime());
    
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
