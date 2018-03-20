//
//  NSMutableDictionary+Protect.m
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "NSMutableDictionary+Protect.h"

@implementation NSMutableDictionary (Protect)

+(void)load
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        // 判断是否配置文件是否已经开启nil保护
        if ([CoreConfigManager shared].openNilProtect)
        {
            Class dictCls = NSClassFromString(@"__NSDictionaryM");
            
            // 原始方法
            SEL originalSelectors[] = {
                @selector(setObject:forKey:),
                @selector(removeObjectForKey:)
            };
            
            for (NSUInteger index = 0; index < sizeof(originalSelectors) / sizeof(SEL); index++)
            {
                SEL originalSelector = originalSelectors[index];
                
                SEL swizzledSelector = NSSelectorFromString([@"i_swizzing_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
                
                [HookUtility i_swizzlingInClass:dictCls
                                  originalSelector:originalSelector
                                  swizzledSelector:swizzledSelector];
            }
        }
    });
}

#pragma mark - ******************************************* 方法替换 *********************************

#pragma mark setObject:forKey:

-(void)i_swizzing_setObject:(id)object forKey:(id<NSCopying>)key
{
    if (!object)
    {
        NSLog(@"object is null");
        return;
    }
    if (!key)
    {
        NSLog(@"key is null");
        return;
    }
    [self i_swizzing_setObject:object forKey:key];
}

#pragma mark removeObjectForKey:

-(void)i_swizzing_removeObjectForKey:(id)key
{
    if (!key)
    {
        NSLog(@"key is null");
        return;
    }
    [self i_swizzing_removeObjectForKey:key];
}

@end
