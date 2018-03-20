//
//  iCustomKit.h
//  iCustomKit
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

// 若是通过引用Framework的方式使用类库，则需要以 #import <iCustomKit/iCustomKit.h> 的方式引入头文件
#if __has_include(<iCustomKit/iCustomKit.h>)

//! Project version number for PCustomKit.
FOUNDATION_EXPORT double PCustomKitVersionNumber;

//! Project version string for PCustomKit.
FOUNDATION_EXPORT const unsigned char PCustomKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <iCustomKit/PublicHeader.h>

#pragma mark - ****************************************** Extensions *******************************

#import <iCustomKit/PBaseViewController+PLoadStatusView.h>
#import <iCustomKit/PBaseViewController+PToast.h>
#import <iCustomKit/PBaseViewController+PHUD.h>
#import <iCustomKit/UIView+PHUD.h>
#import <iCustomKit/UIView+PToast.h>
#import <iCustomKit/UIImage+PImage.h>
#import <iCustomKit/UIButton+PBlock.h>
#import <iCustomKit/UIButton+PImageTitleSpacing.h>

#pragma mark - ****************************************** ViewControllers **************************

#import <iCustomKit/PBaseViewController.h>
#import <iCustomKit/PWebViewController.h>

#pragma mark - ****************************************** Views ************************************

#import <iCustomKit/PWKWebView.h>
#import <iCustomKit/PImgPickerTool.h>
#import <iCustomKit/PExpandTouchRegionButton.h>

#pragma mark - ****************************************** Vendor ***********************************

#import <iCustomKit/PBaseResource.h>
#import <iCustomKit/PNetWorkHttpStubConfig.h>
#import <iCustomKit/PNetResourecManager.h>

#pragma mark - ****************************************** Utilities ********************************

#import <iCustomKit/PMacro_NSLog.h>
#import <iCustomKit/PMacro_BaseAPIURL.h>
#import <iCustomKit/PMacro_CustomKitBundle.h>

// 若是通过引用源码或者lib库的方式使用类库，则需要以 #import "iCustomKit.h" 的方式引入头文件
#else

#pragma mark - ****************************************** Extensions *******************************

#import "PBaseViewController+PLoadStatusView.h"
#import "PBaseViewController+PToast.h"
#import "PBaseViewController+PHUD.h"
#import "UIView+PHUD.h"
#import "UIView+PToast.h"
#import "UIImage+PImage.h"
#import "UIButton+PBlock.h"
#import "UIButton+PImageTitleSpacing.h"

#pragma mark - ****************************************** ViewControllers **************************

#import "PBaseViewController.h"
#import "PWebViewController.h"

#pragma mark - ****************************************** Views ************************************

#import "PWKWebView.h"
#import "PImgPickerTool.h"
#import "PExpandTouchRegionButton.h"

#pragma mark - ****************************************** Vendor ***********************************

#import "PBaseResource.h"
#import "PNetWorkHttpStubConfig.h"
#import "PNetResourecManager.h"

#pragma mark - ****************************************** Utilities ********************************

#import "PMacro_CustomKitBundle.h"
#import "PMacro_BaseAPIURL.h"
#import "PMacro_NSLog.h"

#endif

