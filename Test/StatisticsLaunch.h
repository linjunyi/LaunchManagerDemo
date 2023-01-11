//
//  StatisticsLaunchTime.h
//  Test
//
//  Created by 林君毅 on 2023/1/9.
//

#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
#import <mach/mach.h>

NS_ASSUME_NONNULL_BEGIN

static BOOL getProcessInfo(int pid , struct kinfo_proc*procInfo)
{
    int cmd[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};
    size_t size = sizeof(*procInfo);
    return sysctl(cmd, sizeof(cmd)/sizeof(*cmd), procInfo, &size, NULL, 0) == 0;
}

static NSTimeInterval statisticsLaunchTime(void)
{
    struct kinfo_proc kProcInfo;
    if (getProcessInfo([[NSProcessInfo processInfo] processIdentifier],&kProcInfo)) {
        NSTimeInterval startTime = kProcInfo.kp_proc.p_un.__p_starttime.tv_sec * 1000 + kProcInfo.kp_proc.p_un.__p_starttime.tv_usec / 1000.0; //转为毫秒
        NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970] * 1000;
        return (curTime - startTime) / 1000.0;
    }
    return -1;
}

@interface StatisticsLaunch : NSObject

@end

NS_ASSUME_NONNULL_END
