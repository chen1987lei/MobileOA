//
//  UINavigationBar+Extension.h
//  iCore 
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

// NavigationBar类型
typedef NS_ENUM(NSInteger, NavigationBarStyle)
{
    NavigationBarStyle_Default,
    NavigationBarStyle_OnlyItem
};

/*!
 *  @author renqingyang, 16-08-13 18:14:29
 *
 *  @brief  NavigationBar设置扩展
 *
 *  @since  1.0
 */
@interface UINavigationBar (Extension)

@property (nonatomic, assign) NavigationBarStyle navigationBarStyle;

/**
 *  @author renqingyan, 16-08-13 18:15:31
 *
 *  设置navigationBar的alpha值（区别于navigationBarStyle）
 */
@property (assign, nonatomic) CGFloat barAlpha;

@end
