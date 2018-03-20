//
//  NSObject+Invocation.h
//  iCore 
//
//  Created by renqingyang on 2017/12/5.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @author 任清阳, 2017-12-04  17:24:19
 *
 *  @brief  方法签名消息转发类
 *
 *  @since  1.0
 */

@interface NSObject (Invocation)

/*!
 *
 *  @brief 通过方法签名进行消息转发。
 *
 *  @discussion 通过方法签名进行消息转发.
 *
 *  @param selector selector名称.
 *  @param objects 参数数组.
 *  @param target target.
 *
 *  @return 方法返回值.
 *
 *  @since  1.0
 *
 */
#pragma mark - i_performSelector
+ (id)i_invocationSelector:(SEL)selector withObjects:(NSArray *)objects addTarget:(id)target;

/*!
 *
 *  @brief 方法签名没有找到时，统一指向NoFound方法，方便定位问题。
 *
 *  @discussion 方法签名没有找到时，统一指向NoFound方法，方便定位问题.
 *
 *  @param methodName action时间名称.
 *
 *  @since  1.0
 *
 */
- (void)i_methodSignatureNoFound:(NSString *)methodName target:(NSString *)target;
+ (void)i_methodSignatureNoFound:(NSString *)methodName target:(NSString *)target;

@end
