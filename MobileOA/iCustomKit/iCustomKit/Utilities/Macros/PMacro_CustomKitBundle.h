//
//  PMacro_CustomKitBundle.h
//  PCustomKit
//
//  Created by renqingyang on 2017/11/10.
//  Copyright © 2017年 ren. All rights reserved.
//

#ifndef PMacro_CustomKitBundle_h
#define PMacro_CustomKitBundle_h

/// PCustomKit中Resource bundle的名称，资源文件的使用路径均是基于bundle，例如：
#define PkCustomKitBundlePath(name) [NSString stringWithFormat:@"%@/%@", @"PCustomKit.bundle", name]

// AdditionalClauseView
static E_LocalizedTable const E_LocalizedTable_PCustomKitView = @"PCustomKitView";

#endif /* PMacro_CustomKitBundle_h */
