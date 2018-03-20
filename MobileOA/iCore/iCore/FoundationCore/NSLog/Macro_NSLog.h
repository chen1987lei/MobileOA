//
//  Macro_NSLog.h
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#ifndef Macro_NSLog_h
#define Macro_NSLog_h

#pragma mark - ******************************************* 测试环境下才显示 Log ***********************

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) \
{              \
}
#endif

#pragma mark - ******************************************* 打印 基础信息 ******************************

// 打印 Log 使用，能打印 Log 所在的文件夹、函数名等细节
#define FUNCNAME [NSString stringWithFormat:@"%s 第 %d 行", __func__, __LINE__]

// 调用公共方法打印 Log
#define kLog_Print(userInfo, ...) [[LogInfo shared] i_printLogWithUserInfo:userInfo \
                                                                        comInfo:FUNCNAME \
                                                                       showInfo:\
                                                [NSString stringWithFormat:__VA_ARGS__]]

#pragma mark - ******************************************* 打印 dealloc 信息 *************************

#if DEBUG
#define kLog_Dealloc_Info kLog_Print(@"💋💋💋号外！号外！%@ dealloc 释放了💋💋💋", @"")
#define kLog_Dealloc_Info_(...) kLog_Print(@"💋💋💋号外！号外！%@ dealloc 释放了💋💋💋", __VA_ARGS__)
#else
#define kLog_Dealloc_Info {};
#define kLog_Dealloc_Info_(...) {};
#endif


#pragma mark - ******************************************* 打印 控制台信息 ****************************

#define kLog_Terminal_Info_(...) [[LogInfo shared] i_printTerminalLogInfo:\
                                                    [NSString stringWithFormat:__VA_ARGS__]];

#pragma mark - ******************************************* 打印 Foundation 中信息 ********************

#if DEBUG
#define kLog_Foundation_Info kLog_Print(@"🐂🐂🐂Foundation 信息", @"")
#define kLog_Foundation_Info_(...) kLog_Print(@"🐂🐂🐂Foundation 信息", __VA_ARGS__)
#else
#define kLog_Foundation_Info {};
#define kLog_Foundation_Info_(...) {};
#endif

#endif /* Macro_NSLog_h */
