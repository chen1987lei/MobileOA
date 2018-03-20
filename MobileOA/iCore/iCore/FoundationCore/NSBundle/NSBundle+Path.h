//
//  NSBundle+Path.h
//  iCore 
//
//  Created by renqingyang on 2018/1/10.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Path)

// 获取bundle路径
+ (NSBundle*)i_getBundleWithName:(NSString*)name;
@end
