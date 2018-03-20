//
//  UIImage+Extension.m
//  iCore 
//
//  Created by renqingyang on 2017/11/21.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

#pragma mark - 根据路径获取资源图片

+ (UIImage *)i_loadResourceDataWithPath:(NSString *)path
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resourcePath = [bundle resourcePath];

    NSString *filePath = [resourcePath stringByAppendingPathComponent:path];

    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}
@end
