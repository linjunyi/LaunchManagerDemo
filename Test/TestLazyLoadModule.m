//
//  TestLazyLoadModule.m
//  Test
//
//  Created by 林君毅 on 2023/1/9.
//

#import "TestLazyLoadModule.h"
#import "FBLaunchManager.h"

@implementation TestLazyLoadModule

LAUNCH_FUNCTION_EXPORT(TestLazyLoadModule, FBLaunchStageLazyLoad, FBLaunchPriorityLow) {
    return [TestLazyLoadModule start];
}

+ (id)start {
    NSLog(@"TestLazyLoadModule start");
    return [TestLazyLoadModule new];
}

@end
