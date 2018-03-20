//
//  HookUtility.h
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @author 任清阳, 2017-11-07  18:40:19
 *
 *  @brief  方法交换工具
 *
 *  @since  1.0
 */
@interface HookUtility : NSObject

/*!
 *  @author renqingyang, 17-11-07 18:42:59
 *
 *  @brief  方法交换工具
 *
 *  @param cls 需要进行方法交换的类
 *  @param originalSelector  原始方法
 *  @param swizzledSelector  替换方法
 *
 *  @since 1.0
 */
+ (void)i_swizzlingInClass:(Class)cls
           originalSelector:(SEL)originalSelector
           swizzledSelector:(SEL)swizzledSelector;
@end
