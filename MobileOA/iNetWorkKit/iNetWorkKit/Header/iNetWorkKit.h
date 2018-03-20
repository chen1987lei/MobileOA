//
//  iNetWorkKit.h
//  iNetWorkKit
//
//  Created by renqingyang on 2017/11/7.

//

#import <UIKit/UIKit.h>

// 若是通过引用Framework的方式使用类库，则需要以 #import <iNetWorkKit/iNetWorkKit.h> 的方式引入头文件
#if __has_include(<iNetWorkKit/iNetWorkKit.h>)

//! Project version number for NetWorkKit.
FOUNDATION_EXPORT double NetWorkKitVersionNumber;

//! Project version string for NetWorkKit.
FOUNDATION_EXPORT const unsigned char NetWorkKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <iNetWorkKit/PublicHeader.h>

#pragma mark - ****************************************** BaseRequest ******************************

#import <iNetWorkKit/NetWorkManager.h>
#import <iNetWorkKit/BaseRequest.h>
#import <iNetWorkKit/NetWorkConfig.h>
#import <iNetWorkKit/Macro_NetWorkEnum.h>
#import <iNetWorkKit/BaseRequest+HttpStub.h>

// 若是通过引用源码或者lib库的方式使用类库，则需要以 #import "NetWorkKit.h" 的方式引入头文件
#else

#pragma mark - ****************************************** BaseRequest ******************************

#import "BaseRequest.h"
#import "NetWorkConfig.h"
#import "Macro_NetWorkEnum.h"
#import "BaseRequest+HttpStub.h"
#import "NetWorkManager.h"

#endif

