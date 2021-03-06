//
//  UINavigationViewController+BackGesture.m
//  iCore 
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "UINavigationViewController+BackGesture.h"

#import <objc/runtime.h>

@interface UINavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation UINavigationController (BackGesture)

#pragma mark - ******************************LifeCycle Method***************************************

#pragma mark - ******************************Initial Methods****************************************

#pragma mark - ******************************Notification Method************************************

#pragma mark - ******************************KVO Method*********************************************

#pragma mark - ******************************API Request Method*************************************

#pragma mark - ******************************API Response Method************************************

#pragma mark - ******************************Private Method*****************************************


#pragma mark - ******************************Public Method******************************************

#pragma mark - ******************************Override Method****************************************



#pragma mark - ******************************Delegate***********************************************

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    
    CGFloat maxAllowedInitialDistance = self.maxAllowedInitialDistance;
    
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance)
    {
        return NO;
    }
    if (self.childViewControllers.count == 1)
    {
        return NO;
    }
    if ([[self valueForKey:@"_isTransitioning"] boolValue])
    {
        return NO;
    }
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    if (translation.x <= 0)
    {
        return NO;
    }
    return YES;
}

#pragma mark - ******************************Setter & Getter****************************************

- (void)setSupportBackGesture:(BOOL)supportBackGesture
{
    id target = self.interactivePopGestureRecognizer.delegate;
    
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:internalAction];
    
    panGesture.delegate = self;
    
    if (supportBackGesture)
    {
        [self.view addGestureRecognizer:panGesture];
        panGesture.maximumNumberOfTouches = 1;
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    else
    {
        self.interactivePopGestureRecognizer.enabled = YES;
        [self.view removeGestureRecognizer:panGesture];
    }
    
    objc_setAssociatedObject(self, @selector(isSupportBackGesture), @(supportBackGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSupportBackGesture
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (CGFloat)maxAllowedInitialDistance
{
    CGFloat max = [objc_getAssociatedObject(self, _cmd) floatValue];
    
    if (max <= 0)
    {
        max = CGRectGetWidth([UIScreen mainScreen].bounds);
        objc_setAssociatedObject(self, _cmd, @(max), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return max;
}

- (void)setMaxAllowedInitialDistance:(CGFloat)maxAllowedInitialDistance
{
    if (maxAllowedInitialDistance <= 0)
    {
        return;
    }
    
    objc_setAssociatedObject(self, @selector(maxAllowedInitialDistance), @(maxAllowedInitialDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
