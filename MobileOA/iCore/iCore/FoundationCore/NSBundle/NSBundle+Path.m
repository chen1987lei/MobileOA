//
//  NSBundle+Path.m
//  iCore 
//
//  Created by renqingyang on 2018/1/10.
//  Copyright © 2018年 . All rights reserved.
//

#import "NSBundle+Path.h"

@implementation NSBundle (Path)

+ (NSBundle*)i_getBundleWithName:(NSString*)name
{
    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];

    NSString *frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:name];

    if ([[NSFileManager defaultManager] fileExistsAtPath:frameworkBundlePath])
    {
        return [NSBundle bundleWithPath:frameworkBundlePath];
    }
    return nil;
}

@end
