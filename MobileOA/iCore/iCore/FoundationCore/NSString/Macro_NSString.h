//
//  Macro_NSString.h
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#ifndef Macro_NSString_h
#define Macro_NSString_h


#pragma mark - ******************************************* NSString & NSMutableString 判断 **********

// 是否为NSString类型
#define kString_Is_Class(string) [string isKindOfClass:[NSString class]]

// 是否有效，不为空，且是NSString类型，且count值大于0
#define kString_Is_Valid(string) ((string) && (kString_Is_Class(string)) && ([string length] > 0))

// 是否无效，或为空，或不是NSString类型，或count值小于等于0
#define kString_Not_Valid(string) ((!string) || (!kString_Is_Class(string)) || ([string length] <= 0))

// 格式化字符串
#define kString_Format(...) [NSString stringWithFormat:__VA_ARGS__]

// nil保护，当为nil时，返回@""，避免一些Crash
#define kString_Protect(string) ((kString_Is_Valid(string)) ? (string) : (@""))

#endif /* Macro_NSString_h */
