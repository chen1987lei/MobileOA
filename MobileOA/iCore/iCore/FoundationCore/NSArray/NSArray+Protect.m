//
//  NSArray+Protect.m
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "NSArray+Protect.h"

#import <objc/runtime.h>

@implementation NSArray (Protect)

+(void)load
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        // 判断是否配置文件是否已经开启nil保护
        if ([CoreConfigManager shared].openNilProtect)
        {
            /*
             * NSArray 类簇
             id obj1 = [NSArray alloc]; // __NSPlacehodlerArray *
             NSArray *arr =  [[NSArray alloc]init]; // ____NSArray0
             id obj2 = [NSMutableArray alloc];  // __NSPlacehodlerArray *
             id obj3 = [obj1 init];  // __NSArrayI *
             id obj4 = [obj2 init];  // __NSArrayM *
             创建只有一个对象的NSArray时，得到的是__NSSingleObjectArrayI类对象.
             */
            // 需要进行替换的类
            Class classes[] = {
                objc_getClass("__NSArrayI"),
                objc_getClass("__NSArray0"),
                objc_getClass("__NSSingleObjectArrayI"),
                objc_getClass("__NSPlaceholderArray"),
                objc_getClass("__NSPlaceholderArray")
            };
            
            // 原始方法
            SEL originalSelectors[] = {
                @selector(objectAtIndex:),
                @selector(objectAtIndex:),
                @selector(objectAtIndex:),
                @selector(objectAtIndex:),
                @selector(initWithObjects:count:)
            };
            
            // 替换方法
            SEL swizzledSelectors[] = {
                @selector(i_swizzing_objectAtIndexI:),
                @selector(i_swizzing_objectAtIndex0:),
                @selector(i_swizzing_objectAtIndexSingle:),
                @selector(i_swizzing_objectAtIndexPlaceholder:),
                @selector(i_swizzing_initWithObjects:count:)
            };
            
            for (int index = 0; index < sizeof(classes) / sizeof(Class); index++)
            {
                if ((index < sizeof(originalSelectors) / sizeof(SEL))
                    &&(index < sizeof(swizzledSelectors) / sizeof(SEL)))
                {
                    [HookUtility i_swizzlingInClass:classes[index]
                                      originalSelector:originalSelectors[index]
                                      swizzledSelector:swizzledSelectors[index]];
                }
            }
        }
    });
}

#pragma mark - ******************************************* 方法替换 *********************************

#pragma mark objectAtIndex:

- (id)i_swizzing_objectAtIndexI:(NSUInteger)index
{
    if (![self judgeArrayIndex:index])
    {
        return nil;
    }
    return [self i_swizzing_objectAtIndexI:index];
}

- (id)i_swizzing_objectAtIndex0:(NSUInteger)index
{
    if (![self judgeArrayIndex:index])
    {
        return nil;
    }
    return [self i_swizzing_objectAtIndex0:index];
}

- (id)i_swizzing_objectAtIndexSingle:(NSUInteger)index
{
    if (![self judgeArrayIndex:index]) {
        return nil;
    }
    return [self i_swizzing_objectAtIndexSingle:index];
}

- (id)i_swizzing_objectAtIndexPlaceholder:(NSUInteger)index
{
    NSLog(@"%s\n%s\n%@",class_getName(self.class),__func__,@"数组未初始化");
    return nil;
}

#pragma mark initWithObjects:count:

- (id)i_swizzing_initWithObjects:(id  _Nonnull const [])objects
                            count:(NSUInteger)count
{
    for (int i = 0 ; i < count ; i++)
    {
        if (objects[i] == nil)
        {
            NSLog(@"数组第%d个参数为空",i);
            return nil;
        }
    }
    return [self i_swizzing_initWithObjects:objects count:count];
}

#pragma mark - ******************************Private Method*****************************************
-(BOOL)judgeArrayIndex:(NSUInteger)index
{
    
    if (!self.count || self.count == 0)
    {
        NSLog(@"%s\n%s\n%@",class_getName(self.class),__func__,@"数组为空");
        return NO;
    }
    else if (self.count-1 < index){
        NSLog(@"%s\n%s\n%@",class_getName(self.class),__func__,@"数组越界了");
        return NO;
    }
    return YES;
}
@end
