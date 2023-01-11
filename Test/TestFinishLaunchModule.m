//
//  TestFinishLaunchModule.m
//  Test
//
//  Created by 林君毅 on 2023/1/9.
//

#import "TestFinishLaunchModule.h"
#import "FBLaunchManager.h"

LAUNCH_FUNCTION_EXPORT(TestFinishLaunchModule, FBLaunchStageDidFinishLaunch, FBLaunchPriorityLow) {
    return [TestFinishLaunchModule start];
}

@implementation TestFinishLaunchModule

+ (id)start {
    NSLog(@"TestFinishLaunchModule start");
    return [TestFinishLaunchModule new];
}

@end
