//
//  PBaseViewController+PLoadStatusView.m
//  PCustomKit
//
//  Created by renqingyang on 2018/1/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "PBaseViewController+PLoadStatusView.h"

/// LoadStatusView 正常加载状态
PE_LoadStatusViewStatus const PE_LoadStatusViewStatus_Loading = @"loading";
PE_LoadStatusViewStatus const PE_LoadStatusViewStatus_Empty = @"empty";
PE_LoadStatusViewStatus const PE_LoadStatusViewStatus_NoNetWork = @"noNetWork";
PE_LoadStatusViewStatus const PE_LoadStatusViewStatus_LoadFailed = @"loadFailed";

#import <objc/runtime.h>

#import "PLoadStatusView.h"
#import "PLoadStatusViewSet.h"
#import "PLoadStatusViewSetSource.h"

/// 运行时loadStatusView
static char const *const PkLoadStatusViewSetView = "LoadStatusViewSetView";
/// 运行时loadStatusView 加载状态
static char const *const PkLoadStatusViewSetViewStatus = "LoadStatusViewSetViewStatus";

@interface PBaseViewController () <UIGestureRecognizerDelegate, PLoadStatusViewSetSource, PLoadStatusViewSet>

@property (nonatomic, readonly) PLoadStatusView *loadStatusView;

@property (nonatomic, readonly) PE_LoadStatusViewStatus loadStatusViewStatus;

@end

@implementation PBaseViewController (PLoadStatusView)

#pragma mark - ******************************************* Init and Uninit *************************


#pragma mark - ******************************************* View Lifecycle **************************


#pragma mark - ******************************************* LoadData and cancelLoadData *************


#pragma mark - ******************************************* Net Connection Event ********************


#pragma mark - ******************************************* Touch Event *****************************


#pragma mark - ******************************************* Router Event ****************************


#pragma mark - ******************************************* Delegate Event **************************

#pragma mark - PLoadStatusViewSetSource

- (NSAttributedString *)i_titleForLoadStatusViewSet:(__kindof UIView *)view
{
    /// loading
    if ([self.loadStatusViewStatus isEqualToString:PE_LoadStatusViewStatus_Loading])
    {
        return [[NSAttributedString alloc] initWithString:@"奋力加载中..."];
    }

    return nil;
}

- (NSAttributedString *)i_descriptionForLoadStatusViewSet:(__kindof UIView *)view
{
    return nil;
}

- (__kindof UIImage *)i_imgForLoadStatusViewSet:(__kindof UIView *)view
{
    return nil;
}

- (UIColor *)i_backgroundColorForLoadStatusViewSet:(__kindof UIView *)view
{
    /// loadingNormal
    if ([self.loadStatusViewStatus isEqualToString:PE_LoadStatusViewStatus_Loading])
    {
        return [UIColor whiteColor];
    }

    return nil;
}

- (CGSize)i_imageViewSizeForLoadStatusViewSet:(__kindof UIView *)view
{
    /// loading
    if ([self.loadStatusViewStatus isEqualToString:PE_LoadStatusViewStatus_Loading])
    {
        return CGSizeMake(150.0, 150.0);
    }

    return CGSizeZero;
}

- (__kindof UIButton *)i_btnForLoadStatusViewSet:(__kindof UIView *)view
{
    return nil;
}

- (NSAttributedString *)i_btnTitleForLoadStatusViewSet:(__kindof UIView *)view
                                               forState:(UIControlState)state
{
    return nil;
}

- (UIImage *)i_btnBackgroundImageForLoadStatusViewSet:(__kindof UIView *)view
                                              forState:(UIControlState)state
{
    return nil;
}

- (CGFloat)i_verticalOffsetForLoadStatusViewSet:(__kindof UIView *)view
{
    return -70.0f;
}

#pragma mark - MNDLoadStatusViewSet

- (BOOL)i_loadStatusViewSetShouldFadeIn:(__kindof UIView *)view
{
    return NO;
}

