//
//  HookUtility.m
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "HookUtility.h"

#import <objc/runtime.h>

@implementation HookUtility

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - ******************************Notification Method************************************

#pragma mark - ******************************KVO Method*********************************************

#pragma mark - ******************************API Request Method*************************************

#pragma mark - ******************************API Response Method************************************

#pragma mark - ******************************Private Method*****************************************

#pragma mark - ******************************Public Method******************************************

+ (void)i_swizzlingInClass:(Class)cls
           originalSelector:(SEL)originalSelector
           swizzledSelector:(SEL)swizzledSelector
{
    Class class = cls;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod)
    {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

@end
