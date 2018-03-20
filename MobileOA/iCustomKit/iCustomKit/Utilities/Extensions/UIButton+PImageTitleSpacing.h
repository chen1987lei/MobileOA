//
//  UIButton+PImageTitleSpacing.h
//  PCustomKit
//
//  Created by user on 2017/12/26.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PE_ButtonEdgeInsetsStyle) {
    PE_ButtonEdgeInsetsStyle_Top, // image在上，label在下
    PE_ButtonEdgeInsetsStyle_Left, // image在左，label在右
    PE_ButtonEdgeInsetsStyle_Bottom, // image在下，label在上
    PE_ButtonEdgeInsetsStyle_Right // image在右，label在左
};

@interface UIButton (PImageTitleSpacing)

/**
 设置button的titleLabel和imageView的布局样式，及间距
 
 * titleLabel和imageView的布局样式
 * titleLabel和imageView的间距
 
 */
- (void)layoutButtonWithEdgeInsetsStyle:(PE_ButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
