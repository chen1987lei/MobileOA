//
//  UINavigationViewController+BackGesture.h
//  iCore 
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @author renqingyang, 16-08-15 10:59:21
 *
 *  @brief  滑动返回手势
 *
 *  @since  1.0
 */

@interface UINavigationController (BackGesture)

// 是否支持滑动返回手势
@property (nonatomic, getter = isSupportBackGesture, assign) BOOL supportBackGesture;

// 滑动手势触发范围
@property (nonatomic, assign) CGFloat maxAllowedInitialDistance;

@end
