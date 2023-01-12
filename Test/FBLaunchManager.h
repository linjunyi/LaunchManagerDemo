//
//  FBLaunchManager.h
//  Test
//
//  Created by 林君毅 on 2023/1/9.
//

#import <Foundation/Foundation.h>

#define LAUNCH_MODULE_EXPORT(module, stage, priority) \
static id _LAUNCH_START_##module(void); \
__attribute__((used, section("__DATA,__launch"))) \
static const struct LAUNCH_MODULE _LAUNCH_MODULE_##module = (struct LAUNCH_MODULE){(char *)&#module, stage, priority, (void *)(&_LAUNCH_START_##module)}; \
static id _LAUNCH_START_##module(void) \

struct LAUNCH_MODULE {
    char *module;
    int stage;
    int priority;
    id (*startFunc)(void);
};

typedef NS_ENUM(NSInteger, FBLaunchStage) {
    FBLaunchStagePreMain = 0,
    FBLaunchStageWillFinishLaunch = 1,
    FBLaunchStageDidFinishLaunch = 2,
    FBLaunchStageWillShowFirstScreen = 3,
    FBLaunchStageDidShowFirstScreen = 4,
    FBLaunchStageLazyLoad = 5,
};

typedef NS_ENUM(NSInteger, FBLaunchPriority) {
    FBLaunchPriorityLow = 0,
    FBLaunchPriorityMid = 1,
    FBLaunchPriorityHigh = 2,
};

@interface FBLaunchModule : NSObject

@property (nonatomic, strong) NSString *module;
@property (nonatomic, assign) FBLaunchStage stage;
@property (nonatomic, assign) FBLaunchPriority priority;
@property (nonatomic, assign) id(*startFunc)(void);
@property (nonatomic, assign) BOOL alreadStart;
@property (nonatomic, strong) id moduleInstance;

@end

@interface FBLaunchManager : NSObject

+ (id)sharedInstance;
- (void)executeLaunchersForStage:(FBLaunchStage)stage;
- (id)getModuleByName:(NSString *)moduleName;

@end
