//
//  UINavigationController+NavigationBarSet.h
//  iCore 
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @author renqingyang, 16-08-15 11:05:23
 *
 *  @brief  NavigationBarSet
 *
 *  @since  1.0
 */
@interface UIViewController (NavigationBarSet)

#pragma mark - titleView

/**
 *  设置navigationBar的titleView
 *
 *  @param titleView navigationBar的titleView
 */
- (void)i_setNavigationBarTitleView:(UIView *)titleView;

/**
 *  设置navigationBar的titleView为图片
 *
 *  @param titleViewImage titleView的图片
 */
- (void)i_setNavigationBarImageTitleViewWithImage:(UIImage *)titleViewImage;

#pragma mark - background

/**
 *  设置navigationBar的背景图片
 *
 *  @param backgroundImage 背景图片
 */
- (void)i_setNavigationBarBackgroundImage:(UIImage *)backgroundImage;

#pragma mark - tintColor

/**
 *  设置左Item、右item的显示的TintColor
 *
 *  @param leftTintColor  左item的TintColor
 *  @param rightTintColor 右item的TintColor
 */
- (void)i_setNavigationLeftBarTintColor:(UIColor*)leftTintColor
                       rightBarTintColor:(UIColor*)rightTintColor;

#pragma mark - more ItemImages

/**
 *  设置右侧多个item对象
 *
 *  @param elements   右侧多个对象元素，<Title:NSString,Image:UIImage>
 *  @param indexBlock item元素位置
 */
- (void)i_setNavigationBarRightBarButtonsWithElements:(NSArray *)elements
                            rightBarButtonClickedBlock:(void(^)(NSInteger barButtonIndex))indexBlock;

/**
 *  设置左侧多个item对象
 *
 *  @param elements   左侧多个对象元素，<Title:NSString,Image:UIImage>
 *  @param indexBlock item元素位置
 */
- (void)i_setNavigationBarLeftBarButtonsWithElements:(NSArray *)elements
                            leftBarButtonClickedBlock:(void(^)(NSInteger barButtonIndex))indexBlock;

@end
