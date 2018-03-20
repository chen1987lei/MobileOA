//
//  LogInfo.m
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "LogInfo.h"

#import "Macro_DeviceInfo.h"

@implementation LogInfo

kSingleton_m(LogInfo)

#pragma mark - ******************************************* Init and Uninit *************************

#pragma mark - ******************************Setter & Getter****************************************

- (NSDateFormatter *)printLogDateFormatter
{
    if (!_printLogDateFormatter)
    {
        _printLogDateFormatter = [[NSDateFormatter alloc] init];
        [_printLogDateFormatter setDateFormat:@"hh:mm:ss SSSS"];
    }
    return _printLogDateFormatter;
}

#pragma mark - ******************************************* 对外方法 **********************************

- (void)i_printLogWithUserInfo:(NSString *)userInfoString
                        comInfo:(NSString *)comInfoString
                       showInfo:(id)info
{
#ifdef kDevice_is_simulator // 模拟器下，使用NSLog
    if (!info)
    {
        NSLog(@"[%@] %@", userInfoString, comInfoString);
    }
    else
    {
        NSLog(@"[%@] %@  %@", userInfoString, comInfoString, info);
    }
#else // 真机下，使用printf
    // 获取当前时间
    NSString *dateString = [self.printLogDateFormatter stringFromDate:[NSDate date]];
    
    // 使用UTF8String的原因就是printf是C语言的，所以需要通过这个方法转换一下才能打印。
    if (!info)
    {
        printf("T: <%s> [%s] %s\n",
               [dateString UTF8String],
               [userInfoString UTF8String],
               [comInfoString UTF8String]);
    }
    else
    {
        printf("T: <%s> [%s] %s 内容是: %s\n",
               [dateString UTF8String],
               [userInfoString UTF8String],
               [comInfoString UTF8String],
               [info UTF8String]);
    }
#endif
}

- (void)i_printTerminalLogInfo:(id)info
{
    if ([CoreConfigManager shared].hiMode)
    {
        // 获取当前时间
        NSString *dateString = [self.printLogDateFormatter stringFromDate:[NSDate date]];
        
        if (info)
        {
            printf("T 🐯终端🐯: <%s> %s\n",
                   [dateString UTF8String],
                   [info UTF8String]);
        }
        else
        {
            printf("T 🐯终端🐯: <%s>\n",
                   [dateString UTF8String]);
        }
    }
}
#pragma mark - ******************************************* 类方法 ***********************************

@end
