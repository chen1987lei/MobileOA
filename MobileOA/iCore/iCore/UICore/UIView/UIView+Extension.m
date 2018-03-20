//
//  UIView+Extension.m
//  MTFoundation
//
//  Created by 苏循波 on 15/10/29.
//  Copyright © 2015年 Mtime. All rights reserved.
//

#import "UIView+Extension.h"


@implementation UIView (Extension)

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height
{
    [self setHeight:height Animated:NO];
}
- (void)setHeight:(CGFloat)height Animated:(BOOL)animate
{
    CGRect frame = self.frame;
    frame.size.height = height;
    if (animate)
    {
        [UIView animateWithDuration:.3
                         animations:^{
                             self.frame = frame;
                         }];
    }
    else
    {
        self.frame = frame;
    }
}
- (void)addHeight:(CGFloat)height
{
    [self setHeight:[self height] + height];
}


- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width
{
    [self setWidth:width Animated:NO];
}
- (void)setWidth:(CGFloat)width Animated:(BOOL)animate
{
    CGRect frame = self.frame;
    frame.size.width = width;
    if (animate)
    {
        [UIView animateWithDuration:.3
                         animations:^{
                             self.frame = frame;
                         }];
    }
    else
    {
        self.frame = frame;
    }
}
- (void)addWidth:(CGFloat)width
{
    [self setWidth:[self width] + width Animated:NO];
}

- (CGFloat)originX
{
    return self.frame.origin.x;
}
- (void)setOriginX:(CGFloat)x
{
    [self setOriginX:x Animated:NO];
}
- (void)setOriginX:(CGFloat)x Animated:(BOOL)animate
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    if (animate)
    {
        [UIView animateWithDuration:.3
                         animations:^{
                             self.frame = frame;
                         }];
    }
    else
    {
        self.frame = frame;
    }
}
- (void)addOriginX:(CGFloat)x
{
    [self setOriginX:[self originX] + x];
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}
- (void)setOriginY:(CGFloat)y
{
    [self setOriginY:y Animated:NO];
}
- (void)setOriginY:(CGFloat)y Animated:(BOOL)animate
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    if (animate)
    {
        [UIView animateWithDuration:.3
                         animations:^{
                             self.frame = frame;
                         }];
    }
    else
    {
        self.frame = frame;
    }
}
- (void)addOriginY:(CGFloat)y
{
    [self setOriginY:[self originY] + y];
}

- (CGSize)size
{
    return self.frame.size;
}
- (void)setSize:(CGSize)size
{
    [self setSize:size Animated:NO];
}
- (void)setSize:(CGSize)size Animated:(BOOL)animate
{
    CGRect frame = self.frame;
    frame.size = size;
    if (animate)
    {
        [UIView animateWithDuration:.3
                         animations:^{
                             self.frame = frame;
                         }];
    }
    else
    {
        self.frame = frame;
    }
}

- (CGPoint)origin
{
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)point
{
    [self setOrigin:point Animated:NO];
}
- (void)setOrigin:(CGPoint)point Animated:(BOOL)animate
{
    CGRect frame = self.frame;
    frame.origin = point;
    if (animate)
    {
        [UIView animateWithDuration:.3
                         animations:^{
                             self.frame = frame;
                         }];
    }
    else
    {
        self.frame = frame;
    }
}


- (CGPoint)originTopRight
{
    return CGPointMake(self.origin.x + self.width, self.origin.y);
}

- (CGPoint)originBottomLeft
{
    return CGPointMake(self.originX, self.originY + self.height);
}

- (CGPoint)originBottomRight
{
    return CGPointMake(self.originX + self.width, self.originY + self.height);
}


- (CGRect)rectForAddViewTop:(CGFloat)height //返回在该view上面添加一个视图时的frame
{
    CGRect frame = self.frame;
    frame.size.height = height;
    frame.origin.y = frame.origin.y - height;

    return frame;
}
- (CGRect)rectForAddViewBottom:(CGFloat)height //返回在该view下面添加一个视图的时候的frame
{
    CGRect frame = self.frame;
    frame.origin.y = frame.origin.y + frame.size.height;
    frame.size.height = height;
    return frame;
}
- (CGRect)rectForAddViewLeft:(CGFloat)width //返回在该view左边添加一个视图的时候的frame
{
    CGRect frame = self.frame;
    frame.size.width = width;
    frame.origin.x = frame.origin.x - width;
    return frame;
}
- (CGRect)rectForAddViewRight:(CGFloat)width //返回在该view右边添加一个视图的时候的frame
{
    CGRect frame = self.frame;
    frame.size.width = width;
    frame.origin.x = frame.origin.x + width;
    return frame;
}

- (CGRect)rectForAddViewTop:(CGFloat)height Offset:(CGFloat)offset //返回在该view上面添加一个视图时的frame
{
    CGRect frame = self.frame;
    frame.size.height = height;
    frame.origin.y = frame.origin.y - height - offset;
    return frame;
}
- (CGRect)rectForAddViewBottom:(CGFloat)height Offset:(CGFloat)offset //返回在该view下面添加一个视图的时候的frame
{
    CGRect frame = self.frame;
    frame.origin.y = frame.origin.y + frame.size.height + offset;
    frame.size.height = height;
    return frame;
}
- (CGRect)rectForAddViewLeft:(CGFloat)width Offset:(CGFloat)offset //返回在该view左边添加一个视图的时候的frame
{
    CGRect frame = self.frame;
    frame.size.width = width;
    frame.origin.x = frame.origin.x - width - offset;
    return frame;
}
- (CGRect)rectForAddViewRight:(CGFloat)width Offset:(CGFloat)offset //返回在该view右边添加一个视图的时候的frame
{
    CGRect frame = self.frame;
    frame.size.width = width;
    frame.origin.x = frame.origin.x + width + offset;
    return frame;
}

- (CGRect)rectForCenterofSize:(CGSize)size
{
    CGRect rect;
    rect.size.width = size.width;
    rect.size.height = size.height;
    rect.origin.x = (self.width - size.width) / 2.0;
    rect.origin.y = (self.height - size.height) / 2.0;
    return rect;
}

- (NSArray *)subviewsWithClass:(Class)cls
{
    NSArray *array = [self subviews];
    return [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:cls])
        {
            return YES;
        }
        return NO;
    }]];
}

- (id)viewWithTag2:(int)tag
{
    return [self viewWithTag:tag];
}

@end
