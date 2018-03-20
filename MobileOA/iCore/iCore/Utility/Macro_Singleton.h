//
//  Macro_Singleton.h
//  iCore 
//
//  Created by renqingyang on 2017/12/21.
//  Copyright © 2017年 ren. All rights reserved.
//

#ifndef Macro_Singleton_h
#define Macro_Singleton_h

#define kSingleton_h + (instancetype _Nullable)shared;

#define kSingleton_m(ClassName)  \
static ClassName *_sharedInstance = nil; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
@synchronized(self)\
{\
    if (_sharedInstance == nil)\
    {\
        _sharedInstance = [super allocWithZone:zone];\
        return _sharedInstance;\
    }\
}\
return nil;\
} \
\
+ (instancetype)shared \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_sharedInstance = [[super allocWithZone:NULL] init]; \
}); \
return _sharedInstance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _sharedInstance; \
}

#endif /* Macro_Singleton_h */
