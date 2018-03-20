//
//  UIButton+PBlock.m
//  PCustomKit
//
//  Created by user on 2017/12/20.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "UIButton+PBlock.h"

@implementation UIButton (PBlock)
static char overviewKey;

@dynamic event;

- (void)i_handleControlEvent:(UIControlEvents)event withBlock:(PActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    PActionBlock block = (PActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}
@end
