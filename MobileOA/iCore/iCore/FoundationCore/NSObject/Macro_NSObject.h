//
//  Macro_NSObject.h
//  iCore 
//
//  Created by renqingyang on 2017/12/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#ifndef Macro_NSObject_h
#define Macro_NSObject_h

#define kObject_Is_Null(object) (object == nil || [object isKindOfClass:[NSNull class]])

#define kObject_Is_Empty(object) (object == nil || [object isKindOfClass:[NSNull class]] \
|| ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0) \
|| ([object respondsToSelector:@selector(count)] && [(NSArray *)object count] == 0))

#endif /* Macro_NSObject_h */
