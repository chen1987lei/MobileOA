//
//  BaseViewController.h
//  iCore
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/*!
 *  @author 任清阳, 2017-11-07  16:32:17
 *
 *  @brief  基类VC
 *
 *  @since  1.0 
 */
@interface BaseViewController : UIViewController

#pragma mark - ******************************************* Init and Uninit *************************

// 初始化
- (instancetype)initWithConfigDic:(NSDictionary *)configDic NS_DESIGNATED_INITIALIZER;
// 初始化类方法
+ (instancetype)initWithConfigDic:(NSDictionary *)configDic;
// 是否已经被初始化
@property (nonatomic, assign, getter = isInitialized, readonly) BOOL initialized;
// 是否已经被销毁
@property (nonatomic, assign, getter = isDestroyed, readonly) BOOL destroyed;

- (void)i_initFields NS_REQUIRES_SUPER;
- (void)i_uninitFields NS_REQUIRES_SUPER;

// 事件的创建在这个方法里，kvo对象放到initFields里边，在dealloc里边remove
- (void)i_createEvents NS_REQUIRES_SUPER;
- (void)i_destroyEvents NS_REQUIRES_SUPER;

- (void)i_createViews NS_REQUIRES_SUPER;
- (void)i_destroyViews NS_REQUIRES_SUPER;

- (void)i_loadData NS_REQUIRES_SUPER;
- (void)i_cancelLoadData NS_REQUIRES_SUPER;

// override，处理unload时需要的操作
- (void)i_unload;

#pragma mark - ******************************************* 对外方法 **********************************

// push界面
- (void)i_pushVC:(UIViewController *)aVC;

// pop界面
- (void)i_popVC;
// pop回指定的界面
- (void)i_popToVC:(UIViewController *)aVC;
// pop页面，默认有动画，这个是对没有动画的页面使用的
- (void)i_popVCWithAnimated:(BOOL)animated;
- (void)i_popVCToRootVC;

// 设置是否支持手势返回，viewDidLoad里面调用
- (void)i_setSupportBackGesture:(BOOL)supportBackGesture;

// 处理影响引用计数的功能
- (void)i_releaseReferenceCount;

// 结束编辑状态：收起键盘
- (void)i_endEditing;
// 结束其父VC及其自身的编辑状态
- (void)i_endAllParentsEditing;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@end