// 是否允許點擊
- (BOOL)i_loadStatusViewSetShouldAllowTouch:(__kindof UIView *)view
{
    return NO;
}

- (void)i_loadStatusViewSet:(__kindof UIView *)view
                  didTapView:(__kindof UIView *)tapView
{
    [self i_hideLoadStatusViewSet];

    [self i_loadData];
}

- (void)i_loadStatusViewSet:(__kindof UIView *)view
                didTapButton:(__kindof UIButton *)tapBtn
{
    
    [self i_loadData];
}

#pragma mark - ******************************************* Notification Event **********************


#pragma mark - ******************************************* 属性变量的 Set 和 Get 方法 *****************

#pragma mark - Getters

- (PLoadStatusView *)loadStatusView
{
    PLoadStatusView *view = objc_getAssociatedObject(self, PkLoadStatusViewSetView);

    if (!view)
    {
        view = [PLoadStatusView new];

        view.loadStatusViewSetSourceDelegate = self;
        
        view.loadStatusViewSetDelegate = self;

        view.hidden = YES;

        view.translatesAutoresizingMaskIntoConstraints = NO;

        [self setLoadStatusView:view];
    }
    return view;
}

- (PE_LoadStatusViewStatus)loadStatusViewStatus
{
    return objc_getAssociatedObject(self, PkLoadStatusViewSetViewStatus);
}

#pragma mark - Setters

- (void)setLoadStatusView:(PLoadStatusView *)loadStatusView
{
    objc_setAssociatedObject(self, PkLoadStatusViewSetView, loadStatusView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setloadStatusViewStatus:(PE_LoadStatusViewStatus)loadStatusViewStatus
{
    objc_setAssociatedObject(self, PkLoadStatusViewSetViewStatus, loadStatusViewStatus, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - ******************************************* 基类方法 **********************************


#pragma mark - ******************************************* 私有方法 **********************************

/// 检查LoadStatusView是否有效
- (BOOL)isLoadStatusViewSetVisible
{
    UIView *view = objc_getAssociatedObject(self, PkLoadStatusViewSetView);

    return view ? !view.hidden : NO;
}

/// 设置LoadStatusView无效
- (void)i_invalidate
{
    if (self.loadStatusView)
    {
        [self.loadStatusView prepareForReuse];
        [self.loadStatusView removeFromSuperview];

        [self setLoadStatusView:nil];
    }
}

#pragma mark - ******************************************* 对外方法 **********************************

#pragma mark - 根据加载状态刷新loadStatusView

- (void)i_reloadLoadStatusViewSet:(PE_LoadStatusViewStatus)loadStatusViewStatus
{
    [self i_reloadLoadStatusViewSet:loadStatusViewStatus offset:0.0];
}

#pragma mark - 根据加载状态和偏移量刷新loadStatusView
- (void)i_reloadLoadStatusViewSet:(PE_LoadStatusViewStatus)loadStatusViewStatus
                            offset:(float)offsetY
{
    [self setloadStatusViewStatus:loadStatusViewStatus];

    PLoadStatusView *loadStatusView = self.loadStatusView;

    loadStatusView.offsetY = - offsetY / 2;

    if (!loadStatusView.superview)
    {
        [self.view addSubview:loadStatusView];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[loadStatusView]-0-|"
                                                                          options:0
                                                                          metrics:@{ @"padding" : @(offsetY) }
                                                                            views:@{ @"loadStatusView" : loadStatusView }]];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[loadStatusView]-0-|" options:0 metrics:nil views:@{ @"loadStatusView" : loadStatusView }]];
    }

    /// 重置复用数据
    [loadStatusView prepareForReuse];

    [loadStatusView reloadLoadStatusView];

    [UIView performWithoutAnimation:^{
        [loadStatusView layoutIfNeeded];
    }];
}

#pragma mark - 隐藏LoadStatusView

- (void)i_hideLoadStatusViewSet
{
    if (self.isLoadStatusViewSetVisible)
    {
        [self i_invalidate];
    }
}

#pragma mark - ******************************************* 类方法 ***********************************

@end

