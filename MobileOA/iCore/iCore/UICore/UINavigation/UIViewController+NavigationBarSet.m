//
//  UINavigationController+NavigationBarSet.m
//  iCore 
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "UIViewController+NavigationBarSet.h"

#import <objc/runtime.h>

#pragma mark typedef block
typedef void (^navigationBarButtonClickedBlock)(NSInteger buttonIndex);

@interface UIViewController ()

@property (nonatomic, strong) UIColor *leftBarButtonItemTincColor;
@property (nonatomic, strong) UIColor *rightBarButtonItemTincColor;

@end

@implementation UIViewController (NavigationBarSet)

#pragma mark - ******************************Public Method******************************************

#pragma mark - titleView

- (void)i_setNavigationBarTitleView:(UIView *)titleView
{
    self.title = nil;
    self.navigationItem.titleView = titleView;
}
- (void)i_setNavigationBarImageTitleViewWithImage:(UIImage *)titleViewImage
{
    [self i_setNavigationBarTitleView:[[UIImageView alloc] initWithImage:titleViewImage]];
}

#pragma mark - background

- (void)i_setNavigationBarBackgroundImage:(UIImage *)backgroundImage
{
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - tintColor

- (void)i_setNavigationLeftBarTintColor:(UIColor*)leftTintColor
                       rightBarTintColor:(UIColor*)rightTintColor
{
    if (leftTintColor)
    {
        self.leftBarButtonItemTincColor = leftTintColor;
        self.navigationItem.leftBarButtonItem.tintColor = leftTintColor;
    }
    if (rightTintColor)
    {
        self.rightBarButtonItemTincColor = rightTintColor;
        self.navigationItem.rightBarButtonItem.tintColor = rightTintColor;
    }
}

#pragma mark - more Items

- (void)i_setNavigationBarRightBarButtonsWithElements:(NSArray *)elements
                            rightBarButtonClickedBlock:(void(^)(NSInteger barButtonIndex))indexBlock
{
    if (elements.count == 0)
    {
        return;
    }
    
    self.rightBarButtonIndexBlock = indexBlock;
    
    NSMutableArray * rightBarButtonItems = [NSMutableArray new];
    
    [elements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBarButtonItem* rightBarButton;
        
        if ([obj isKindOfClass:[NSString class]])
        {
            rightBarButton = [[UIBarButtonItem alloc] initWithTitle:obj
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:
                              @selector(i_rightBarButtonItemClicked:)];
        }
        else if ([obj isKindOfClass:[UIImage class]])
        {
            rightBarButton = [[UIBarButtonItem alloc] initWithImage:obj
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:
                              @selector(i_rightBarButtonItemClicked:)];
        }
        else
        {
            NSLog(@"你传入的navigationBarItem元素不是title或者不是图片类型");
        }
        
        rightBarButton.tag = idx;
        
        rightBarButton.tintColor = self.rightBarButtonItemTincColor;
        
        [rightBarButtonItems addObject:rightBarButton];
    }];
    
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
}
- (void)i_setNavigationBarLeftBarButtonsWithElements:(NSArray *)elements
                            leftBarButtonClickedBlock:(void(^)(NSInteger barButtonIndex))indexBlock
{
    if (elements.count == 0)
    {
        return;
    }
    
    self.leftBarButtonIndexBlock = indexBlock;
    
    NSMutableArray * leftBarButtonItems = [NSMutableArray new];
    
    [elements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBarButtonItem* leftBarButton;
        
        if ([obj isKindOfClass:[NSString class]])
        {
            leftBarButton = [[UIBarButtonItem alloc] initWithTitle:obj
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:
                             @selector(i_leftBarButtonItemClicked:)];
        }
        else if ([obj isKindOfClass:[UIImage class]])
        {
            leftBarButton = [[UIBarButtonItem alloc] initWithImage:obj
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:
                             @selector(i_leftBarButtonItemClicked:)];
        }
        else
        {
            NSLog(@"你传入的navigationBarItem元素不是title或者不是图片类型");
        }
        
        leftBarButton.tag = idx;
        
        leftBarButton.tintColor = self.leftBarButtonItemTincColor;
        
        [leftBarButtonItems addObject:leftBarButton];
    }];
    
    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
}

#pragma mark - ******************************Private Method*****************************************

- (void)i_leftBarButtonItemClicked:(UIBarButtonItem *)barButtonItem
{
    if ([barButtonItem isKindOfClass:[UIBarButtonItem class]])
    {
        !self.leftBarButtonIndexBlock ?: self.leftBarButtonIndexBlock((int) ((UIBarButtonItem *)barButtonItem).tag);
    }
}
- (void)i_rightBarButtonItemClicked:(id)barButtonItem
{
    if ([barButtonItem isKindOfClass:[UIBarButtonItem class]])
    {
        !self.rightBarButtonIndexBlock ?: self.rightBarButtonIndexBlock((int) ((UIBarButtonItem *)barButtonItem).tag);
    }
    
}

#pragma mark - ******************************Setter & Getter****************************************

- (void)setLeftBarButtonIndexBlock:(navigationBarButtonClickedBlock)leftBarButtonIndexBlock
{
    objc_setAssociatedObject(self, @selector(leftBarButtonIndexBlock), leftBarButtonIndexBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (navigationBarButtonClickedBlock)leftBarButtonIndexBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRightBarButtonIndexBlock:(navigationBarButtonClickedBlock)rightBarButtonIndexBlock
{
    objc_setAssociatedObject(self, @selector(rightBarButtonIndexBlock), rightBarButtonIndexBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (navigationBarButtonClickedBlock)rightBarButtonIndexBlock{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLeftBarButtonItemTincColor:(UIColor *)leftBarButtonItemTincColor
{
    objc_setAssociatedObject(self, @selector(leftBarButtonItemTincColor), leftBarButtonItemTincColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)leftBarButtonItemTincColor
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setRightBarButtonItemTincColor:(UIColor *)rightBarButtonItemTincColor
{
    objc_setAssociatedObject(self, @selector(rightBarButtonItemTincColor), rightBarButtonItemTincColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)rightBarButtonItemTincColor
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
