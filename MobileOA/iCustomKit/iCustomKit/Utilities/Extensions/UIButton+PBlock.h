//
//  UIButton+PBlock.h
//  PCustomKit
//
//  Created by user on 2017/12/20.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^PActionBlock)(void);

@interface UIButton (PBlock)

@property (readonly) NSMutableDictionary *event;

/**
 处理按钮点击回调事件
 */
- (void)i_handleControlEvent:(UIControlEvents)controlEvent withBlock:(PActionBlock)action;

@end
