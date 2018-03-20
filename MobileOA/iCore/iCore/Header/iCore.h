//
//  iCore.h
//  iCore
//
//  Created by renqingyang on 2018/3/20.
//  Copyright © 2018年 renqingyang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 若是通过引用Framework的方式使用类库，则需要以 #import <iCore/iCore.h> 的方式引入头文件
#if __has_include(<iCore/iCore.h>)

//! Project version number for iCore.
FOUNDATION_EXPORT double iCoreVersionNumber;

//! Project version string for iCore.
FOUNDATION_EXPORT const unsigned char iCoreVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <iCore/PublicHeader.h>

#pragma mark - ****************************************** ConfigManager ****************************

#import <iCore/CoreConfigManager.h>

#pragma mark - ****************************************** NSArray **********************************

#import <iCore/NSArray+Protect.h>
#import <iCore/NSMutableArray+Protect.h>

#pragma mark - ****************************************** NSDictionary *****************************

#import <iCore/NSDictionary+Protect.h>
#import <iCore/NSMutableDictionary+Protect.h>

#pragma mark - ****************************************** NSObject *********************************

#import <iCore/Macro_NSObject.h>
#import <iCore/NSObject+Model.h>
#import <iCore/NSObject+Invocation.h>

#pragma mark - ****************************************** NSLog ************************************

#import <iCore/LogInfo.h>
#import <iCore/Macro_NSLog.h>

#pragma mark - ****************************************** NSString *********************************

#import <iCore/NSString+Attributed.h>
#import <iCore/NSString+CheckRule.h>
#import <iCore/Macro_NSString.h>
#import <iCore/NSString+URL.h>
#import <iCore/NSString+FontSize.h>

#pragma mark - ******************************************* UIDevice ********************************

#import <iCore/DeviceInfo.h>
#import <iCore/Macro_DeviceInfo.h>

#pragma mark - ******************************************* UIView **********************************

#import <iCore/UIView+Extension.h>

#pragma mark - ******************************************* UIViewController ************************

#import <iCore/UIViewController+Util.h>

#pragma mark - ******************************************* UIFont **********************************

#import <iCore/UIFont+Extension.h>
#import <iCore/Macro_UIFont.h>

#pragma mark - ******************************************* UIColor *********************************

#import <iCore/Macro_UIColor.h>

#pragma mark - ******************************************* UIImage *********************************

#import <iCore/UIImage+Extension.h>
#import <iCore/GifImageSerialization.h>

#import <iCore/ImageTools.h>
#import <iCore/ImageCompress.h>

#pragma mark - ******************************************* NSBundle ********************************

#import <iCore/NSBundle+Path.h>

#pragma mark - ******************************************* NSDate **********************************

#import <iCore/NSDate+CalendarManager.h>

#pragma mark - ******************************************* UIApplication ***************************

#import <iCore/UIApplication+KeyboardFrame.h>

#pragma mark - ******************************************* UINavigation ****************************

#import <iCore/Navigation.h>

#pragma mark - ******************************************* Vendor **********************************

#import <iCore/ZIKCellularAuthorization.h>

#pragma mark - ******************************************* Utility *********************************

#import <iCore/HookUtility.h>
#import <iCore/LocalizdLanguageTool.h>
#import <iCore/Macro_CircularReference.h>
#import <iCore/DeviceAuthorizationManager.h>
#import <iCore/Macro_Singleton.h>
#import <iCore/LocationManager.h>

#pragma mark - ******************************************* Base ************************************

#import <iCore/BaseViewController.h>
#import <iCore/NavigationViewController.h>
#import <iCore/BasePopViewController.h>

// 若是通过引用源码或者lib库的方式使用类库，则需要以 #import "Core.h" 的方式引入头文件
#else

#pragma mark - ****************************************** ConfigManager ****************************

#import "CoreConfigManager.h"

#pragma mark - ****************************************** NSArray **********************************

#import "NSArray+Protect.h"
#import "NSMutableArray+Protect.h"

#pragma mark - ****************************************** NSDictionary *****************************

#import "NSDictionary+Protect.h"
#import "NSMutableDictionary+Protect.h"

#pragma mark - ****************************************** NSObject *********************************

#import "Macro_NSObject.h"
#import "NSObject+Model.h"
#import "NSObject+Invocation.h"

#pragma mark - ****************************************** NSLog ************************************

#import "LogInfo.h"
#import "Macro_NSLog.h"

#pragma mark - ****************************************** NSString *********************************

#import "NSString+URL.h"
#import "NSString+CheckRule.h"
#import "NSString+Attributed.h"
#import "NSString+FontSize.h"
#import "Macro_NSString.h"

#pragma mark - ******************************************* UIDevice ********************************

#import "DeviceInfo.h"
#import "Macro_DeviceInfo.h"

#pragma mark - ******************************************* UIView **********************************

#import "UIView+Extension.h"

#pragma mark - ******************************************* UIViewController ************************

#import "UIViewController+Util.h"

#pragma mark - ******************************************* UIFont **********************************

#import "UIFont+Extension.h"
#import "Macro_UIFont.h"

#pragma mark - ******************************************* UIColor *********************************

#import "Macro_UIColor.h"

#pragma mark - ******************************************* NSBundle ********************************

#import "NSBundle+Path.h"

#pragma mark - ******************************************* NSDate **********************************

#import "NSDate+CalendarManager.h"

#pragma mark - ******************************************* UIApplication ***************************

#import "UIApplication+KeyboardFrame.h"

#pragma mark - ******************************************* UINavigation ****************************

#import "Navigation.h"

#pragma mark - ******************************************* UIImage *********************************

#import "UIImage+Extension.h"
#import "GifImageSerialization.h"

#import "ImageTools.h"
#import "ImageCompress.h"

#pragma mark - ******************************************* Vendor **********************************

#import "ZIKCellularAuthorization.h"

#pragma mark - ******************************************* Utility *********************************

#import "HookUtility.h"
#import "LocalizdLanguageTool.h"
#import "Macro_CircularReference.h"
#import "RestrictionInput.h"
#import "DeviceAuthorizationManager.h"
#import "Macro_Singleton.h"
#import "LocationManager.h"

#pragma mark - ******************************************* Base ************************************

#import "BaseViewController.h"
#import "NavigationViewController.h"
#import "BasePopViewController.h"

#endif

