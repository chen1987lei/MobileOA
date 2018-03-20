//
//  PExpandTouchRegionButton.m
//  MTCustomKit
//
//  Created by 李京城 on 2016/10/10.
//  Copyright © 2016年 MTime. All rights reserved.
//

#import "PExpandTouchRegionButton.h"

// 按钮点击区域宽为 44.0f
#define PkExpandTouchRegion_Width (44.0f)

// 按钮点击区域高为 44.0f
#define PkExpandTouchRegion_Height (44.0f)

@implementation PExpandTouchRegionButton

#pragma mark - ******************************************* Override Methods *****************************

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    
    CGFloat widthDelta = MAX(PkExpandTouchRegion_Width - self.bounds.size.width, 0.0f);
    CGFloat heightDelta = MAX(PkExpandTouchRegion_Height - self.bounds.size.height, 0.0f);

    bounds = CGRectInset(self.bounds, -0.5f * widthDelta, -0.5f * heightDelta);
    
    return CGRectContainsPoint(bounds, point);
}

@end
