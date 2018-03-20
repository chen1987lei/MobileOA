//
//  BasePopViewController.h
//  iCore 
//
//  Created by renqingyang on 2017/11/16.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, E_PopAnimationType)
{
    /// 默认效果，透明度从0到1
    E_PopAnimationType_Default = 0,

    /// 从上往下
    E_PopAnimationType_UpToBottom,

    /// 从下往上
    E_PopAnimationType_BottomToUp
};

/// 显示/隐藏 特效Block
typedef void (^PopStatusChangeBlock)(BOOL isShow);

/// popVC手势隐藏block回调，在状态改变block之后
typedef void (^PopHiddenBlock)(void);

/*!
 *  @author 任清阳, 2017-11-16  19:18:10
 *
 *  @brief  popVC基类
 *
 *  @since  1.0
 */
@interface BasePopViewController : BaseViewController

/// 是否关闭手势隐藏PopVC功能，默认NO：打开此功能
@property (nonatomic, getter = isSupportHiddenGesture, assign) BOOL supportHiddenGesture;

/// 当前PopVC的显示状态
@property (nonatomic, assign, getter = isShow,  readonly) BOOL show;

@property (nonatomic, copy) PopHiddenBlock popHiddenBlock;
@property (nonatomic, copy) PopStatusChangeBlock popStatusChangeBlock;

@property (nonatomic, strong) UIColor *popBackGroundColor;

#pragma mark - ******************************************* public mthod ****************************

/// 设置自定义View 和 动画效果
- (void)i_setCustomView:(UIView *)view
               animation:(E_PopAnimationType)animationType;


#pragma mark - ******************************************* 对外方法 主VC调用 **************************

/// 显示/隐藏 PopVC
- (void)i_showPop:(BOOL)isShow;

@end
