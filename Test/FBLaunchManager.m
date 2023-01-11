//
//  FBLaunchManager.m
//  Test
//
//  Created by 林君毅 on 2023/1/9.
//

#import "FBLaunchManager.h"
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>

#ifdef __LP64__
typedef uint64_t FBMachOExportValue;
typedef struct section_64 FBMachOExportSection;
#define FBGetSectByNameFromHeader getsectbynamefromheader_64
#else
typedef uint32_t FBMachOExportValue;
typedef struct section FBMachOExportSection;
#define FBGetSectByNameFromHeader getsectbynamefromheader
#endif

__attribute__((constructor)) static void executePreMainLaunchers() {
    [[FBLaunchManager sharedInstance] executeLaunchersForStage:FBLaunchStagePreMain];
}

@implementation FBLaunchModule

@end

@interface FBLaunchManager()

@property (nonatomic, strong) NSMutableArray<FBLaunchModule *> *modules;

@end

@implementation FBLaunchManager

+ (id)sharedInstance {
    static id instance;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _modules = [self modulesInDyld].mutableCopy;
    }
    return self;
}

- (NSMutableArray<FBLaunchModule *> *)modulesInDyld {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    NSString *fullAppName = [NSString stringWithFormat:@"/%@.app/", appName];
    char *fullAppNameC = (char *)[fullAppName UTF8String];
    
    NSMutableArray<FBLaunchModule *> *result = [[NSMutableArray alloc] init];

    int num = _dyld_image_count();
    for (int i = 0; i < num; i++) {
        const char *name = _dyld_get_image_name(i);
        if (strstr(name, fullAppNameC) == NULL) {
            continue;
        }
        
        const struct mach_header *header = _dyld_get_image_header(i);
        
        Dl_info info;
        dladdr(header, &info);
        
        const FBMachOExportValue dliFbase = (FBMachOExportValue)info.dli_fbase;
        const FBMachOExportSection *section = FBGetSectByNameFromHeader(header, "__DATA", "__launch");
        if (section == NULL) continue;
        int addrOffset = sizeof(struct LAUNCH_FUNCTION);
        for (FBMachOExportValue addr = section->offset;
             addr < section->offset + section->size;
             addr += addrOffset) {
            
            struct LAUNCH_FUNCTION entry = *(struct LAUNCH_FUNCTION *)(dliFbase + addr);
            FBLaunchModule *module = [[FBLaunchModule alloc] init];
            module.module = [NSString stringWithCString:entry.module encoding:NSUTF8StringEncoding];
            module.stage = entry.stage;
            module.priority = entry.priority;
            module.startMethod = entry.function;
            [result addObject:module];
        }
    }
    return result;
}

- (void)executeLaunchersForStage:(FBLaunchStage)stage {
    if (_modules.count == 0) {
        return;
    }
    NSMutableArray *moduleAry = [NSMutableArray new];
    for (FBLaunchModule *m in _modules) {
        if (m.stage == stage) {
            [moduleAry addObject:m];
        }
    }
        
    [moduleAry sortUsingComparator:^NSComparisonResult(FBLaunchModule * _Nonnull obj1, FBLaunchModule * _Nonnull obj2) {
        return obj1.priority < obj2.priority;
    }];
    
    for (NSInteger i = 0; i < [moduleAry count]; i++) {
        FBLaunchModule *module = moduleAry[i];
        module.moduleInstance = module.startMethod();
    }
}

- (id)getModuleByName:(NSString *)moduleName {
    for (FBLaunchModule *m in _modules) {
        if ([m.module isEqualToString:moduleName]) {
            if (m.moduleInstance) {
                return m.moduleInstance;
            }
            m.moduleInstance = m.startMethod();
            return m.moduleInstance;
        }
    }
    return nil;
}

@end
