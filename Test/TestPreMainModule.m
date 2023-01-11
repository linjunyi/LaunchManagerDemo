//
//  TestPreMainModule.m
//  Test
//
//  Created by 林君毅 on 2023/1/9.
//

#import "TestPreMainModule.h"
#import "FBLaunchManager.h"

LAUNCH_FUNCTION_EXPORT(TestPreMainModule, FBLaunchStagePreMain, FBLaunchPriorityLow) {
    return [TestPreMainModule start];
}

@implementation TestPreMainModule

+ (id)start {
    NSLog(@"TestPreMainModule start");
    return [TestPreMainModule new];
}

@end
