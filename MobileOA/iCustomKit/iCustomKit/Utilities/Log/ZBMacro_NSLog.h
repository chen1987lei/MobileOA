//
//  PMacro_NSLog.h
//  PCustomKit
//
//  Created by renqingyang on 2017/11/9.
//  Copyright © 2017年 ren. All rights reserved.
//

#ifndef PMacro_NSLog_h
#define PMacro_NSLog_h

#pragma mark - ******************************************* 打印个人标志信息 ***************************

#if DEBUG // 测试模式下显示的 Log

#define PkLog_UserInfo_RQY @"👀👀👀 RenQingYang 👀👀👀" // 任清阳 Log

#endif


#pragma mark - ******************************************* 打印信息 *********************************

#pragma mark 任清阳 Log

#ifdef PkLog_UserInfo_RQY
#define PkLog_RQY kLog_Print(PkLog_UserInfo_RQY, @"");
#define PkLog_RQY_(...) kLog_Print(PkLog_UserInfo_RQY, __VA_ARGS__);
#else
#define PkLog_RQY {};
#define PkLog_RQY_(...) {};
#endif

#endif /* PMacro_NSLog_h */
