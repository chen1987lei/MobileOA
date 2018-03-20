//
//  NSMutableArray+Protect.m
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "NSMutableArray+Protect.h"

@implementation NSMutableArray (Protect)

+(void)load
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        // 判断是否配置文件是否已经开启nil保护
        if ([CoreConfigManager shared].openNilProtect)
        {
            Class arrCls = NSClassFromString(@"__NSArrayM");
            
            // 原始方法
            SEL originalSelectors[] = {
                @selector(objectAtIndex:),
                @selector(insertObject:atIndex:),
                @selector(setObject:atIndex:),
                @selector(setObject:atIndexedSubscript:),
                @selector(removeObjectsInRange:),
                @selector(replaceObjectAtIndex:withObject:)
            };
            
            for (NSUInteger index = 0; index < sizeof(originalSelectors) / sizeof(SEL); index++)
            {
                SEL originalSelector = originalSelectors[index];
                
                SEL swizzledSelector = NSSelectorFromString([@"i_swizzing_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
                
                [HookUtility i_swizzlingInClass:arrCls
                                  originalSelector:originalSelector
                                  swizzledSelector:swizzledSelector];
            }
        }
    });
}

#pragma mark - ******************************************* 方法替换 *********************************

#pragma mark objectAtIndex:

- (id)i_swizzing_objectAtIndex:(NSUInteger)index
{
    if (!self.count || self.count == 0)
    {
        NSLog(@"%s\n%@",__func__,@"数组为空");
        return nil;
    }
    else if (self.count - 1 < index)
    {
        NSLog(@"%s\n%@",__func__,@"数组越界了");
        return nil;
    }
    return [self i_swizzing_objectAtIndex:index];
}

#pragma mark insertObject:atIndex:

-(void)i_swizzing_insertObject:(id)object atIndex:(NSUInteger)index
{
    
    if (index == 0)
    {
        if (!object)
        {
            NSLog(@"不能为空");
            return;
        }
    }
    else
    {
        // 因为是插入操作 所以在数组最后也可以插入
        if (index > self.count)
        {
            NSLog(@"%s \n %@",__func__,@"数组越界了");
            return;
        }
        if (!object)
        {
            NSLog(@"不能为空");
            return;
        }
    }
    [self i_swizzing_insertObject:object atIndex:index];
}

#pragma mark setObject:atIndex:

-(void)i_swizzing_setObject:(id)object atIndex:(NSUInteger)index
{
    if (!object)
    {
        NSLog(@"不能为空");
        return;
    }
    // 可以在最末位增加
    if (index > self.count)
    {
        NSLog(@"%s\n%@",__func__,@"数组越界了");
        return;
    }
    [self i_swizzing_setObject:object atIndex:index];
}

#pragma mark setObject:atIndexedSubscript:

-(void)i_swizzing_setObject:(id)object atIndexedSubscript:(NSUInteger)index
{
    if (!object)
    {
        NSLog(@"不能为空");
        return;
    }
    // 可以在最末位增加
    if (index > self.count)
    {
        NSLog(@"%s \n %@",__func__,@"数组越界了");
        return;
    }
    [self i_swizzing_setObject:object atIndexedSubscript:index];
}

#pragma mark removeObjectsInRange:

-(void)i_swizzing_removeObjectsInRange:(NSRange)range
{
    if (range.location > self.count)
    {
        NSLog(@"%s \n %@",__func__,@"数组越界了");
        return;
    }
    
    if ((range.location + range.length) > self.count)
    {
        NSLog(@"%s \n %@",__func__,@"数组越界了");
        return;
    }
    [self i_swizzing_removeObjectsInRange:range];
}

#pragma mark replaceObjectAtIndex:withObject:

- (void)i_swizzing_replaceObjectAtIndex:(NSUInteger)index withObject:(id)object
{
    if (!self.count || self.count==0)
    {
        NSLog(@"%s\n%@",__func__,@"数组为空");
        return;
    }
    if (index >= self.count)
    {
        NSLog(@"%s\n%@",__func__,@"数组越界了");
        return;
    }
    if (!object)
    {
        NSLog(@"不能为空");
        return;
    }
    [self i_swizzing_replaceObjectAtIndex:index withObject:object];
}

@end
