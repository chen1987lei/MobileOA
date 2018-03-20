//
//  NSDictionary+Protect.m
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "NSDictionary+Protect.h"

#import <objc/runtime.h>

@implementation NSDictionary (Protect)

+(void)load
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        // 判断是否配置文件是否已经开启nil保护
        if ([CoreConfigManager shared].openNilProtect)
        {
            Class dictCls = NSClassFromString(@"__NSPlaceholderDictionary");

            // 原始方法
            SEL originalSelectors[] = {
                @selector(initWithObjects:forKeys:count:)
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
- (instancetype)i_swizzing_initWithObjects:(const id _Nonnull [_Nullable])objects
                                    forKeys:(const id <NSCopying> _Nonnull [_Nullable])keys
                                      count:(NSUInteger)count
{
    if (count == 0)
    {
        return [self i_swizzing_initWithObjects:objects forKeys:keys count:0];
    }
    if (!objects)
    {
        NSLog(@"objects is nil");
        return nil;
    }
    if (!keys)
    {
        NSLog(@"keys is nil");
        return nil;
    }
    
    // 指向objects初始位置
    NSUInteger valueCnt = 0;
    // 指向keys初始位置
    NSUInteger keyCnt = 0;
    
    // 遍历找到为key nil的位置
    for (   ; valueCnt < count; valueCnt ++, objects++)
    {
        if (*objects == 0)
        {
            break;
        }
    }
    // 遍历找到为key nil的位置
    for (   ; keyCnt < count; keyCnt ++, keys++)
    {
        if (*keys == 0) // 遍历找到为key nil的位置
        {
            break;
        }
    }
    // 找到最小值
    //cnt 不能越界
    NSUInteger minCnt = MIN(keyCnt, valueCnt);
    NSInteger newCnt = MIN(minCnt, count);
    
    for (int i = 0; i<valueCnt; i++)
    {
        objects--;
    }
    for (int i = 0; i<keyCnt; i++)
    {
        keys--;
    }
    
    return [self i_swizzing_initWithObjects:objects forKeys:keys count:newCnt];
    
}

@end
