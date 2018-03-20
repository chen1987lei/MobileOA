//
//  UINavigationBar+FixSpace.m
//  iCore 
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "UINavigationBar+FixSpace.h"

#import "Macro_DeviceInfo.h"

// 默认矫正偏移
static CGFloat defaultFixSpace = 16.0;

@implementation UINavigationBar (FixSpace)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HookUtility i_swizzlingInClass:[self class]
                          originalSelector:@selector(layoutSubviews)
                          swizzledSelector:@selector(i_swizzing_layoutSubviews)];
    });
}

-(void)i_swizzing_layoutSubviews
{
    [self i_swizzing_layoutSubviews];
    
    // 当前系统大于11
    if (kDevice_System_Version_Greater_Than(@"11.0"))
    {
        self.layoutMargins = UIEdgeInsetsZero;
        
        CGFloat space = defaultFixSpace;
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([NSStringFromClass(obj.class) containsString:@"ContentView"])
            {
                //可修正iOS11之后的偏移
                obj.layoutMargins = UIEdgeInsetsMake(0, space, 0, space);
                *stop = YES;
            }
        }];
    }
}

@end

@implementation UINavigationItem (SXFixSpace)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#warning TODO：需要下载模拟器测试下效果
//        // 原始方法
//        SEL originalSelectors[] = {
//            @selector(setLeftBarButtonItem:),
//            @selector(setLeftBarButtonItems:),
//            @selector(setRightBarButtonItem:),
//            @selector(setRightBarButtonItems:)
//        };
//
//        for (NSUInteger index = 0; index < sizeof(originalSelectors) / sizeof(SEL); index++)
//        {
//            SEL originalSelector = originalSelectors[index];
//
//            SEL swizzledSelector = NSSelectorFromString([@"i_swizzing_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
//
//            [HookUtility i_swizzlingInClass:[self class]
//                              originalSelector:originalSelector
//                              swizzledSelector:swizzledSelector];
//        }
    });
    
}

-(void)i_swizzing_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if (kDevice_System_Version_Greater_Than(@"11.0"))
    {
        [self i_swizzing_setLeftBarButtonItem:leftBarButtonItem];
    }
    else
    {
        if (leftBarButtonItem)
        {//存在按钮且需要调节
            [self setLeftBarButtonItems:@[leftBarButtonItem]];
        }
        else
        {//不存在按钮,或者不需要调节
            [self i_swizzing_setLeftBarButtonItem:leftBarButtonItem];
        }
    }
}

-(void)sx_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems
{
    if (leftBarButtonItems.count)
    {
        NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:defaultFixSpace - 16]];//可修正iOS11之前的偏移
        [items addObjectsFromArray:leftBarButtonItems];
        [self sx_setLeftBarButtonItems:items];
    } else {
        [self sx_setLeftBarButtonItems:leftBarButtonItems];
    }
}

-(void)sx_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if (kDevice_System_Version_Greater_Than(@"11.0"))
    {
        [self sx_setRightBarButtonItem:rightBarButtonItem];
    }
    else
    {
        if (rightBarButtonItem)
        {//存在按钮且需要调节
            [self setRightBarButtonItems:@[rightBarButtonItem]];
        }
        else
        {//不存在按钮,或者不需要调节
            [self sx_setRightBarButtonItem:rightBarButtonItem];
        }
    }
}

-(void)sx_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems
{
    if (rightBarButtonItems.count)
    {
        NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:defaultFixSpace - 16]];//可修正iOS11之前的偏移
        [items addObjectsFromArray:rightBarButtonItems];
        [self sx_setRightBarButtonItems:items];
    } else {
        [self sx_setRightBarButtonItems:rightBarButtonItems];
    }
}

-(UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end

