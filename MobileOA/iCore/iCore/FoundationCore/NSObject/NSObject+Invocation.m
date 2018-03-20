//
//  NSObject+Invocation.m
//  iCore 
//
//  Created by renqingyang on 2017/12/5.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "NSObject+Invocation.h"

@implementation NSObject (Invocation)

#pragma mark - ******************************Public Method******************************************

#pragma mark - i_invocationSelector
+ (id)i_invocationSelector:(SEL)selector withObjects:(NSArray *)objects addTarget:(id)target
{
    NSAssert(NSStringFromSelector(selector), @"selector 不能为空");

    NSAssert(NSStringFromClass([target class]), @"target 不能为空");

    // 创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];

    // 函数签名不存在
    if(signature == nil)
    {
        objects = @[NSStringFromSelector(selector),NSStringFromClass([target class])];
        // 重置方法为
        selector = @selector(i_methodSignatureNoFound:target:);

        signature = [target methodSignatureForSelector:selector];
    }

    // 通过签名初始化
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    // 设置target
    [invocation setTarget:target];
    // 设置selector
    [invocation setSelector:selector];

    NSUInteger i = 1;

    /// 添加参数Index
    for (id object in objects)
    {
        id tempObject = object;

        // 注意：1、这里设置参数的Index 需要从2开始，因为前两个被selector和target占用。
        [invocation setArgument:&tempObject atIndex:++i];
    }

    // retain 所有参数，防止参数被释放dealloc
    [invocation retainArguments];

    // 消息调用
    [invocation invoke];

    //获得返回值类型
    const char *returnType = signature.methodReturnType;

    /* 在arc模式下，getReturnValue：仅仅是从invocation的返回值拷贝到指定的内存地址，如果返回值是一个NSObject对象的话，是没有处理起内存管理的。而我们在定义resultSet时使用的是__strong类型的指针对象，arc就会假设该内存块已被retain（实际没有），当resultSet出了定义域释放时，导致该crash。假如在定义之前有赋值的话，还会造成内存泄露的问题。
     */

    //声明返回值变量
    __autoreleasing id returnValue;

    //如果没有返回值，也就是消息声明为void，那么returnValue=nil
    if(!strcmp(returnType, @encode(void)))
    {
        returnValue =  nil;
    }
    //如果返回值为对象，那么为变量赋值
    else if(!strcmp(returnType, @encode(id)))
    {
        [invocation getReturnValue:&returnValue];
    }
    //如果返回值为普通类型NSInteger  BOOL
    else
    {
        //返回值长度
        NSUInteger length = [signature methodReturnLength];

        //根据长度申请内存
        void *buffer = (void *)malloc(length);

        //为变量赋值
        [invocation getReturnValue:buffer];

        // BOOL类型
        if(!strcmp(returnType, @encode(BOOL)) )
        {
            returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
        }
        // NSInteger类型
        else if(!strcmp(returnType, @encode(NSInteger)) )
        {
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }
        // float类型
        else if(!strcmp(returnType, @encode(CGFloat)) )
        {
            returnValue = [NSNumber numberWithInteger:*((CGFloat*)buffer)];
        }

        returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
    }

    return returnValue;
}

- (void)i_methodSignatureNoFound:(NSString *)methodName target:(NSString *)target
{
    NSLog((@"%@ 类\n" "没有找到" "%@ 方法\n"),target,methodName);
}
+ (void)i_methodSignatureNoFound:(NSString *)methodName target:(NSString *)target
{
    NSLog((@"%@ 类\n" "没有找到" "%@ 方法\n"),target,methodName);
}
@end
